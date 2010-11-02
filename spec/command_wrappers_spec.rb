require File.dirname(__FILE__) + '/spec_helper.rb'

describe "CommandWrapper" do
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
  

end
