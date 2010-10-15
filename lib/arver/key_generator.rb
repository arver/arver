module Arver
  class KeyGenerator
    def initialize
      @keys = {}
    end
    
    def generate_key( user, partition )
      key = ActiveSupport::SecureRandom.base64(192)
      add( user, partition, key )
      key
    end
    
    def add( user, partition, luks_key )
      @keys[user] = {} unless @keys[user]
      @keys[user][partition.path] = luks_key
    end

    def remove_key( user, partition )
      @keys[user].delete( partition.path )
    end
    
    def dump
      @keys.each do | user, user_keys |
        KeySaver.save( user, user_keys.to_yaml )
      end
      @keys = {}
    end
  end
end
