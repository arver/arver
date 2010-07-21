require File.dirname(__FILE__) + '/spec_helper.rb'

describe "KeyGenerator" do
  before(:each) do
    @keystore = Arver::Keystore.instance
    @keystore.username= "test"
    @partition = Arver::TestPartition.new("sometest")
    @partition2 = Arver::TestPartition.new("sometest2")
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
  
end
