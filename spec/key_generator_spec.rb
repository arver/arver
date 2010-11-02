require File.dirname(__FILE__) + '/spec_helper.rb'

describe "KeyGenerator" do
  before(:each) do
    @keystore = Arver::Keystore.instance
    @keystore.username= "test"
    @partition = Arver::TestPartition.new("sometest")
    @partition2 = Arver::TestPartition.new("sometest2")
    self.extend( TestConfigLoader )
    load_test_config
  end
  
  it "can generate correct keys" do
    @keystore.purge_keys
    generator = Arver::KeyGenerator.new
    key = generator.generate_key( "test", @partition )
    key2 = generator.generate_key( "test", @partition2 )
    generator.dump
    @keystore.load
    @keystore.luks_key(@partition).should == key
    @keystore.luks_key(@partition2).should == key2
  end

  it "can save multiple keys to one keyfile" do
    @keystore.purge_keys
    gen = Arver::KeyGenerator.new
    gen.generate_key( "test", @partition )
    gen.generate_key( "test", @partition2 )
    gen.dump
    Arver::KeySaver.num_of_key_files("test").should == 1
  end

  
end
