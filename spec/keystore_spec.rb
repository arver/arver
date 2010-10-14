require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Keystore" do
  before(:each) do
    @luks_key = "someStringASDdf"
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
    puts "to run this test import spec/data/test_key into your gpg-keyring"
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.save
    @keystore.load
    @luks_key.should == @keystore.luks_key(@partition)
  end

  it "can save multiple keys to one keyfile" do
    @keystore.purge_keys
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.add_luks_key(@partition2, @luks_key)
    @keystore.save
    Arver::KeySaver.num_of_key_files("test").should == 1
  end
  
  it "can do garbage collection right" do
    gen = Arver::KeyGenerator.new
    gen.generate_key( "test", @partition )
    gen.dump
    @keystore.purge_keys
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.save
    Arver::KeySaver.num_of_key_files("test").should == 1
  end
 
   it "can load splitted and updated key" do
    @keystore.purge_keys
    gen = Arver::KeyGenerator.new
    gen.generate_key( "test", @partition )
    gen.dump
    key = gen.generate_key( "test", @partition )
    key2 = gen.generate_key( "test", @partition2 )
    gen.dump
    @keystore.flush_keys
    @keystore.load
    key.should == @keystore.luks_key(@partition)
    key2.should == @keystore.luks_key(@partition2)
  end


  it "can load more than 10 keyfiles" do
    @keystore.purge_keys
    gen = Arver::KeyGenerator.new
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    gen.generate_key( "test", @partition )
    gen.dump
    key = gen.generate_key( "test", @partition )
    gen.dump
    Arver::KeySaver.num_of_key_files("test").should >= 10
    @keystore.flush_keys
    @keystore.load
    key.should == @keystore.luks_key(@partition)
  end

end
