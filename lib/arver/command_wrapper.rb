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
  
    def execute( input = "" )
      Arver::Log.trace( "** Execute: "+self.escaped_command )
      self.run( escaped_command, input )
    end
    
    
    def success?
      return_value == 0
    end
    
    def run( command, input )
      if( Arver::RuntimeConfig.instance.test_mode || Arver::RuntimeConfig.instance.dry_run )
        self.output= ""
        self.return_value= 0
      else
        IO.popen( command, "w+") do |pipe|
          pipe.puts( input ) unless input.empty?
          pipe.close_write
          self.output= pipe.read
        end
        self.return_value= $?
      end
      self.success?
    end
  end
end
