module Arver
  class Action
    
    attr_accessor :keystore, :target_list, :target_user, :slot_of_target_user, :generator, :key
    
    def initialize( target_list )
      self.target_list= target_list
    end
    
    def on_user( username )
      return true unless needs_target_user?
      unless Arver::Config.instance.exists?(username)
        Arver::Log.error( "No such user" )
        return false
      end
      return false unless verify_key_on_target( username ) 
      self.slot_of_target_user= Arver::Config.instance.slot( username )
      self.target_user= username
      true
    end

    def verify_key_on_target( username )
      Arver::GPGKeyManager.check_key_of( username )
    end

    def needs_target_user?
      false
    end
    
    def new_key_generator
      self.generator= Arver::KeyGenerator.new
    end
    
    def open_keystore
      self.keystore= Arver::Keystore.for( LocalConfig.instance.username )
      keystore.load
    end
    
    def run_on( node )
      node.run_action( self ) if node.target?( self.target_list )
    end
    
    def pre_action
    end
    
    def post_action
    end
    
    def pre_host( host )
    end
    
    def verify?( partition )
      true
    end

    def load_key( partition )
      if Arver::RuntimeConfig.instance.global_key_path
        self.key= keystore.luks_key_for_path( Arver::RuntimeConfig.instance.global_key_path )
      else
        self.key= keystore.luks_key( partition )
      end

      if( key.nil? )
        Arver::Log.error( "No permission on #{partition.path}. Skipping." )
        return false
      end
      true
    end      

    def pre_partition( partition )
    end
    
    def execute_partition( partition )
    end
    
    def post_partition( partition )
    end
    
    def post_host( host )
    end
  end
end
