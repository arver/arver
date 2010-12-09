module Arver
  class CommandWrapper

    attr_accessor :command, :arguments_array, :return_value, :output
  
    def self.create( cmd, args = [] )
      c = CommandWrapper.new
      c.command= cmd
      c.arguments_array= args
      c
    end

    def escaped_command
      Escape.shell_command([ command ] + arguments_array )
    end
  
    def escaped_total_command( input, masked=false )
      if( input.empty? )
        self.escaped_command
      else
        input = "**********" if masked
        Escape.shell_command( ["echo", input] ) + " | " + self.escaped_command
      end
    end

    def escaped_total_command_masked( input )
      self.escaped_total_command( input, true )
    end
    
    def execute( input = "")
      Arver::Log.trace( "** Execute: "+self.escaped_total_command_masked( input ) )
      self.run( self.escaped_total_command( input ) )
    end
    
    
    def success?
      return_value == 0
    end
    
    def run( command )
      if( Arver::RuntimeConfig.instance.test_mode || Arver::RuntimeConfig.instance.dry_run )
        self.output= ""
        self.return_value= 0
      else
        self.output= `#{command}`
        self.return_value= $?
      end

      self.success?
    end
  end
end
