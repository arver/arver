module Arver
  class SSHCommandWrapper < CommandWrapper
    
    attr_accessor :host, :user, :port
    
    def initialize( cmd, args, host )
      self.host= host
      super( cmd, args )
    end
    
    def escaped_command
      Escape.shell_command( [ "ssh", "-p #{host.port}", "#{host.username}@#{host.address}", super ] ) 
    end
    
  end
end
