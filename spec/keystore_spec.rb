require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Keystore" do
  before(:each) do
    @luks_key = "someStringASDdf"
    @luks_key2 = "someStringASDdf2"
    @keystore = Arver::Keystore.instance
    @keystore.username= "test"
    @partition = Arver::TestPartition.new("sometest")
    @partition2 = Arver::TestPartition.new("sometest2")
  end
  
  it "can add a key" do
    @keystore.add_luks_key( @partition, @luks_key ) 
    @luks_key.should == @keystore.luks_key(@partition)
  end
  
  it "can save keystore" do
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.purge_and_save
    @keystore.load
    @luks_key.should == @keystore.luks_key(@partition)
  end
  
  it "can load splitted and updated key" do
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.purge_and_save
    #replace one and add a new one
    @keystore.add_luks_key(@partition2, @luks_key)
    @keystore.add_luks_key(@partition, @luks_key2)
    @keystore.save
    @keystore.load
    @luks_key2.should == @keystore.luks_key(@partition)
    @luks_key.should == @keystore.luks_key(@partition2)
  end
    
end
