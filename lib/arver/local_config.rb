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
    
    def default
      { "arver_config" => ".arver", "username" => "" }
    end
    
    def load_file( filename )
      if File.exists?( filename )
        YAML.load( File.read(filename) ) 
      else
        default
      end
    end
    
    def save
      File.open( ".arver.local", 'w' ) { |f| f.write( @config.to_yaml ) }
    end

    def username
      @config['username']
    end  

    def config_dir
      @config['arver_config']
    end  

    def config_dir= directory
      @config['arver_config']= directory
    end  
  end
end