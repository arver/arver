require File.dirname(__FILE__) + '/spec_helper.rb'
require 'ftools'

describe "LuksWrapper" do 

  attr_accessor :partition, :host
 
  before(:each) do
    self.extend( TestConfigLoader )
    self.load_sample_tree
    self.host= Arver::Host.new( "localhost", Arver::Config.instance.tree )
    host.username= "root"
    script= File.expand_path("spec/data/fixtures/test_hook_script.sh")
    host.pre_open= script
  end

  it "executes pre_open hostscript" do
    action = Arver::OpenAction.new( [ host ] )
    action.run_on( host )
    File.exists?( "/tmp/arver-hook-executed" ).should == true
    File.safe_unlink( "/tmp/arver-hook-executed" )
  end

end
