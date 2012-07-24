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

      newkey = generator.generate_key( partition )

      caller = Arver::LuksWrapper.changeKey( slot_of_target_user.to_s, partition )
      caller.execute( key + "\n" + newkey )

      unless( caller.success? )
        Arver::Log.error( "Warning: i believe that i could not change the key on #{partition.path}, therefore i keep the old one!" )
        Arver::Log.error( "Please verify that the old one still works. If i'm wrong, the key i tried to install would be: #{key}" )
        generator.remove_key( partition )
      end
    end
    
    def post_action
      self.generator.dump( self.keystore )
    end
  end
end
