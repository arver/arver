module Arver
  class Action
    
    attr_accessor :keystore, :target_list, :slot_of_user, :generator
    
    def initialize( target_list )
      self.target_list= target_list
    end
    
    def on_user( username )
      return true unless needs_target_user? 
      self.slot_of_user= Arver::Config.instance.slot( username )
      if slot_of_user.nil?
        Arver::Log.error( "no such user" )
        false
      end
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
    
    def pre_run( node )
      if( node.is_target( self.target_list ) )
        node.pre_execute( self )
      end
    end
    
    def run( node )
      if( node.is_target( self.target_list ) )
        node.execute( self )
      end
    end
    
    def pre_execution
    end
    
    def post_execution
    end
    
    def pre_run_execute_partition( partition )
    end
    
    def pre_host( host )
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
