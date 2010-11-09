module Arver
  class AdduserAction < Action
        
    def initialize( target_list )
      super( target_list )
      self.open_keystore
      self.new_key_generator
    end
    
    def pre_execution
      tl = ""
      target_list.each { |t| tl += ( tl.empty? ? "": ", " )+t.name }
      Arver::Log.info( "adduser was called with target(s) #{tl} and user slot-no #{self.slot_of_user}" )
    end
    
    def needs_target_user?
      true
    end

    def execute_partition( partition )
      Arver::Log.info( "Generating keys for partition #{partition.device}" )
      if not Arver::RuntimeConfig.instance.ask_password then
        # get a valid key for this partition
        a_valid_key = keystore.luks_key( partition )
      else
        a_valid_key = ask('Enter the password for this volume: ') {|q| q.echo = false}
      end

      if( a_valid_key.nil? )
        Arver::Log.error( "No permission on #{partition.path}" )
        return
      end
      
      # generate a key for the new user
      Arver::Log.debug( "generate_key (#{user},#{partition.path})" )
      
      newkey = gen.generate_key( user, partition )

      caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "--key-slot #{slot_of_user.to_s}", "luksAddKey", "#{partition.device}" ], partition.parent.address )
      caller.execute( a_valid_key + "\n" + newkey )
      
      unless( caller.success? )
        gen.remove_key( user, partition )
      end
    end
    
    def post_execution
      self.generator.dump
    end
  end
end