module Arver
  class SSHCommandWrapper < CommandWrapper
    
    attr_accessor :host, :user, :port, :as_root
    
    def initialize( cmd, args, host, as_root = false )
      self.host= host
      self.as_root= as_root
      super( cmd, args )
    end
    
    def escaped_command
      return Escape.shell_command( [ "ssh", "-p #{host.port}", "#{host.username}@#{host.address}", "sudo", super ] ) if( as_root && host.username != "root" )
      Escape.shell_command( [ "ssh", "-p #{host.port}", "#{host.username}@#{host.address}", super ] ) 
    end
    
  end
end
