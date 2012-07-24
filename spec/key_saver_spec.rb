require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe "KeySaver" do
  
  before(:each) do
    self.extend( TestConfigLoader )
  end
  
  it "can save and encrypt the key" do
    self.load_test_config
    s = "test\ntest"
    Arver::KeySaver.purge_keys( "test" )
    Arver::KeySaver.save( "test", s )
    Arver::KeySaver.read( "test" ).should == [ s ]
  end
  
  it "can save multiple times" do
    self.load_test_config
    s = "test\ntest"
    Arver::KeySaver.purge_keys( "test" )
    Arver::KeySaver.save( "test", s )
    Arver::KeySaver.save( "test", s )
    Arver::KeySaver.save( "test", s )
  end

  it "applies padding to the keys" do
    self.load_test_config
    s = "test\ntest"
    Arver::KeySaver.purge_keys( "test" )
    path = Arver::KeySaver.save( "test", s )
    size = File.size?( path )
    Arver::KeySaver.purge_keys( "test" )
    path = Arver::KeySaver.save( "test", s )
    File.size?( path ).should_not == size
  end
end
