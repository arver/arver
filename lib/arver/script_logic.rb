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
        next if( key.nil? )
        p "DANGEROUS: you do have already a key for partition #{partition.path} - exiting" # if not --force"
        exit
      end
      slot_of_user = Arver::Config.instance.slot( Arver::LocalConfig.instance.username )
      if not Arver::LocalConfig.instance.dry_run then
        p "generating a new key for partition #{target.device}"
        gen = Arver::KeyGenerator.new
        key = gen.generate_key( Arver::LocalConfig.instance.username, target )
        gen.dump
        cmd = "echo \"#{key}\" | ssh #{target.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} --cipher aes-cbc-essiv:sha256 --key-size 256 luksFormat #{target.device}\"";
        p exec(cmd)
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
        if( key.nil? )
          puts "No permission on "+partition.path
          next
        end
        if not Arver::LocalConfig.instance.dry_run then
          cmd = "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksOpen #{partition.device} #{partition.name}\"";
          p exec(cmd)
        else
          key = '*'*256
          p "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode luksOpen #{partition.device} #{partition.name}\"";
        end
      end
    end
    def self.adduser args
      target = self.find_target( args[:target] )
      user = args[:user]
      
      puts "adduser was called with target "+target.path+" and user "+user

      self.load_key
      gen = Arver::KeyGenerator.new
      slot_of_user = Arver::Config.instance.slot( user )
      puts "would call (if implemented :( )):"
      target.each_partition do | partition |
        if not Arver::LocalConfig.instance.dry_run then
          key = gen.generate_key( user, partition )
          cmd = "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} addKey #{partition.device}\"";
          p exec(cmd)
        else
          key = '*'*256
          p "echo \"#{key}\" | ssh #{partition.parent.address} \"cryptsetup --batch-mode --key-slot #{slot_of_user.to_s} addKey #{partition.device}\"";
        end
      end
      gen.dump
    end
    def self.deluser args
      target = self.find_target( args[:target] )
      user = args[:user]

      self.load_key
      puts "deluser was called with target "+target.path+" and user "+user
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
