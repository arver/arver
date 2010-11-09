module Arver
  class OpenAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end

    def execute_partition( partition )
      Arver::Log.info( "opening: "+partition.path )
      key = keystore.luks_key( partition )
      Arver::Log.debug( "Trying to open #{partition.path}" )
      if( key.nil? )
        Arver::Log.error( "No permission on #{partition.path}" )
        next
      end
      caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "luksOpen", "#{partition.device}", "#{partition.name}" ], partition.parent.address )
      caller.execute( key )
    end
  end
end