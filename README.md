# Marginalia CLI

[Marginalia](https://www.marginalia.io/) is a web-based journaling and
note taking app using Markdown. It also has a full featured [RESTful API](https://www.marginalia.io/apidocs), and this is the Ruby API client for it, as well as
an example command line application.

## Installation

Add this line to your application's Gemfile:

    gem 'marginalia-io'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marginalia-io

## Usage

```
Tasks:
  marginalia append ID     # Append to the given note
  marginalia edit ID       # Edit the given note in the editor
  marginalia help [TASK]   # Describe available tasks or one specific task
  marginalia list          # List all notes
  marginalia login         # Login to Marginalia
  marginalia logout        # Logout of Marginalia
  marginalia search QUERY  # List all notes matching a given query
  marginalia show ID       # Show the given note in the pager

Options:
  [--host=HOST]  # Marginalia hostname
                 # Default: www.marginalia.io
```

The API is pretty simple right now:

```ruby
require 'marginalia-io'

api    = Marginalia::IO::API.new # will prompt for credentials if not logged in

all    = api.all                 # Get all of the notes
blurb  = api.search('blurb')     # Get all of the notes matching 'blurb'
note_5 = api.get(5)              # Get the note with id 5

api.append(5, "Hi There")        # Append "Hi There" with a timestamp to the end of not 5

api.update(5, "Hello There")     # replace the body of note 5 with "Hello There"
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
