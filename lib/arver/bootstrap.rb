class Arver::Bootstrap
  class << self
    def run(options)
      local = Arver::LocalConfig.instance
      local.config_dir = options[:config_dir] unless options[:config_dir].empty?
      local.username = options[:user] unless options[:user].empty?
      
      return true if options[:action] == :init

      unless local.username.present?
        Arver::Log.error( "No user defined" )
        return false
      end

      config = Arver::Config.instance
      config.load

      self.load_runtime_config(options)

      unless Arver::Config.instance.exists?(local.username)
        Arver::Log.error( "No such user #{local.username}" )
        return false
      end
      Arver::GPGKeyManager.check_key_of(local.username)
    end

    def load_runtime_config(options)
      rtc = Arver::RuntimeConfig.instance
      rtc.dry_run = options[:dry_run]
      rtc.ask_password = options[:ask_password]
      rtc.force = options[:force]
      rtc.violence = options[:violence]
      rtc.test_mode = options[:test_mode]
      rtc.trust_all = options[:trust_all]
    end  
  end
end
