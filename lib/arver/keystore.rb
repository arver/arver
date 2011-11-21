module Arver
  class Keystore
      
    include Singleton
    
    attr_accessor :username
        
    def initialize
      @keys = {}
      @key_versions = {}
      self.username= Arver::LocalConfig.instance.username
    end
    
    def load
      flush_keys
      KeySaver.read( self.username ).each do | loaded |
        YAML.load( loaded ).each do | target, key |
          load_luks_key(target,key)
        end
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
      @keys[partition.path][:key] unless ! @keys[partition.path]
    end
    
    def load_luks_key(partition, new_key)
      mark_key_version(partition,new_key)
      if( new_key.kind_of? Hash )
        if( ! @keys[partition] || @keys[partition][:time] <= new_key[:time] )
          @keys[partition] = new_key
        end
      else
        unless( @keys[partition] )
          @keys[partition] = { :key => new_key, :time => 0.0 }
        end
      end
    end

    def mark_key_version(path,key)
      @key_versions[path] ||= []
      @key_versions[path] << key[:time]
    end

    def key_versions(partition)
      @key_versions[partition.path] || []
    end
    
    def add_luks_key(partition, new_key)
      @keys[partition.path] = { :key => new_key, :time => Time.new.to_f }
    end

    def luks_key?(partition)
      ! @keys[partition.path].nil?
    end
  end
end  
