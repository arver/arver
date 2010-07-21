module Arver
  class ScriptLogic
    def self.open args
      target = args[:target]
      puts "open was called with target "+target
    end
    def self.adduser args
      target = args[:target]
      user = args[:user]
      puts "adduser was called with target "+target+" and user "+user
    end
    def self.deluser args
      target = args[:target]
      user = args[:user]
      puts "deluser was called with target "+target+" and user "+user
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