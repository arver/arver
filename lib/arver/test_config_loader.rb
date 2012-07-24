module TestConfigLoader

  def load_sample_tree
    Arver::Config.instance.tree= Arver::Tree.new
    @hg = Arver::Hostgroup.new "testG"
    @hg2 = Arver::Hostgroup.new "testG2"
    @h = Arver::Host.new "testH", @hg
    @h2 = Arver::Host.new "testH2", @hg2
    @h3 = Arver::Host.new "testH3", @hg2
    @d = Arver::Partition.new "testP1", @h
    @d2 = Arver::Partition.new "testP2", @h2
    @d3 = Arver::Partition.new "testP3", @h3
    @d4 = Arver::Partition.new "testP4", @h3
  end
  
  def load_test_config
    Arver::LocalConfig.instance.config_dir= "spec/data"
    Arver::LocalConfig.instance.username= "test"
    config = Arver::Config.instance
    config.load
  end
end
