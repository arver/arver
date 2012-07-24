module Arver
  class KeyGenerator
    def initialize
      @keys = {}
    end
    
    def generate_key( partition )
      key = ActiveSupport::SecureRandom.base64(192)
      @keys[partition] = key
    end
    
    def remove_key( user, partition )
      @keys.delete( partition )
    end
    
    def dump( keystore )
      return if @keys.empty?
      @keys.each do | partition, key |
        keystore.add_luks_key( partition, key )
      end
      @keys = {}
      keystore.save
    end
  end
end
