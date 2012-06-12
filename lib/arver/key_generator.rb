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
      @keys[user] ||= {}
      @keys[user][partition.path] = { :key => luks_key, :time => Time.now.to_f }
    end

    def remove_key( user, partition )
      @keys[user].delete( partition.path )
    end
    
    def dump
      @keys.each do | user, user_keys |
        KeySaver.add( user, user_keys.to_yaml ) unless user_keys.empty?
      end
      @keys = {}
    end
  end
end
