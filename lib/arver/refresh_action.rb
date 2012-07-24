module Arver
  class RefreshAction < Action
        
    def initialize( target_list )
      super( target_list )
      self.open_keystore
      self.new_key_generator
    end
   
    def pre_action
      tl = ""
      target_list.each { |t| tl += ( tl.empty? ? "": ", " )+t.name }
      Arver::Log.info( "refresh was called with target(s) #{tl}" )
    end
    
    def verify?( partition )
      unless Arver::RuntimeConfig.instance.ask_password
        return load_key( partition )
      end
      self.key= ask("Enter the password for the volume: #{partition.device}") {|q| q.echo = false}
      true
    end

    def execute_partition( partition )
      Arver::Log.info( "Generating a new key for partition #{partition.device}" )

      slot_of_user = Arver::Config.instance.slot( Arver::LocalConfig.instance.username )
      newkey = generator.generate_key( partition )

      caller = Arver::LuksWrapper.changeKey( slot_of_user.to_s, partition )
      caller.execute( key + "\n" + newkey )

      unless( caller.success? )
        Arver::Log.error( "Warning: i believe that i could not change the key on #{partition.path}, therefore i kept the old one!" )
        Arver::Log.error( "Maybe the version of cryptsetup on that host does not yet support the luksChangeKey command. " )
        Arver::Log.error( "Please verify that the old one still works. If the changeKey did in fact succeed, the plaintext key would now be: #{key}" )
        Arver::Log.debug( "The output was: #{caller.output}" )
        generator.remove_key( partition )
      end
    end
    
    def post_action
      self.generator.dump( self.keystore )
    end
  end
end
