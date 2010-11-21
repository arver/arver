module Arver
  class DeluserAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end
    
    def needs_target_user?
      true
    end
    
    def execute_partition( partition )
      Arver::Log.info( "remove user user #{target_user} (slot-no #{slot_of_target_user}) from #{partition.path}" )
      if not Arver::RuntimeConfig.instance.ask_password then
        # get a valid key for this partition
        a_valid_key = keystore.luks_key( partition )
      else
        a_valid_key = ask('Enter the password for this volume: ') {|q| q.echo = false}
      end
      
      if( a_valid_key.nil? )
        Arver::Log.error( "No permission on this target" )
        return
      end
      
      caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "luksKillSlot", partition.device_path, "#{slot_of_target_user}" ], partition.parent.address )
      caller.execute( a_valid_key )
      unless( caller.success? )
        log.error( "Could not remove user:\n" + caller.output )
      end
    end
  end
end