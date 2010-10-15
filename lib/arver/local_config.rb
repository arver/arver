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
      { :arver_config => ".arver", :username => "" }
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
      @config[:username]
    end  

    def username= username
      @config[:username] = username
    end 

    def config_dir
      @config[:arver_config]
    end  

    def config_dir= directory
      @config[:arver_config]= directory
    end  

    def dry_run
      @config[:dry_run]
    end  

    def test_mode
      @config[:test_mode]
    end  

    def test_mode= test_mode
      @config[:test_mode] = test_mode
    end 

    def dry_run= dry_run
      @config[:dry_run] = dry_run
    end 

    def ask_password
      @config[:ask_password]
    end  

    def ask_password= ask_password
      @config[:ask_password] = ask_password
    end 

    def force
      @config[:force]
    end  

    def force= force
      @config[:force] = force
    end 

    def violence
      @config[:violence]
    end  

    def violence= violence
      @config[:violence] = violence
    end 
  end
end
