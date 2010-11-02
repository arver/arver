module Arver
  class SSHCommandWrapper < CommandWrapper
    
    attr_accessor :host, :user, :port
    
    def initialize( cmd, args, host, user="root", port="22" )
      self.host= host
      self.user= user
      self.port= port
      super( cmd, args )
    end
    
    def ecaped_command
      Escape.shell_command( "ssh", "-p #{port}", "#{user}@#{host}", super.escape_command ) 
    end
  end
end