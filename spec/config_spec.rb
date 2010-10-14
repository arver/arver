require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe "Config" do
  
  before(:each) do
    self.extend( TestConfigLoader )
  end
  
  it "can load the test disks config" do
    self.load_test_config
    config = Arver::Config.instance
    config.tree.child( "location2" ).child( "machine1" ).postscript.should == '/usr/local/sbin/startcryptedxens'
    config.tree.child( "location2" ).child( "machine2" ).address.should == 'two.example.tld'
    i = 0
    config.tree.each_partition { i+=1 }
    i.should == 5
    config.gpg_key( "test" ).should == "46425E3B"
  end  

  it "can save the config to disk" do
    self.load_test_config
    config = Arver::Config.instance
    old = Marshal.load( Marshal.dump( config ) )
    config.save
    config.load
    config.should == ( old )
  end
  
end
