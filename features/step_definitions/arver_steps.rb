Given /^there is a key for all test Partitions/ do
  `cp spec/data/fixtures/test_key_000001 spec/data/keys/test/key_000001`
end

Given /^there are no permissions set/ do
  `rm -rf spec/data/keys/test/key_*`
end

When /^I run arver with arguments "(.*)"/ do | arguments|
  @stdout = File.expand_path(File.join(@tmp_root, "executable.out"))
  in_project_folder do
    system "../bin/arver #{arguments} > #{@stdout} 2> #{@stdout}"
  end
end

When /^I run arver in test mode with arguments "(.*)"/ do | arguments|
  @stdout = File.expand_path(File.join(@tmp_root, "executable.out"))
  in_project_folder do
    system "../bin/arver -u test -c ../spec/data --test-mode #{arguments} > #{@stdout} 2> #{@stdout}"
  end
end
