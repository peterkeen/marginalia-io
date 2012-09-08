require 'netrc'

class Marginalia::IO::Auth
  attr_accessor :credentials, :host

  def initialize(host="www.marginalia.io")
    @host = host
  end

  def netrc_path
    default = Netrc.default_path
    encrypted = default + ".gpg"
    if File.exists?(encrypted)
      encrypted
    else
      default
    end
  end

  def get_credentials    # :nodoc:
    @credentials ||= (read_credentials || login)
  end

  def netrc   # :nodoc:
    @netrc ||= begin
      File.exists?(netrc_path) && Netrc.read(netrc_path)
    rescue => error
      if error.message =~ /^Permission bits for/
        perm = File.stat(netrc_path).mode & 0777
        abort("Permissions #{perm} for '#{netrc_path}' are too open. You should run `chmod 0600 #{netrc_path}` so that your credentials are NOT accessible by others.")
      else
        raise error
      end
    end
  end

  def delete_credentials
    if netrc
      netrc.delete(host)
      netrc.save
    end
  end

  def read_credentials
    if netrc
      netrc[host]
    end
  end

  def write_credentials
    FileUtils.mkdir_p(File.dirname(netrc_path))
    FileUtils.touch(netrc_path)
    FileUtils.chmod(0600, netrc_path)
    netrc[host] = self.credentials
    netrc.save
  end

  def login
    print "Email address: "
    username = gets
    print "Password: "
    system "stty -echo"
    password = gets
    system "stty echo"

    self.credentials = [username, password]
    write_credentials
    self.credentials
  end
end
