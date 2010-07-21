require File.dirname(__FILE__) + '/spec_helper.rb'

describe "KeySaver" do
  before(:each) do
    @luks_key = Arver::LuksKey.new "test"
    @keystore = Arver::Keystore.instance
    @keystore.username= "test"
    @partition = Arver::TestPartition.new("sometest")
  end
  
  it "can add a key" do
    @keystore.add_luks_key( @partition, @luks_key ) 
    @luks_key.should == @keystore.luks_key(@partition)
  end
  
  it "can save keystore" do
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.save
    @keystore.flush_keys
    @keystore.load
    @luks_key.should == @keystore.luks_key(@partition)
  end  
end
