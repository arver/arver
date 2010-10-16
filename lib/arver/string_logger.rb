module Arver
    
  class StringLogger

     include LogLevels

     attr_accessor :level, :log
  
     def initialize( level, string = "" )
       @level = level
       @log = string
     end
     
     def trace( string )
       write( string ) if level <= Trace
     end
     def debug( string )
       write( string ) if level <= Debug
     end
     def info( string)
       write( string ) if level <= Info
     end
     def warn( string )
       write( string ) if level <= Warn
     end
     def error( string )
       write( string ) if level <= Error
     end
     def write( string )
       self.log= self.log + string.to_s
     end
  end
end