module Arver
  class OpenAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end

    def verify?( partition )
      if( Arver::LuksWrapper.open?(partition).execute )
        Arver::Log.error( partition.name+" already open. skipping." )
        return false
      end
      return false unless load_key( partition )
      true
    end

    def execute_partition( partition )
      Arver::Log.info( "opening: "+partition.path )
      caller = Arver::LuksWrapper.open( partition )
      unless( caller.execute( key ) )
        if( Arver::LuksWrapper.was_wrong_key?( caller ) )
          Arver::Log.error( "Your key for "+partition.name+" is no longer valid. Maybe it was revoked. skipping." )
        else
          Arver::Log.error( "Aborting: Something went wrong when opening "+partition.name+":\n"+caller.output )
          throw( :abort_action )
        end
      end
    end

    def pre_host( host )
      return if host.pre_open.nil?
      Arver::Log.info( "Running script: " + host.pre_open + " on " + host.name )
      c = Arver::SSHCommandWrapper.create( host.pre_open, [] , host, true )
      unless c.execute
        Arver::Log.error( "Aborting: pre_open on #{host.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end

    def pre_partition( partition )
      return if partition.pre_open.nil?
      Arver::Log.info( "Running script: " + partition.pre_open + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.create( partition.pre_open, [] , partition.parent, true )
      unless c.execute
        Arver::Log.error( "Aborting: pre_open on #{partition.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end

    def post_partition( partition )
      return if partition.post_open.nil?
      Arver::Log.info( "Running script: " + partition.post_open + " on " + partition.parent.name )
      c = Arver::SSHCommandWrapper.create( partition.post_open, [] , partition.parent, true )
      unless c.execute
        Arver::Log.error( "Aborting: post_open on #{partition.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end

    def post_host( host )
      return if host.post_open.nil?
      Arver::Log.info( "Running script: " + host.post_open + " on " + host.name )
      c = Arver::SSHCommandWrapper.create( host.post_open, [] , host, true )
      unless c.execute
        Arver::Log.error( "Aborting: post_open on #{host.name} failed:\n"+c.output )
        throw( :abort_action )
      end
    end
  end
end
