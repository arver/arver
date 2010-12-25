Given /^there is a key for all test Partitions/ do
  `cp spec/data/fixtures/test_key_000001 spec/data/keys/test/key_000001`
end

Given /^there are two keyfiles/ do
  `cp spec/data/fixtures/test_key_000001 spec/data/keys/test/key_000001`
  `cp spec/data/fixtures/test_key_000001 spec/data/keys/test/key_000002`
end

Given /^there is an unpadded keyfile/ do
  `cp spec/data/fixtures/test_key_000001_unpadded spec/data/keys/test/key_000001`
end

Given /^there will be a failure/ do
  cm = Arver::SSHCommandWrapper.new
  cm.stub(:return_value).and_return(1)
  Arver::SSHCommandWrapper.stub(:new).and_return(cm)
 # Arver::CommandWrapper.test_failure
end

Given /^all disks seem closed/ do
  command = Arver::SSHCommandWrapper.new
  command.stub(:execute).and_return(false)
  Arver::LuksWrapper.stub(:open?).and_return( command  )
end

Given /^all disks seem open/ do
  command = Arver::SSHCommandWrapper.new
  command.stub(:execute).and_return(true)
  Arver::LuksWrapper.stub(:open?).and_return( command  )
end

Given /^external commands will return "(.*)"/ do  | txt |
  cm = Arver::SSHCommandWrapper.new
  cm.stub(:output).and_return(txt)
  Arver::SSHCommandWrapper.stub(:new).and_return(cm)
 # Arver::CommandWrapper.test_spoof_output( txt )
end

Given /^there are no permissions set for "(.*)"/ do  | user |
  `rm -rf spec/data/keys/#{user}/key_*`
end

When /^I run arver in test mode with arguments "(.*)"/ do | arguments|

  in_project_folder do  
   require 'rubygems'
   require File.expand_path("../lib/arver")
   require File.expand_path("../lib/arver/cli")
   arguments = "--vv -u test -c ../spec/data --test-mode "+arguments

   @stdout = File.expand_path(File.join(@tmp_root, "executable.out"))
   Arver::CLI.execute( File.open(@stdout,'w'), arguments.split(" ") )
  end

end

When /^I run arver in test mode with user "(.*)" and arguments "(.*)"/ do | user, arguments|

  in_project_folder do  
   require 'rubygems'
   require File.expand_path("../lib/arver")
   require File.expand_path("../lib/arver/cli")
   arguments = "--vv -u #{user} -c ../spec/data --test-mode "+arguments
   
   @stdout = File.expand_path(File.join(@tmp_root, "executable.out"))
   Arver::CLI.execute( File.open(@stdout,'w'), arguments.split(" ") )
  end

end

Then /^I should see "([^\"]*)"$/ do |text|
  output = File.read(@stdout)
  output.should contain(text)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  output = File.read(@stdout)
  output.should_not contain(text)
end

Then /^I should see (\d+) lines of output$/ do |num|
  output = File.read(@stdout)
  output.split("\n").size().should == Integer(num)
end

Then /^I should see exactly "([^\"]*)"$/ do |text|
  output = File.read(@stdout)
  output.should == text
end
