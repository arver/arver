require File.dirname(__FILE__) + '/spec_helper.rb'

describe "KeyGenerator" do
  before(:each) do
    @keystore = Arver::Keystore.for('test')
    @partition = Arver::TestPartition.new("sometest")
    @partition2 = Arver::TestPartition.new("sometest2")
    self.extend( TestConfigLoader )
    load_test_config
  end
  
  it "can generate correct keys" do
    @keystore.purge_keys
    generator = Arver::KeyGenerator.new
    key = generator.generate_key( @partition )
    key2 = generator.generate_key( @partition2 )
    generator.dump( @keystore )
    @keystore.load
    @keystore.luks_key(@partition).should == key
    @keystore.luks_key(@partition2).should == key2
  end

  it "can save multiple keys to one keyfile" do
    @keystore.purge_keys
    gen = Arver::KeyGenerator.new
    gen.generate_key( @partition )
    gen.generate_key( @partition2 )
    gen.dump( @keystore )
    Arver::KeySaver.num_of_key_files("test").should == 1
  end

  
end
