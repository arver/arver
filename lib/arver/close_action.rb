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
      unless( caller.execute )
        Arver::Log.error( "Aborting: Something went wrong when closing "+partition.name+":\n"+caller.output )
        throw( :abort_action )
      end
    end

    def pre_host( host )
      return if host.pre_close.nil?
      Arver::Log.info( "Running script: " + host.pre_close + " on " + host.name )
      c = Arver::SSHCommandWrapper.create( host.pre_close, [] , host, true )
      unless c.execute
        Arver::Log.error( "Aborting: pre_close on #{host.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end

    def pre_partition( partition )
      return if partition.pre_close.nil?
      Arver::Log.info( "Running script: " + partition.pre_close + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.create( partition.pre_close, [] , partition.parent, true )
      unless c.execute
        Arver::Log.error( "Aborting: pre_close on #{partition.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end

    def post_partition( partition )
      return if partition.post_close.nil?
      Arver::Log.info( "Running script: " + partition.post_close + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.create( partition.post_close, [] , partition.parent, true )
      unless c.execute
        Arver::Log.error( "Aborting: post_close on #{partition.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end

    def post_host( host )
      return if host.post_close.nil?
      Arver::Log.info( "Running script: " + host.post_close + " on " + host.name )
      c = Arver::SSHCommandWrapper.create( host.post_close, [] , host, true )
      unless c.execute
        Arver::Log.error( "Aborting: post_close on #{host.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end
  end
end
