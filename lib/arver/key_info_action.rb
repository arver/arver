module Arver
  class KeyInfoAction < Action
    def initialize(targets)
      super(targets)
      self.open_keystore
    end
    def pre_action
      Arver::Log.write( "Listing keys: (+) available (-) not available: " )
    end 
    def pre_host(h)
      Arver::Log.write( " + #{h.name}" )
    end
    def pre_partition(p)
      if keystore.luks_key?(p)
        Arver::Log.write( "     + #{p.device_path}" )
      else
        Arver::Log.write( "     - #{p.device_path}" )
      end
    end
  end
end
