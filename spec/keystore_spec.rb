require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Keystore" do
  before(:each) do
    self.extend( TestConfigLoader )
    self.load_test_config
    @luks_key = "someStringASDdf"
    @keystore = Arver::Keystore.for('test')
    @partition = Arver::TestPartition.new("sometest")
    @partition2 = Arver::TestPartition.new("sometest2")
  end
  
  after(:each) do
    Arver::Keystore.reset
  end
  
  it "can add a key" do
    @keystore.add_luks_key( @partition, @luks_key ) 
    @luks_key.should == @keystore.luks_key(@partition)
  end
  
  it "can save keystore" do
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.save
    begin
      @keystore.load
    rescue Exception
      puts "to run this test import spec/data/test_key into your gpg-keyring"
    end
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
    @keystore.purge_keys
    gen = Arver::KeyGenerator.new
    gen.generate_key( @partition )
    gen.dump( @keystore )
    gen = Arver::KeyGenerator.new
    gen.generate_key( @partition )
    gen.dump( @keystore )
    Arver::KeySaver.num_of_key_files("test").should == 2
    @keystore.flush_keys
    @keystore.load
    @keystore.save
    Arver::KeySaver.num_of_key_files("test").should == 1
  end
 
   it "can load splitted and updated key" do
    @keystore.purge_keys
    gen = Arver::KeyGenerator.new
    gen.generate_key( @partition )
    gen.dump( @keystore )
    key = gen.generate_key( @partition )
    key2 = gen.generate_key( @partition2 )
    gen.dump( @keystore )
    @keystore.flush_keys
    @keystore.load
    key.should == @keystore.luks_key(@partition)
    key2.should == @keystore.luks_key(@partition2)
  end


  it "can load more than 10 keyfiles" do
    @keystore.purge_keys
    gen = Arver::KeyGenerator.new
    10.times do
      gen.generate_key( @partition )
      gen.dump( @keystore )
    end    
    key = gen.generate_key( @partition )
    gen.dump( @keystore )
    Arver::KeySaver.num_of_key_files("test").should >= 10
    @keystore.flush_keys
    @keystore.load
    key.should == @keystore.luks_key(@partition)
  end

end
