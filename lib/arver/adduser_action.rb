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
      Arver::Log.info( "adduser was called with target(s) #{tl} and user #{target_user} (slot-no #{slot_of_target_user})" )
      true
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
        return false
      end
      
      # generate a key for the new user
      Arver::Log.debug( "generate_key (#{target_user},#{partition.path})" )
      
      newkey = generator.generate_key( target_user, partition )

      caller = Arver::LuksWrapper.addKey( slot_of_target_user.to_s, partition )
      caller.execute( a_valid_key + "\n" + newkey )
      
      unless( caller.success? )
        Arver::Log.error( "Could not add user to #{partition.path} \n" + caller.output )
        generator.remove_key( target_user, partition )
      end
      true
    end
    
    def post_execution
      generator.dump
    end
  end
end
