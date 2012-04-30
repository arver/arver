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
    config.tree.child( "location2" ).child( "machine2" ).address.should == 'two.example.tld'
    i = 0
    config.tree.each_partition { i+=1 }
    i.should == 5
    config.gpg_key( "test" ).should == "2CF22C173F56F59E84CCEB152A4A13ED46425E3B"
  end 

  it "can read partitions" do
    self.load_test_config
    config = Arver::Config.instance
    config.tree.child( "location2" ).child( "machine2" ).child( "virt1_rootfs" ).device.should == "/dev/nonraidstorage/virt1_rootfs"

  end
  
  it "can read users" do
    self.load_test_config
    config = Arver::Config.instance
    config.tree.child( "location1" ).child( 'machine1_1.example.tld' ).username.should == 'test'
  end 

  it "can save the config to disk" do
    self.load_test_config
    config = Arver::Config.instance
    old = Marshal.load( Marshal.dump( config ) )
    config.save
    config.load
    config.should == ( old )
  end
 
  it "can load all the skript hooks" do
    self.load_test_config
    config = Arver::Config.instance
    host = config.tree.child( "location1" ).child( 'machine1_1.example.tld' )
    host.pre_open.should == "pre_open_host_script.sh"
    host.pre_close.should == "pre_close_host_script.sh"
    host.post_open.should == "post_open_host_script.sh"
    host.post_close.should == "post_close_host_script.sh"
    disk = host.child( 'virtmachine1' )
    disk.pre_open.should == "pre_open_disk_script.sh"
    disk.pre_close.should == "pre_close_disk_script.sh"
    disk.post_open.should == "post_open_disk_script.sh"
    disk.post_close.should == "post_close_disk_script.sh"
  end
 
end
