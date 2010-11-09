module Arver
  class CloseAction < Action
    def execute_partition( partition )
        Arver::Log.info( "closing: "+partition.path )
        caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "luksClose", "#{partition.name}"], partition.parent.address )
        caller.execute 
    end
  end
end