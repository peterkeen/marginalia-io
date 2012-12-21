require 'thor'
require 'open3'
require 'json'

class Marginalia::IO::CLI < Thor
  include Thor::Actions

  class_option :host, :type => :string, :desc => "Marginalia hostname", :default => 'www.marginalia.io'

  desc "login", "Login to Marginalia"
  def login
    auth = Marginalia::IO::Auth.new(options[:host])
    auth.delete_credentials
    auth.login
  end

  desc "logout", "Logout of Marginalia"
  def logout
    auth = Marginalia::IO::Auth.new(options[:host])
    auth.delete_credentials
  end

  desc "list", "List all notes"
  def list
    api.all.sort_by{ |n| n['updated_at'] }.reverse.each do |note|
      puts "#{note['id'].to_s.rjust(4)} #{note['updated_at'][0,10]} #{note['title']}"
    end
  end

  desc "search QUERY", "List all notes matching a given query"
  def search(query)
    api.search(query).sort_by{|n|n['updated_at']}.reverse.each do |note|
      puts "#{note['id'].to_s.rjust(4)} #{note['updated_at'][0,10]} #{note['title']}"
    end
  end

  desc "show ID", "Show the given note in the pager"
  def show(id)
    note = api.get(id)
    body = """title:   #{note['title']}
id:      #{note['id']}
created: #{note['created_at']}
updated: #{note['updated_at']}

#{note['body'].delete("\C-M")}
"""

    temp = Tempfile.new(["notes", ".md"])
    temp.write body
    temp.flush
    system(ENV['PAGER'], temp.path)
  end

  desc "edit ID", "Edit the given note in the editor"
  def edit(id)
    note = api.get(id)
    if note.nil?
      raise Thor::Error.new "Unknown note id #{id}"
    end
    body = """title:   #{note['title']}
id:      #{note['id']}
created: #{note['created_at']}
updated: #{note['updated_at']}

#{note['body'].delete("\C-M")}
"""
    temp = Tempfile.new(["note", ".md"])
    temp.write body
    temp.flush

    system("#{ENV['EDITOR']} #{temp.path}")

    temp.rewind
    contents = temp.read

    headers, body = contents.split(/\n\n/, 2)

    api.update(id, body)
  end

  desc "append ID", "Append to the given note"
  def append(*args)
    id = args.shift
    raise Thor::Error.new "Expected an id" unless id

    body = args.join(" ")
    if body.strip == ""
      temp = Tempfile.new(['journal', '.md'])
      system(ENV['EDITOR'], temp.path)
      body = temp.read
    end

    if body.strip == ""
      exit 0
    end

    api.append(id, body)
  end

  desc "dataappend ID KEY=VALUE ...", "Append a data block to the given note"
  def dataappend(*args)
    id = args.shift
    raise Thor::Error.new "Expected an id" unless id

    raise Thor::Error.new "Expected at least one key=value pair" unless args.length > 0

    data = {}
    args.each do |arg|
      key, value = arg.split('=')
      data[key] = value
    end

    body = <<HERE
```data
#{JSON.dump(data)}
```
HERE
    api.append(id, body)
  end

  desc "create TITLE", "Create a note with the given title"
  def create(*args)
    title = args.join(" ")
    temp = Tempfile.new(['journal', '.md'])
    system(ENV['EDITOR'], temp.path)
    body = temp.read
    if body.strip == ""
      exit 0
    end

    resp = api.create(title, body).parsed_response
    puts "Created note #{resp['id']}"

  end

  default_task :list

  no_tasks do
    def api
      Marginalia::IO::API.new(options[:host])
    end
  end

end
