module Arver
  class Action
    
    attr_accessor :keystore, :target_list
    
    def initialize( target_list )
      self.target_list= target_list
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
    
    def post_run
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
