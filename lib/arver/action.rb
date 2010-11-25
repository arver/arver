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
    
    def pre_run( node )
      success = true
      if( node.is_target( self.target_list ) )
        success &= node.pre_execute( self )
      end
      success
    end
    
    def run( node )
      success = true
      if( node.is_target( self.target_list ) )
        success &= node.execute( self )
        unless( success )
          Arver::Log.debug( "Execution on "+node.name+" failed. aborting" )
          return false
        end
      end
      success
    end
    
    def pre_execution
      true
    end
    
    def post_execution
    end
    
    def pre_run_execute_partition( partition )
      true
    end
    
    def pre_host( host )
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
