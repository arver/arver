module Arver
  class LocalConfig

    #this Config Object holds the local defaults for Arver. All options correspond to the ones set in .arver.local
    
    include Singleton
    
    def initialize
      @config = {}
      self.load
    end

    def path
      File.expand_path( "~/.arver" )
    end
    
    def load
      @config= load_file( path )
    end
    
    def default
      { :config_dir => "~/.arverdata", :username => "" }
    end
    
    def load_file( filename )
      if File.exists?( filename )
        YAML.load( File.read(filename) ) 
      else
        default
      end
    end
    
    def save
      File.open( path, 'w' ) { |f| f.write( @config.to_yaml ) }
    end

    def username
      @config['username']
    end  

    def username= username
      @config['username'] = username
    end 

    def config_dir
      File.expand_path( @config['config_dir'] )
    end  

    def config_dir= directory
      @config['config_dir']= directory
    end  

  end
end
