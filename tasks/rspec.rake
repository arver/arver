require 'rspec/core/rake_task'

desc "Run the specs under spec/models"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--options', "spec/spec.opts"]
end
