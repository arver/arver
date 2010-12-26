module Arver
  class CloseAction < Action

    def verify?( partition )
      unless( Arver::LuksWrapper.open?(partition).execute )
        Arver::Log.error( partition.name+" not open. skipping." )
        return false
      end
      true
    end

    def execute_partition( partition )
      Arver::Log.info( "closing: "+partition.path )
      caller = Arver::LuksWrapper.close( partition )
      throw( :abort_action ) unless caller.execute
    end

    def pre_host( host )
      return if host.pre_close.nil?
      Arver::Log.info( "Running script: " + host.pre_close + " on " + host.name )
      c = Arver::SSHCommandWrapper.create( host.pre_close, [] , host, true )
      throw( :abort_action ) unless c.execute
    end

    def pre_partition( partition )
      return if partition.pre_close.nil?
      Arver::Log.info( "Running script: " + partition.pre_close + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.create( partition.pre_close, [] , partition.parent, true )
      throw( :abort_action ) unless c.execute
    end

    def post_partition( partition )
      return if partition.post_close.nil?
      Arver::Log.info( "Running script: " + partition.post_close + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.create( partition.post_close, [] , partition.parent, true )
      throw( :abort_action ) unless c.execute
    end

    def post_host( host )
      return if host.post_close.nil?
      Arver::Log.info( "Running script: " + host.post_close + " on " + host.name )
      c = Arver::SSHCommandWrapper.create( host.post_close, [] , host, true )
      throw( :abort_action ) unless c.execute
    end
  end
end
