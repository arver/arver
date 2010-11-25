module Arver
  class OpenAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end

#    def pre_run_execute_partition( partition )
#      self.target_list -= [ partition ] if Arver::LuksWrapper.open?(partition).execute
#    end

    def execute_partition( partition )
      Arver::Log.info( "opening: "+partition.path )
      key = keystore.luks_key( partition )
      Arver::Log.debug( "Trying to open #{partition.path}" )
      if( key.nil? )
        Arver::Log.error( "No permission on #{partition.path}" )
        return true
      end
      caller = Arver::LuksWrapper.open( partition )
      caller.execute( key )
    end

    def pre_host( host )
      return true if host.pre_open.nil?
      Arver::Log.info( "Running script: " + host.pre_open + " on " + host.name )
      c = Arver::SSHCommandWrapper.new( host.pre_open, [] , host, true )
      c.execute
    end

    def pre_partition( partition )
      return true if partition.pre_open.nil?
      Arver::Log.info( "Running script: " + partition.pre_open + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.new( partition.pre_open, [] , partition.parent, true )
      c.execute
    end

    def post_partition( partition )
      return true if partition.post_open.nil?
      Arver::Log.info( "Running script: " + partition.post_open + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.new( partition.post_open, [] , partition.parent, true )
      c.execute
    end

    def post_host( host )
      return true if host.post_open.nil?
      Arver::Log.info( "Running script: " + host.post_open + " on " + host.name )
      c = Arver::SSHCommandWrapper.new( host.post_open, [] , host, true )
      c.execute
    end

  end
end
