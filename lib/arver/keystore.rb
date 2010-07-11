module Arver
  class Keystore
      
    include Singleton
    
    def initialize
      @keys = {}
    end
    
    def read_from_disk
      @keys = YAML.load(KeySaver.read)
    end
    
    def save_to_disk
      KeySaver.save(@keys.to_yaml)
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