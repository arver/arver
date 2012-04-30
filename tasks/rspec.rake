begin
  require 'rspec/core/rake_task'
  has_rspec = true
rescue LoadError
    puts "rspec testing framework not available (only needed for development)"
end

if has_rspec
  desc "Run the specs under spec/models"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = ['--options', "spec/spec.opts"]
  end
end
