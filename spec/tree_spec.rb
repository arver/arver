require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe "Config" do
  
  before(:each) do
    self.extend( TestConfigLoader )
    self.load_sample_tree
  end
  
  
  it "can iterate" do
    test_disks = [ @d, @d2, @d3, @d4 ]    
    Arver::Config.instance.tree.each_partition do | partition |
      #TODO: thats a horrible line. How can i test if an aray contains an element???
      #sth like:  test_disks.should include?( partition )
      ( test_disks - [ partition ] ).should_not == test_disks
      test_disks.delete( partition )
    end
    test_disks.size.should == 0 
  end
  
  it "generates corect path" do
    @d.path.should == "/testG/testH/testP1"
  end
  
  it "can compare trees" do
    other = Marshal.load( Marshal.dump( Arver::Config.instance.tree ) )
    Arver::Host.new "testOther", other.child( "testG" )
    other.should != Arver::Config.instance.tree
  end
  
end
