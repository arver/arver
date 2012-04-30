begin
  require 'cucumber'
  require 'cucumber/rake/task'
  has_cucumber = true
rescue LoadError
  puts "cucumber bdd framework not available (only needed for development)"
end

if has_cucumber
  Cucumber::Rake::Task.new(:cucumber) do |t|
  end
end
