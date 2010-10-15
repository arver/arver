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

  it "applies padding to the keys" do
    self.load_test_config
    s = "test\ntest"
    Arver::KeySaver.purge_keys( "test" )
    Arver::KeySaver.save( "test", s )
    path =  Arver::KeySaver.key_path( "test" )+"/key_000001"
    size = File.size?( path )
    Arver::KeySaver.purge_keys( "test" )
    Arver::KeySaver.save( "test", s )
    File.size?( path ).should_not == size
  end
end
