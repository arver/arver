module Arver
  class Keystore
      
    include Singleton
    
    attr_accessor :username
        
    def initialize
      @keys = {}
      self.username= Arver::LocalConfig.instance.username
    end
    
    def load
      flush_keys
      KeySaver.read( self.username ).each do | loaded |
        @keys.merge!( YAML.load( loaded ) )
      end
    end
    
    def save
      purge_keys
      KeySaver.save(username, @keys.to_yaml)
    end
    
    def purge_keys
      KeySaver.purge_keys( username )
    end
    
    def flush_keys
      @keys = {}
    end
  
    def luks_key(partition)
      @keys[partition.path] unless ! @keys[partition.path]
    end
    
    def add_luks_key(partition, luks_key)
      @keys[partition.path] = luks_key
    end
    
  end
end  