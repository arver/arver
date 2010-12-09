module Arver
  class Log
    
    include LogLevels
    
    def self.logger()
      @@logger ||= IOLogger.new
    end
    def self.logger=( logger )
      @@logger = logger
    end
    
    def self.trace( string )
      logger.trace( string )
    end
    def self.debug( string )
      logger.debug( string )
    end
    def self.info( string )
      logger.info( string )
    end
    def self.warn( string )
      logger.warn( string )
    end
    def self.error( string )
      logger.error( string )
    end
    def self.write( string )
      logger.write( string )
    end
    def self.level( num )
      logger.level=( num )
    end

    
  end
end
      
    
