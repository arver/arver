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

Given /^there are no permissions set/ do
  `rm -rf spec/data/keys/test/key_*`
end

When /^I run arver in test mode with arguments "(.*)"/ do | arguments|

  in_project_folder do  
   require 'rubygems'
   require File.expand_path("../lib/arver")
   require File.expand_path("../lib/arver/cli")
   arguments = "-u test -c ../spec/data --test-mode "+arguments
   
   Arver::Log.logger= Arver::StringLogger.new( Arver::LogLevels::Debug)

   Arver::CLI.execute( arguments.split(" ") )
  end

end

Then /^I should see "([^\"]*)"$/ do |text|
  Arver::Log.logger.log.should contain(text)
end

Then /^I should see "([^\"]*)" lines of output$/ do |num|
  Arver::Log.logger.log.split("\n").size().should == num
end

Then /^I should see$/ do |text|
  Arver::Log.logger.log.should contain(text)
end

Then /^I should not see$/ do |text|
  Arver::Log.logger.log.should_not contain(text)
end

Then /^I should see exactly$/ do |text|
  Arver::Log.logger.log.should == text
end

