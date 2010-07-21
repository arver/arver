module Arver
  class LocalConfig
    
    include Singleton
    
    def initialize
      @config = {}
      self.load
    end
    
    def load
      @config= load_file( ".arver.local" )
    end
    
    def load_file( filename )
      if File.exists?( filename )
        YAML.load( File.read(filename) ) 
      else
        {}
      end
    end
    
    def save
      File.open( ".arver.local", 'w' ) { |f| f.write( @config.to_yaml ) }
    end

    def username
      @config['username'] or ""
    end  
  end
end