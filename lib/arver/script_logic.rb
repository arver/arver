module Arver
  class ScriptLogic
    #TODO: do the luks stuff:

    def self.create args
      target = self.find_target( args[:target] )
      puts "creating: "+target.path
      self.load_key
      gen = Arver::KeyGenerator.new
      key = gen.generate_key( Arver::LocalConfig.instance.username, target )
      gen.dump
      puts "echo "+key+" | ssh "+target.parent.address+' "cryptsetup --batch-mode luksFormat '+target.device+'"';
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
        puts "echo "+key+" | ssh "+partition.parent.address+' "cryptsetup --batch-mode create '+partition.name+' '+partition.device+'"';
      end
    end
    def self.adduser args
      target = self.find_target( args[:target] )
      user = args[:user]
      
      puts "adduser was called with target "+target.path+" and user "+user

      self.load_key
      gen = Arver::KeyGenerator.new
      puts "would call (if implemented :( )):"
      target.each_partition do | partition |
        key = gen.generate_key( user, partition )
        puts "echo "+key+" | ssh "+partition.parent.address+' "cryptsetup --batch-mode addKey '+partition.device+'"';
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
      puts Arver::Config.instance.tree.to_yaml
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