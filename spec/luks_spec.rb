require File.dirname(__FILE__) + '/spec_helper.rb'

describe "LuksWrapper" do 

  attr_accessor :partition, :host
 
  before(:each) do
    self.extend( TestConfigLoader )
    self.load_sample_tree
    self.host= Arver::Host.new( "localhost", Arver::Config.instance.tree )
    host.username= "root"
    self.partition= Arver::Partition.new( "test", host )
    tmpContainer= File.expand_path("./tmp/luks.bin")
    `dd if=/dev/zero of=#{tmpContainer} bs=1024k count=5 2> /dev/null `
    c = Arver::SSHCommandWrapper.new( "losetup", [ "-a" ], host, true )
    c.execute
    if( c.output.include?( "arver/tmp/luks.bin" ) )
      c = Arver::SSHCommandWrapper.new( "losetup", [ "-d", "/dev/loop2" ], host, true )
      c.execute
    elsif( c.output.include?( "loop2" )  || ! c.success? )
      print "cannot create loop device, since loop2 already exists"
      #this exit is important! we don't want to remove loopdevices in after(:each), we didn't create!
      exit
    end
    c = Arver::SSHCommandWrapper.new( "losetup", [ "/dev/loop2", tmpContainer ], host, true )
    c.execute
    partition.device= "loop2"
  end

  after(:each) do
    c = Arver::SSHCommandWrapper.new( "losetup", [ "-d", "/dev/loop2" ], host, true )
    c.execute
  end
  
  it "can create, open and close" do
    c = Arver::LuksWrapper.create( "0", partition )
    c.execute( "test_key" )
    c.success?.should == true
    c = Arver::LuksWrapper.open( partition )
    c.execute( "test_key" )
    c.success?.should == true
    c = Arver::LuksWrapper.close( partition )
    c.execute
    c.success?.should == true
  end

  it "can add and remove a key" do
    c = Arver::LuksWrapper.create( "0", partition )
    c.execute( "test_key" )
    c = Arver::LuksWrapper.addKey( "1", partition )
    c.execute( "test_key\ntest2_key" )
    c.success?.should == true
    c = Arver::LuksWrapper.open( partition )
    c.execute( "test2_key" )
    c.success?.should == true
    c = Arver::LuksWrapper.close( partition )
    c.execute
    c = Arver::LuksWrapper.killSlot( "1", partition )
    c.execute( "test_key" )
    c.success?.should == true
    c = Arver::LuksWrapper.open( partition )
    c.execute( "test2_key" )
    c.success?.should == false
    c.execute( "test_key" )
    c.success?.should == true
    c = Arver::LuksWrapper.close( partition )
    c.execute
  end

  it "can dump infos" do
    c = Arver::LuksWrapper.create( "0", partition )
    c.execute( "test_key" )
    c = Arver::LuksWrapper.dump( partition )
    c.execute
    c.output.include?( "LUKS header information for /dev/loop2" ).should == true
  end
end
