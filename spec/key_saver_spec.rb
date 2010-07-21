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
    Arver::KeySaver.save( "test", s )
    puts "\n-->  !!! SPEC: Pw of test is 'test' !!!"
    Arver::KeySaver.read( "test" ).should == s
  end
end
