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
      sudo = if as_root && host.username != "root" then "sudo" else "" end
      "ssh -p #{shellescape(host.port)} #{shellescape(host.username)}@#{shellescape(host.address)} #{sudo} #{super}" 
    end
  end
end
