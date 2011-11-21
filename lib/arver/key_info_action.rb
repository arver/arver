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
      Arver::Log.write( " #{h.name}" )
    end
    def pre_partition(p)
      if keystore.luks_key?(p)
        line = "   +"
      else
        line = "   -"
      end
      versions = keystore.key_versions(p).collect do |v| 
        if v == 0 
          "0" 
        else 
          Date.strptime(v.to_s,'%s') 
        end
      end
      Arver::Log.write( "#{line} #{p.device_path} (#{versions.join(", ")})" )
    end
  end
end
