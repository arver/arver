module Arver
    
  class IOLogger

     include LogLevels

     attr_accessor :level, :stream
  
     def initialize( level, stream = $stdout )
       @level = level
       @stream = stream
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
       stream.write( string.to_s+"\n" )
       stream.flush
     end
  end
end