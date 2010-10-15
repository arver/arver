module Arver
  class ScriptLogic
    
    def self.system_call cmd
      unless Arver::LocalConfig.instance.test_mode
        system( cmd )
      else
        p "system call skiped (test mode)"
        true
      end
    end
    
    def self.quoted_call cmd
      unless Arver::LocalConfig.instance.test_mode
        `cmd`
      else
        p "quoted call skiped (test mode)"
        ""
      end
    end

    def self.create args
      target = self.find_target( args[:target] )
      self.load_key
      keystore = Arver::Keystore.instance
      target.each_partition do | partition |
        puts "creating: "+partition.path
        key = keystore.luks_key( partition )
        if( ! key.nil? and ! Arver::LocalConfig.instance.force )
          p "DANGEROUS: you do have already a key for partition #{partition.path} - exiting (apply --force to continue)"
          exit
        end
      end

      gen = Arver::KeyGenerator.new
      
      target.each_partition do | partition |
        slot_of_user = Arver::Config.instance.slot( Arver::LocalConfig.instance.username )
        if not Arver::LocalConfig.instance.dry_run then
          p "generating a new key for partition #{partition.device} on #{partition.path}"

          # checking if disk is not already LUKS formatted
          p "checking if disk is not already LUKS formatted..."

          result = quoted_call( "ssh #{partition.parent.address} \"cryptsetup luksDump #{partition.device}\"" )
          if result.include?('LUKS header information') then
            p "VERY DANGEROUS: the partition #{partition.device} is already formatted with LUKS - exiting (continue with --violence)" 
            if Arver::LocalConfig.instance.violence then
              p "you applied --violence, so we will continue ..."
            else
              p "for more information see /tmp/luks_create_error.txt"
              system("echo \"#{result}\" > /tmp/luks_create_error.txt")
              exit if not Arver::LocalConfig.instance.violence
            end
          end
          key = gen.generate_key( Arver::LocalConfig.instance.username, partition )
          cmd = "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} --cipher aes-cbc-essiv:sha256 --key-size 256 luksFormat #{partition.device}\"";
          unless system_call(cmd)
            gen.remove_key( partition )
          end
        else
          key = '*'*256
          p "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} --cipher aes-cbc-essiv:sha256 --key-size 256 luksFormat #{partition.device}\"";
        end
      end

      gen.dump
    end

    def self.open args
      target = self.find_target( args[:target] )
      self.load_key
      keystore = Arver::Keystore.instance
      target.each_partition do | partition |
        puts "opening: "+partition.path
        key = keystore.luks_key( partition )
        p "Trying to open #{partition.path}"
        if( key.nil? )
          puts "No permission on #{partition.path}"
          next
        end
        if not Arver::LocalConfig.instance.dry_run then
          cmd = "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksOpen #{partition.device} #{partition.name}\"";
          p system_call(cmd)
        else
          key = '*'*256
          p "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksOpen #{partition.device} #{partition.name}\"";
        end
      end
    end

    def self.close args
      target = self.find_target( args[:target] )
      target.each_partition do | partition |
        puts "closing: "+partition.path
        if not Arver::LocalConfig.instance.dry_run then
          cmd = "ssh #{partition.parent.address} \"cryptsetup luksClose #{partition.name}\"";
          p system_call(cmd)
        else
          p "ssh #{partition.parent.address} \"cryptsetup luksClose #{partition.name}\"";
        end
      end
    end

    def self.adduser args
      target = self.find_target( args[:target] )
      user = args[:user]
      
      slot_of_user = Arver::Config.instance.slot( user )
      if slot_of_user.nil?
        p "no such user"
        exit
      end
      
      puts "adduser was called with target #{args[:target]} and user #{user} (slot-no #{slot_of_user})"

      self.load_key
      keystore = Arver::Keystore.instance

      gen = Arver::KeyGenerator.new
      
      target.each_partition do | partition |
        p "Generating keys for partition #{partition.device}"
        if not Arver::LocalConfig.instance.dry_run then
          if not Arver::LocalConfig.instance.ask_password then
            # get a valid key for this partition
            a_valid_key = keystore.luks_key( partition )
          else
            a_valid_key = ask('Enter the password for this volume: ') {|q| q.echo = false}
          end

          # generate a key for the new user
          p "generate_key (#{user},#{partition.path})"
          
          newkey = gen.generate_key( user, partition )

	  cmd = "\(echo \"#{a_valid_key}\"; echo \"#{newkey}\"\) | ssh #{partition.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} luksAddKey #{partition.device}\"";
          
          unless( system_call(cmd) )
            gen.remove_key( user, partition )
          end
        else
          p "would execute the following command:"
          cmd = "(echo 'my_secret_key_for_this_partition'; echo 'a new key for the user') | ssh #{partition.parent.address} 'cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} luksAddKey #{partition.device}'";
          p cmd
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

      puts "deluser was called with target #{target.path} and user #{user} (slot-no #{slot_of_user})"

      keystore = Arver::Keystore.instance
      
      target.each_partition do | partition |
        if not Arver::LocalConfig.instance.dry_run then
          if not Arver::LocalConfig.instance.ask_password then
            # get a valid key for this partition
            a_valid_key = keystore.luks_key( partition )
          else
            a_valid_key = ask('Enter the password for this volume: ') {|q| q.echo = false}
          end
        end
        if not Arver::LocalConfig.instance.dry_run then
          cmd = "echo \"#{a_valid_key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksKillSlot #{partition.device} #{slot_of_user}\"";
          p system_call(cmd)
        else
          key = '*'*256
          p "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksKillSlot #{partition.device} #{slot_of_user}\"";
        end
      end
    end
    def self.info args
      target = self.find_target( args[:target] )
      # puts "Info about: "+target.path
      target.each_partition do | partition |
        if not Arver::LocalConfig.instance.dry_run then
          result = `ssh #{partition.parent.address} \"cryptsetup luksDump #{partition.device}\"`;
          a= {}
          bla = result.each{|s| 
                    a1=s.split(':').compact; 
                    v = '';
                    v = a1[1].strip if not a1[1].nil?;
                    v = v + ':' + a1[2].strip if not a1[2].nil?;
                    a[a1[0].strip] = v if not a1[0].nil? }
          filling = 40-partition.device.length
          filling = 0 if filling < 0
          p "#{partition.device}#{' '*filling}: Slots: #{[0,1,2,3,4,5,6,7].map{|i| a['Key Slot '+i.to_s] == 'ENABLED' ? 'X' : '_'}.join}; LUKSv#{a['Version']}; Cypher: #{a['Cipher name']}:#{a['Cipher mode']}:#{a['Hash spec']}; UUID=#{a['UUID']}"
        else
          p "ssh #{partition.parent.address} \"cryptsetup luksDump #{partition.device}\"";
        end
      end
    end
    def self.list args
      puts Arver::Config.instance.tree.to_ascii
    end
    def self.gc args
      self.load_key
      keystore = Arver::Keystore.instance
      keystore.save
    end

    def self.find_target( names )
      
      tree = Arver::Config.instance.tree
      return tree if name == "ALL"

      targets = Arver::Hostgroup.new("")

      names.split( "," ).each do |target_name|
        target = tree.find( target_name )
        if( target.size == 0 )
          puts "No such target"
          exit
        end
        if( target.size > 1 )
          puts "Target not unique. Found:"
          target.each do |t|
            puts t.path
          end
          exit
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
      local.dry_run = options[:dry_run]
      local.ask_password = options[:ask_password]
      local.force = options[:force]
      local.violence = options[:violence]
      local.test_mode = options[:test_mode]
      
      if( local.username.empty? )
        puts "No user defined"
        exit
      end
      
      config = Arver::Config.instance
      config.load
    end
    
    def self.load_key
      keystore = Arver::Keystore.instance
      keystore.load
    end      
  end
end
