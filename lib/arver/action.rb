module Arver
  class Action
    
    attr_accessor :keystore, :target_list, :target_user, :slot_of_target_user, :generator, :key
    
    def initialize( target_list )
      self.target_list= target_list
    end
    
    def on_user( username )
      return true unless needs_target_user?
      self.slot_of_target_user= Arver::Config.instance.slot( username )
      if slot_of_target_user.nil?
        Arver::Log.error( "No such user" )
        return false
      end
      self.target_user= username
      true
    end
    
    def needs_target_user?
      false
    end
    
    def new_key_generator
      self.generator= Arver::KeyGenerator.new
    end
    
    def open_keystore
      self.keystore= Arver::Keystore.instance
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
      self.key= keystore.luks_key( partition )

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
