module Arver
  class Bootstrap

    def self.run options
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
  end
end
