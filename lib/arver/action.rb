module Arver
  class Action
    
    attr_accessor :keystore, :target_list, :target_user, :slot_of_target_user, :generator
    
    def initialize( target_list )
      self.target_list= target_list
    end
    
    def on_user( username )
      return true unless needs_target_user?
      self.slot_of_target_user= Arver::Config.instance.slot( username )
      if slot_of_target_user.nil?
        Arver::Log.error( "no such user" )
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
      if( node.target?( self.target_list ) )
        unless( node.run_action( self ) )
          Arver::Log.debug( "Execution on "+node.name+" failed. aborting" )
          return false
        end
      end
      true
    end
    
    def pre_action
      true
    end
    
    def post_action
      true
    end
    
    def pre_host( host )
      true
    end
    
    def verify?( partition )
      true
    end

    def pre_partition( partition )
      true
    end
    
    def execute_partition( partition )
      true
    end
    
    def post_partition( partition )
      true
    end
    
    def post_host( host )
      true
    end
  end
end
