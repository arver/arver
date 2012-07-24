module Arver
  class Keystore
    class << self
      def for( username )
        if username.empty?
          Log.error("no user given, cannot create keystore")
          return
        end
        @@keystores           ||= {}
        @@keystores[username] ||= Keystore.new( username )
      end
      
      def reset
        @@keystores = {}
      end
    end
          
    attr_accessor :username, :loaded
        
    def initialize( name )
      @keys = {}
      @key_versions = {}
      self.username= name
      self.loaded = false
    end
    
    def load
      flush_keys
      KeySaver.read( self.username ).each do | loaded |
        YAML.load( loaded ).each do | target, key |
          load_luks_key(target,key)
        end
      end
      self.loaded = true
    end
    
    def save
      if loaded
        KeySaver.save(username, @keys.to_yaml)
      else
        KeySaver.add(username, @keys.to_yaml)
      end 
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
      if( new_key.kind_of? Hash )
        if( ! @keys[partition] || @keys[partition][:time] <= new_key[:time] )
          @keys[partition] = new_key
        end
      else
        unless( @keys[partition] )
          Log.debug("loding key in old format")          
          @keys[partition] = { :key => new_key, :time => 0.0 }
        end
      end
      mark_key_version(partition,@keys[partition])
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
