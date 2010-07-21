module Arver
  class ScriptLogic
    def self.open args
      target = self.find_target( args[:target] )
      puts "opening: "+target.path
    end
    def self.adduser args
      target = self.find_target( args[:target] )
      user = args[:user]
      
      #todo make luks stuff:
      puts "adduser was called with target "+target.path+" and user "+user
      gen = Arver::KeyGenerator.new
      puts "would call (if implemented :( )):"
      target.each_partition do | partition |
        key = gen.generate_key( user, partition )
        puts "echo "+key+" | ssh "+partition.parent.address+' "luks --batch-mode addKey '+partition.device+'"';
      end
      #gen.dump
    end
    def self.deluser args
      target = self.find_target( args[:target] )
      user = args[:user]
      puts "deluser was called with target "+target.path+" and user "+user
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
      keystore = Arver::Keystore.instance
      keystore.load
    end
  end
end