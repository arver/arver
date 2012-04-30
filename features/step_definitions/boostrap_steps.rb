Before do
    @options = { :user => '', :config_dir => ''}
end


When /^I boostrap arver$/ do
  Arver::Config.instance.stub( :load ).and_return( true )
  @bootstrap_process = Arver::Bootstrap.run(@options)
end

Then /^the bootstrap process should be (.*)$/ do |res|
  @bootstrap_process.to_s.should == res
end

Given /^I supply a username with a (.*) key$/ do |keytype|
  @options[:user] = 'foo'
  Arver::GPGKeyManager.stub(:check_key_of).and_return(keytype == 'existing')
  Arver::Config.instance.stub(:exists?).and_return(keytype == 'existing')
end

Given /^I don't supply any user as the one I use is correct$/ do
  Arver::GPGKeyManager.stub(:check_key_of).and_return(true)
  Arver::Config.instance.stub(:exists?).and_return(true)
end
