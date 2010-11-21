module Arver
  class CreateAction < Action
    
    def initialize( target_list )
      super( target_list )
      self.open_keystore
      self.new_key_generator
    end

    def pre_run_execute_partition( partition )
        key = self.keystore.luks_key( partition )
        if( ! key.nil? and ! Arver::RuntimeConfig.instance.force )
          Arver::Log.warn( "DANGEROUS: you do have already a key for partition #{partition.path} - returning (apply --force to continue)" )
          return
        end
    end
    
    def execute_partition( partition )
      Arver::Log.info( "creating: "+partition.path )
      
      slot_of_user = Arver::Config.instance.slot( Arver::LocalConfig.instance.username )
      Arver::Log.debug( "generating a new key for partition #{partition.device} on #{partition.path}" )

      # checking if disk is not already LUKS formatted
      Arver::Log.debug( "checking if disk is not already LUKS formatted..." )

      caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "luksDump", partition.device_path ], partition.parent.address )
      caller.execute
      if caller.output.include?('LUKS header information') then
        Arver::Log.warn( "VERY DANGEROUS: the partition #{partition.device} is already formatted with LUKS - returning (continue with --violence)" ) 
        if Arver::RuntimeConfig.instance.violence then
          Arver::Log.info( "you applied --violence, so we will continue ..." )
        else
          Arver::Log.info( "for more information see /tmp/luks_create_error.txt" )
          system("echo \"#{caller.output}\" > /tmp/luks_create_error.txt")
          return if not Arver::RuntimeConfig.instance.violence
        end
      end
      
      Arver::Log.trace( "starting key generation..." )
      key = self.generator.generate_key( Arver::LocalConfig.instance.username, partition )
      caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "--key-slot=#{slot_of_user.to_s}", "--cipher=aes-cbc-essiv:sha256", "--key-size=256", "luksFormat", partition.device_path ], partition.parent.address )
      caller.execute( key )
      unless( caller.success? )
        self.generator.remove_key( Arver::LocalConfig.instance.username, partition )
      end
    end
    
    def pre_partition( partition )
      #TODO:
      #  add all the fancy new attributes (pre_open, pre_create, post_open...) to the partition_hirarchy_node objects
      #  script = partition.pre_create_script
      #  then execute the script....
    end
    
    def post_execution
      self.generator.dump
    end
  end
end