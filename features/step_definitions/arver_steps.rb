After do  
  # remove all stubbed methods after each scenario
  Mocha::Mockery.instance.stubba.unstub_all
  Arver::CommandWrapper.reset_test
end

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
  Arver::CommandWrapper.test_failure
end

Given /^external commands will return "(.*)"/ do  | txt |
  Arver::CommandWrapper.test_spoof_output( txt )
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
   
   Arver::Log.logger= Arver::StringLogger.new( Arver::LogLevels::Debug)

   Arver::CLI.execute( arguments.split(" ") )
  end

end

When /^I run arver in test mode with user "(.*)" and arguments "(.*)"/ do | user, arguments|

  in_project_folder do  
   require 'rubygems'
   require File.expand_path("../lib/arver")
   require File.expand_path("../lib/arver/cli")
   arguments = "--vv -u #{user} -c ../spec/data --test-mode "+arguments
   
   Arver::Log.logger= Arver::StringLogger.new( Arver::LogLevels::Debug)

   Arver::CLI.execute( arguments.split(" ") )
  end

end

Then /^I should see "([^\"]*)"$/ do |text|
  Arver::Log.logger.log.should contain(text)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  Arver::Log.logger.log.should_not contain(text)
end

Then /^I should see (\d+) lines of output$/ do |num|
  Arver::Log.logger.log.split("\n").size().should == Integer(num)
end

Then /^I should see exactly "([^\"]*)"$/ do |text|
  Arver::Log.logger.log.should == text
end
