module Arver
  class CreateAction < Action
    
    def initialize( target_list )
      super( target_list )
      self.open_keystore
      self.new_key_generator
    end

    def verify?( partition )
        key = self.keystore.luks_key( partition )
        if( ! key.nil? and ! Arver::RuntimeConfig.instance.force )
          Arver::Log.warn( "DANGEROUS: you do have already a key for partition #{partition.path} (apply --force to continue)" )
          return false
        end
        true
    end
    
    def execute_partition( partition )
      slot_of_user = Arver::Config.instance.slot( Arver::LocalConfig.instance.username )

      caller = Arver::LuksWrapper.dump( partition )
      caller.execute
 
      if caller.output.include?('LUKS header information') then
        Arver::Log.warn( "VERY DANGEROUS: the partition #{partition.device} is already formatted with LUKS - returning (continue with --violence)" ) 
        Arver::Log.warn( "If you wish to integrate an existing disk into arver use --add-user #{Arver::LocalConfig.instance.username} instead." ) 
        if Arver::RuntimeConfig.instance.violence then
          Arver::Log.info( "you applied --violence, so we will continue ..." )
        else
          Arver::Log.info( "for more information see /tmp/luks_create_error.txt" )
          system("echo \"#{caller.output}\" > /tmp/luks_create_error.txt")
          throw( :abort_action ) if not Arver::RuntimeConfig.instance.violence
        end
      end
      
      Arver::Log.info( "creating: "+partition.path )
      
      Arver::Log.debug( "generating a new key for partition #{partition.device} on #{partition.path}" )
      key = self.generator.generate_key( partition )
      caller = Arver::LuksWrapper.create( slot_of_user.to_s, partition )
      caller.execute( key )
      unless( caller.success? )
        Arver::Log.error( "Could not create Partition!" )
        self.generator.remove_key( partition )
      end
    end
    
    def post_action
      self.generator.dump( self.keystore )
    end
  end
end
