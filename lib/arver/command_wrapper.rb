module Arver
  class CommandWrapper

    attr_accessor :command, :arguments_array, :return_value, :output
  
    def self.create( cmd, args = [] )
      c = CommandWrapper.new
      c.command= cmd
      c.arguments_array= args
      c
    end

    # copy from shellwords.rb
    def shellescape(str)
      str = str.to_s

      # An empty argument will be skipped, so return empty quotes.
      return "''" if str.empty?

      str = str.dup

      # Treat multibyte characters as is.  It is caller's responsibility
      # to encode the string in the right encoding for the shell
      # environment.
      str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/, "\\\\\\1")

      # A LF cannot be escaped with a backslash because a backslash + LF
      # combo is regarded as line continuation and simply ignored.
      str.gsub(/\n/, "'\n'")
    end

    def escaped_command
      "#{shellescape(command)} " + arguments_array.collect{|c| shellescape(c)}.join(" ")
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
        self.return_value= $?.exitstatus
      end
      self.success?
    end
  end
end
