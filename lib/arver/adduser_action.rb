module Arver
  class AdduserAction < Action
        
    def initialize( target_list )
      super( target_list )
      self.open_keystore
      self.new_key_generator
    end
    
    def pre_action
      tl = ""
      target_list.each { |t| tl += ( tl.empty? ? "": ", " )+t.name }
      Arver::Log.info( "adduser was called with target(s) #{tl} and user #{target_user} (slot-no #{slot_of_target_user})" )
      true
    end
    
    def needs_target_user?
      true
    end

    def verify?( partition )
      if not Arver::RuntimeConfig.instance.ask_password then
        return false unless load_key( partition )
      else
        self.key= ask("Enter the password for the volume: #{partition.device}") {|q| q.echo = false}
      end
      true
    end

    def execute_partition( partition )
      Arver::Log.info( "Generating keys for partition #{partition.device}" )

      # generate a key for the new user
      Arver::Log.debug( "generate_key (#{target_user},#{partition.path})" )
      
      newkey = generator.generate_key( target_user, partition )

      caller = Arver::LuksWrapper.addKey( slot_of_target_user.to_s, partition )
      caller.execute( key + "\n" + newkey )
      
      unless( caller.success? )
        Arver::Log.error( "Could not add user to #{partition.path} \n" + caller.output )
        generator.remove_key( target_user, partition )
      end
      true
    end
    
    def post_action
      generator.dump
      false
    end
  end
end
