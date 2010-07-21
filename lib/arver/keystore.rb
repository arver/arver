module Arver
  class Keystore
      
    include Singleton
    
    attr_accessor :username
        
    def initialize
      @keys = {}
      username = Arver::LocalConfig.instance.username
    end
    
    def read_from_disk
      @keys = YAML.load( KeySaver.read( username ) )
    end
    
    def save_to_disk
      KeySaver.save(username, @keys.to_yaml)
    end
    
    def flush_keys
      @keys = {}
    end
  
    def luks_key(partition)
      @keys[partition.name]
    end
    
    def add_luks_key(partition, luks_key)
      @keys[partition.name] = luks_key
    end
    
  end
end  