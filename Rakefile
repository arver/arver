require 'rake/testtask'
require "rubygems/package_task"
require "rake/clean"
require 'rake'

CLEAN << "pkg" << "doc"
task :default => [:spec, :features ]

Dir['tasks/**/*.rake'].each { |t| load t }

Gem::PackageTask.new(eval(File.read("arver.gemspec"))) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end


