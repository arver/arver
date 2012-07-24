require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Roundtrip" do 

  it "can do a roundtrip" do
    puts "to run this spec you need to import spec/data/fixtures/test_key and spec/roundtrip_config/fixtures/other_test_key"

    host= Arver::Host.new( "localhost", Arver::Config.instance.tree )
    host.username= "root"
    tmpContainer= File.expand_path("./tmp/luks.bin")
    `dd if=/dev/zero of=#{tmpContainer} bs=1024k count=5 2> /dev/null `
    c = Arver::SSHCommandWrapper.create( "losetup", [ "-a" ], host, true )
    c.execute
    if( c.output.include?( "arver/tmp/luks.bin" ) )
      c = Arver::SSHCommandWrapper.create( "losetup", [ "-d", "/dev/loop2" ], host, true )
      c.execute
    elsif( c.output.include?( "loop2" )  || ! c.success? )
      print "cannot create loop device, since loop2 already exists"
      #this exit is important! we don't want to remove loopdevices in after(:each), we didn't create!
      exit
    end
    c = Arver::SSHCommandWrapper.create( "losetup", [ "/dev/loop2", tmpContainer ], host, true )
    c.execute
  
    FileUtils.rm_rf 'spec/roundtrip_config/keys'
 
    arver = './bin/arver -c spec/roundtrip_config'

    `#{arver} -u test --create arver_test_luks_device`
    `#{arver} -u test --open arver_test_luks_device`
    File.exists?( '/dev/mapper/arver_test_luks_device' ).should be_true

    `#{arver} -u test --close arver_test_luks_device`
    File.exists?( '/dev/mapper/arver_test_luks_device' ).should_not be_true
 
    `#{arver} -u test_other --open arver_test_luks_device`
    File.exists?( '/dev/mapper/arver_test_luks_device' ).should_not be_true
    
    `#{arver} -u test --add-user test_other arver_test_luks_device`
    
    `#{arver} -u test_other --open arver_test_luks_device`
    File.exists?( '/dev/mapper/arver_test_luks_device' ).should be_true
  
    `#{arver} -u test_other --close arver_test_luks_device`

    key = `ls spec/roundtrip_config/keys/test_other`
    
    `#{arver} -u test_other --refresh arver_test_luks_device`
    `ls spec/roundtrip_config/keys/test_other`.should_not == key
    
    `#{arver} -u test_other --open arver_test_luks_device`
    File.exists?( '/dev/mapper/arver_test_luks_device' ).should be_true

    `#{arver} -u test_other --close arver_test_luks_device`
    File.exists?( '/dev/mapper/arver_test_luks_device' ).should_not be_true
    
    FileUtils.rm_rf 'spec/roundtrip_config/keys'
    
    c = Arver::SSHCommandWrapper.create( "losetup", [ "-d", "/dev/loop2" ], host, true )
    c.execute
  end
 
end
