module Arver
  class ScriptLogic

    def self.create args
      target_list = TargetList.get_list( args[:target] )
      action = CreateAction.new( target_list )
      action.pre_run( Arver::Config.instance.tree )
      action.run( Arver::Config.instance.tree )
      action.post_run
    end

    def self.open args
      target = self.find_target( args[:target] )
      self.load_key
      keystore = Arver::Keystore.instance
      target.each_partition do | partition |
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

    def self.close args
      target = self.find_target( args[:target] )
      target.each_partition do | partition |
        Arver::Log.info( "closing: "+partition.path )
        caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "luksClose", "#{partition.name}", partition.parent.address] )
        caller.execute 
      end
    end

    def self.adduser args
      target = self.find_target( args[:target] )
      user = args[:user]
      
      slot_of_user = Arver::Config.instance.slot( user )
      if slot_of_user.nil?
        Arver::Log.error( "no such user" )
        return
      end
      
      Arver::Log.info( "adduser was called with target #{args[:target]} and user #{user} (slot-no #{slot_of_user})" )

      self.load_key
      keystore = Arver::Keystore.instance

      gen = Arver::KeyGenerator.new
      
      target.each_partition do | partition |
        Arver::Log.info( "Generating keys for partition #{partition.device}" )
        if not Arver::RuntimeConfig.instance.ask_password then
          # get a valid key for this partition
          a_valid_key = keystore.luks_key( partition )
        else
          a_valid_key = ask('Enter the password for this volume: ') {|q| q.echo = false}
        end

        if( a_valid_key.nil? )
          Arver::Log.error( "No permission on #{partition.path}" )
          next
        end
        
        # generate a key for the new user
        Arver::Log.debug( "generate_key (#{user},#{partition.path})" )
        
        newkey = gen.generate_key( user, partition )

        caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "--key-slot #{slot_of_user.to_s}", "luksAddKey", "#{partition.device}" ], partition.parent.address )
        caller.execute( a_valid_key + "\n" + newkey )
        
        unless( caller.success? )
          gen.remove_key( user, partition )
        end
      end
      gen.dump
    end

    def self.deluser args
      target = self.find_target( args[:target] )
      user = args[:user]

      self.load_key
      gen = Arver::KeyGenerator.new

      slot_of_user = Arver::Config.instance.slot( user )

      keystore = Arver::Keystore.instance
      
      target.each_partition do | partition |
        Arver::Log.info( "remove user #{user} (slot-no #{slot_of_user}) from #{partition.path}" )
        if not Arver::RuntimeConfig.instance.ask_password then
          # get a valid key for this partition
          a_valid_key = keystore.luks_key( partition )
        else
          a_valid_key = ask('Enter the password for this volume: ') {|q| q.echo = false}
        end
        caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "luksKillSlot", "#{partition.device}", "#{slot_of_user}" ], partition.parent.address )
        caller.execute( a_valid_key )
        unless( caller.success? )
          log.error( "Could not remove user:\n" + caller.output )
        end
      end
    end
    
    def self.info args
      target = self.find_target( args[:target] )
      # puts "Info about: "+target.path
      target.each_partition do | partition |
        caller = Arver::SSHCommandWrapper.new( "cryptsetup", [ "luksDump", "#{partition.device}" ], partition.parent.address )
        caller.execute
        result = caller.output
        a= {}
        bla = result.each{|s| 
                  a1=s.split(':').compact; 
                  v = '';
                  v = a1[1].strip if not a1[1].nil?;
                  v = v + ':' + a1[2].strip if not a1[2].nil?;
                  a[a1[0].strip] = v if not a1[0].nil? }
        filling = 40-partition.device.length
        filling = 0 if filling < 0
        Arver::Log.info( "#{partition.device}#{' '*filling}: Slots: #{[0,1,2,3,4,5,6,7].map{|i| a['Key Slot '+i.to_s] == 'ENABLED' ? 'X' : '_'}.join}; LUKSv#{a['Version']}; Cypher: #{a['Cipher name']}:#{a['Cipher mode']}:#{a['Hash spec']}; UUID=#{a['UUID']}" )
      end
    end
    def self.list args
      Arver::Log.write( Arver::Config.instance.tree.to_ascii )
    end
    def self.gc args
      self.load_key
      keystore = Arver::Keystore.instance
      keystore.save
    end

    def self.find_target( names )
      
      tree = Arver::Config.instance.tree
      return tree if names.eql? "ALL"

      targets = Arver::Hostgroup.new("")

      names.split( "," ).each do |target_name|
        target = tree.find( target_name )
        if( target.size == 0 )
          Arver::Log.error( "No such target" )
          return
        end
        if( target.size > 1 )
          Arver::Log.error( "Target not unique. Found:" )
          target.each do |t|
            Arver::Log.error( t.path )
          end
          return
        end
        targets.add_child( target[0] )
      end

      targets
    end
    
    def self.bootstrap options
      local = Arver::LocalConfig.instance
      unless( options[:config_dir].empty? )
        local.config_dir= ( options[:config_dir] )
      end
      unless( options[:user].empty? )
        local.username= ( options[:user] )
      end
      if( local.username.empty? )
        Arver::Log.error( "No user defined" )
        return
      end
      
      config = Arver::Config.instance
      config.load

      self.load_runtime_config( options )
    end
    
    def self.load_runtime_config options
      rtc = Arver::RuntimeConfig.instance
      rtc.dry_run = options[:dry_run]
      rtc.ask_password = options[:ask_password]
      rtc.force = options[:force]
      rtc.violence = options[:violence]
      rtc.test_mode = options[:test_mode]      
    end
    
    def self.load_key
      keystore = Arver::Keystore.instance
      keystore.load
    end      
  end
end
