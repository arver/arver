module Arver
  class CloseAction < Action

    def verify?( partition )
      if( Arver::LuksWrapper.check_closed?(partition) )
        Arver::Log.error( partition.name+" not open. skipping." )
        return false
      end
      true
    end

    def execute_partition( partition )
        Arver::Log.info( "closing: "+partition.path )
        caller = Arver::LuksWrapper.close( partition )
        caller.execute 
    end

    def pre_host( host )
      return true if host.pre_close.nil?
      Arver::Log.info( "Running script: " + host.pre_close + " on " + host.name )
      c = Arver::SSHCommandWrapper.new( host.pre_close, [] , host, true )
      c.execute
    end

    def pre_partition( partition )
      return true if partition.pre_close.nil?
      Arver::Log.info( "Running script: " + partition.pre_close + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.new( partition.pre_close, [] , partition.parent, true )
      c.execute
    end

    def post_partition( partition )
      return true if partition.post_close.nil?
      Arver::Log.info( "Running script: " + partition.post_close + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.new( partition.post_close, [] , partition.parent, true )
      c.execute
    end

    def post_host( host )
      return true if host.post_close.nil?
      Arver::Log.info( "Running script: " + host.post_close + " on " + host.name )
      c = Arver::SSHCommandWrapper.new( host.post_close, [] , host, true )
      c.execute
    end
  end
end
