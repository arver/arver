After do
  Arver::LocalConfig.reset_instance
end

Given /^a (.*) local configuration file$/ do |ctype|
  Arver::LocalConfig.instance.stub( :path ).and_return( @local_configs[ctype.to_sym] )
end

When /^I load the local_config$/ do
  @local_config = Arver::LocalConfig.instance 
end

Then /^the local_config value (.*) should be (.*)$/ do |citem,value|
  @local_config.config[citem].should == value
end

Then /^the local_config value (.*) should be$/ do |citem|
  @local_config.config[citem].should == ''
end
