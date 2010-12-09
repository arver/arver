module Arver
  class SSHCommandWrapper < CommandWrapper
    
    attr_accessor :host, :user, :port, :as_root
    
    def self.create( cmd, args, host, as_root = false )
      c = SSHCommandWrapper.new
      c.host= host
      c.as_root= as_root
      c.command= cmd
      c.arguments_array= args
      c
    end
    
    def escaped_command
      return Escape.shell_command( [ "ssh", "-p #{host.port}", "#{host.username}@#{host.address}", "sudo", super ] ) if( as_root && host.username != "root" )
      Escape.shell_command( [ "ssh", "-p #{host.port}", "#{host.username}@#{host.address}", super ] ) 
    end
    
  end
end
