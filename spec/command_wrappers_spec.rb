require File.dirname(__FILE__) + '/spec_helper.rb'
require 'etc'

describe "CommandWrapper" do

  before(:each) do
    self.extend( TestConfigLoader )
    self.load_sample_tree
  end  

  it "can execute commands" do
    caller = Arver::CommandWrapper.create( "echo", ["-n","hi"] )
    caller.escaped_command().include?("echo").should == true
    caller.execute.should == true
    caller.success?.should == true
    'hi'.should == caller.output
  end

  it "should not leak input" do
    caller = Arver::CommandWrapper.create( "false", [] )
    caller.stub( :run ) do | command, input |
      command.include?( "test" ).should be_falsey
      input.include?( "test" ).should be_truthy
    end
    caller.execute( "test" )
  end
  
  it "can pipe content through" do
    caller = Arver::CommandWrapper.create( "cat" )
    caller.execute( "hello" ).should == true
    "hello\n".should == caller.output
  end
  
  it "can get the right return value" do
    caller = Arver::CommandWrapper.create( "false" )
    caller.execute.should == false
    caller.success?.should == false
  end

  it "can execute ssh commands" do
    host = Arver::Host.new( "localhost", Arver::Config.instance.tree )
    host.username= Etc.getlogin
    caller = Arver::SSHCommandWrapper.create( "echo", ["-n","hi"],  host )
    caller.execute.should == true
    'hi'.should == caller.output
  end

end
