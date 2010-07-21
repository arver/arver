module Arver
  class Keystore
      
    include Singleton
    
    attr_accessor :username
        
    def initialize
      @keys = {}
      self.username= Arver::LocalConfig.instance.username
    end
    
    def load
      @keys = {}
      KeySaver.read( self.username ).each do | loaded |
        @keys.merge!( YAML.load( loaded ) )
      end
    end
    
    def purge_and_save
      KeySaver.purge_keys( username )
      KeySaver.save(username, @keys.to_yaml)
    end
    
    def save
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