module Arver
  class DeluserAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end
    
    def needs_target_user?
      true
    end
    
    def verify?( partition )
      unless( load_key( partition ) )
        Arver::Log.error( "No permission on " + partition.path )
        return false
      end
      true
    end
    
    def execute_partition( partition )
      Arver::Log.info( "remove user user #{target_user} (slot-no #{slot_of_target_user.to_s}) from #{partition.path}" )
      
      caller = Arver::LuksWrapper.killSlot( slot_of_target_user.to_s, partition )
      caller.execute( key )
      unless( caller.success? )
        Arver::Log.error( "Could not remove user:\n" + caller.output )
      end
    end
  end
end
