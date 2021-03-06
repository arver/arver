require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Keystore" do
  before(:each) do
    self.extend( TestConfigLoader )
    self.load_test_config
    @luks_key = (0...8).map {(65 + rand(26)).chr}.join
    @keystore = Arver::Keystore.for('test')
    @keystore.purge_keys
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
    # to run this test import spec/data/fixtures/test_key into your gpg-keyring
    @keystore.load
    Arver::KeySaver.num_of_key_files("test").should == 1
    @luks_key.should == @keystore.luks_key(@partition)
  end

  it "can save multiple keys to one keyfile" do
    @keystore.add_luks_key(@partition, @luks_key)
    @keystore.add_luks_key(@partition2, @luks_key)
    @keystore.save
    Arver::KeySaver.num_of_key_files("test").should == 1
  end

  it "can do garbage collection right" do
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
