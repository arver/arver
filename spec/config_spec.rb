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
    config.tree.child( "nts" ).child( "immer1.glei.ch" ).postscript.should == '/usr/local/sbin/startcryptedxens'
    i = 0
    config.tree.each_partition { i+=1 }
    i.should == 4
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
