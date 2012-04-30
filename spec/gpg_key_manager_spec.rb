require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe "GPGKeyManager" do
  before(:each) do
    self.extend( TestConfigLoader )
    self.load_test_config
  end
  
  it "has a key for test2" do
    Arver::GPGKeyManager.key_of("test2").should_not be_false
  end

  it "has a key for test" do
    Arver::GPGKeyManager.key_of("test").should_not be_false
  end
  
  it "can detect missing key" do
    Arver::GPGKeyManager.check_key_of("asfafaf").should be_false
  end
  
  it "can check the key for test" do
    Arver::GPGKeyManager.check_key_of("test").should_not be_false
  end
  
  it "can check the key for test2" do
    Arver::GPGKeyManager.check_key_of("test2").should_not be_false
  end
  
  it "can restore the key for test2" do
    k = Arver::GPGKeyManager.key_of("key_import")
    k.delete!( :allow_secret => true )
    Arver::RuntimeConfig.instance.trust_all = true
    Arver::GPGKeyManager.check_key_of("key_import").should_not be_false
    Arver::RuntimeConfig.instance.trust_all = false
  end
end
