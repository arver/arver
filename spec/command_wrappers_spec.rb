require File.dirname(__FILE__) + '/spec_helper.rb'
require 'etc'

describe "CommandWrapper" do

  before(:each) do
    self.extend( TestConfigLoader )
    self.load_sample_tree
  end  

  it "can execute commands" do
    caller = Arver::CommandWrapper.new( "echo", ["-n","hi"] )
    caller.escaped_command().include?("echo").should == true
    caller.escaped_total_command("").include?("echo").should == true
    caller.execute.should == true
    caller.success?.should == true
    'hi'.should == caller.output
  end
  
  it "can pipe content through" do
    caller = Arver::CommandWrapper.new( "cat" )
    caller.execute( "hello" ).should == true
    "hello\n".should == caller.output
  end
  
  it "can get the right return value" do
    caller = Arver::CommandWrapper.new( "false" )
    caller.execute.should == false
    caller.success?.should == false
  end

  it "can execute ssh commands" do
    host = Arver::Host.new( "localhost", Arver::Config.instance.tree )
    host.username= Etc.getlogin
    caller = Arver::SSHCommandWrapper.new( "echo", ["-n","hi"],  host )
    caller.execute.should == true
    'hi'.should == caller.output
  end

end
