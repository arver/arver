module Arver
  class ScriptLogic
    #TODO: do the luks stuff:

    def self.create args
      target = self.find_target( args[:target] )
      puts "creating: "+target.path
      self.load_key
      keystore = Arver::Keystore.instance
      target.each_partition do | partition |
        key = keystore.luks_key( partition )
        next if( key.nil? ) or Arver::LocalConfig.instance.force
        p "DANGEROUS: you do have already a key for partition #{partition.path} - exiting (apply --force to continue)"
        exit
      end
      slot_of_user = Arver::Config.instance.slot( Arver::LocalConfig.instance.username )
      if not Arver::LocalConfig.instance.dry_run then
        p "generating a new key for partition #{target.device}"

        # checking if disk is not already LUKS formatted
        p "checking if disk is not already LUKS formatted..."
        result = `ssh #{target.parent.address} \"cryptsetup luksDump #{target.device}\"`
        if result.include?('LUKS header information') then
          p "VERY DANGEROUS: the partition #{target.device} is already formatted with LUKS - exiting (continue with --violence)" 
          if Arver::LocalConfig.instance.violence then
            p "you applied --violence, so we will continue ..."
          else
            p "for more information see /tmp/luks_create_error.txt"
            system("echo \"#{result}\" > /tmp/luks_create_error.txt")
            exit if not Arver::LocalConfig.instance.violence
          end
        end

        gen = Arver::KeyGenerator.new
        key = gen.generate_key( Arver::LocalConfig.instance.username, target )
        gen.dump
        cmd = "echo \"#{key}\" | ssh #{target.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} --cipher aes-cbc-essiv:sha256 --key-size 256 luksFormat #{target.device}\"";
        p system(cmd)
      else
        key = '*'*256
        p "echo \"#{key}\" | ssh #{target.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} --cipher aes-cbc-essiv:sha256 --key-size 256 luksFormat #{target.device}\"";
      end
    end
    def self.open args
      target = self.find_target( args[:target] )
      puts "opening: "+target.path
      self.load_key
      keystore = Arver::Keystore.instance
      target.each_partition do | partition |
        key = keystore.luks_key( partition )
        p "Trying to open #{partition.path}"
        if( key.nil? )
          puts "No permission on #{partition.path}"
          next
        end
        if not Arver::LocalConfig.instance.dry_run then
          cmd = "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksOpen #{partition.device} #{partition.name}\"";
          p system(cmd)
        else
          key = '*'*256
          p "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksOpen #{partition.device} #{partition.name}\"";
        end
      end
    end
    def self.close args
      target = self.find_target( args[:target] )
      puts "closing: "+target.path
      target.each_partition do | partition |
        if not Arver::LocalConfig.instance.dry_run then
          cmd = "ssh #{partition.parent.address} \"cryptsetup luksClose #{partition.name}\"";
          p system(cmd)
        else
          p "ssh #{partition.parent.address} \"cryptsetup luksClose #{partition.name}\"";
        end
      end
    end
    def self.adduser args
      target = self.find_target( args[:target] )
      user = args[:user]
      

      self.load_key
      slot_of_user = Arver::Config.instance.slot( user )

      puts "adduser was called with target #{target.path} and user #{user} (slot-no #{slot_of_user})"
      puts "would call (if implemented :( )):"
      keystore = Arver::Keystore.instance
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
          gen = Arver::KeyGenerator.new
          p "generate_key (#{user},#{target.path})"
          newkey = gen.generate_key( user, target )

          # p "add the new key to the partition (length1 = #{a_valid_key.to_s.length}, length2 = #{newkey.to_s.length})"
          cmd = "\(echo \"#{a_valid_key}\"; echo \"#{newkey}\"\) | ssh #{partition.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} luksAddKey #{partition.device}\"";
          result = system(cmd)
          # if result == true, then the cryptsetup command was successful -> write the key to file
          gen.dump if result
        else
          p "would execute the following command:"
          cmd = "(echo 'my_secret_key_for_this_partition'; echo 'a new key for the user') | ssh #{partition.parent.address} 'cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} luksAddKey #{partition.device}'";
          p cmd
        end
      end
    end
    def self.deluser args
      target = self.find_target( args[:target] )
      user = args[:user]

      self.load_key
      gen = Arver::KeyGenerator.new

      slot_of_user = Arver::Config.instance.slot( user )

      puts "deluser was called with target #{target.path} and user #{user} (slot-no #{slot_of_user})"

      puts "would call (if implemented :( )):"
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
          p system(cmd)
        else
          key = '*'*256
          p "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksKillSlot #{partition.device} #{slot_of_user}\"";
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

    def self.find_target( name )
      
      tree = Arver::Config.instance.tree
      return tree if name == "ALL"
      targets = tree.find( name )
      if( targets.size == 0 )
        puts "No such target"
        exit
      end
      if( targets.size > 1 )
        puts "Target not unique. Found:"
        targets.each do |t|
          puts t.path
        end
        exit
      end
      targets[0]
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
