class Arver::LocalConfig
  #this Config Object holds the local defaults for Arver. All options correspond to the ones set in .arver.local
  include Singleton

  def path
    File.expand_path("~/.arver")
  end

  def config
    @config ||= load_file( path )
  end

  def default
    { 'config_dir' => "~/.arverdata", 'username' => "" }
  end

  def load_file(filename)
    content = YAML.load(File.read(filename)) if File.exists?(filename)
    default.merge(content||{})
  end

  def save
    File.open( path, 'w' ) { |f| f.write(self.config.to_yaml) }
  end

  def username
    self.config['username']
  end

  def username= username
    self.config['username'] = username
  end

  def config_dir
    File.expand_path(self.config['config_dir'])
  end

  def config_dir=(directory)
    self.config['config_dir'] = directory
  end
end
