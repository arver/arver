class Arver::Bootstrap
  class << self
    def run(options)
      local = Arver::LocalConfig.instance
      local.config_dir = options[:config_dir] unless options[:config_dir].empty?
      local.username = options[:user] unless options[:user].empty?

      unless local.username.present?
        Arver::Log.error( "No user defined" )
        return false
      end

      config = Arver::Config.instance
      config.load

      return false unless Arver::KeySaver.check_key(local.username)
      self.load_runtime_config(options)
      true
    end

    def load_runtime_config(options)
      rtc = Arver::RuntimeConfig.instance
      rtc.dry_run = options[:dry_run]
      rtc.ask_password = options[:ask_password]
      rtc.force = options[:force]
      rtc.violence = options[:violence]
      rtc.test_mode = options[:test_mode]
    end  
  end
end
