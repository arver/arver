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
      test_disks.include?(partition).should be_true
      test_disks.delete( partition )
    end
    test_disks.should be_empty
  end
  
  it "generates corect path" do
    @d.path.should == "/testG/testH/testP1"
  end
  
  it "can compare trees" do
    other = Marshal.load( Marshal.dump( Arver::Config.instance.tree ) )
    other.should == Arver::Config.instance.tree
    other.children["testG"] = ""
    other.should_not == Arver::Config.instance.tree
  end
  
end
