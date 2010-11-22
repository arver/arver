module Arver
  class CloseAction < Action
    def execute_partition( partition )
        Arver::Log.info( "closing: "+partition.path )
        caller = Arver::LuksWrapper.close( partition )
        caller.execute 
    end
  end
end
