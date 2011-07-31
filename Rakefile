require 'rake/testtask'
require "rake/gempackagetask"
require "rake/clean"
require 'rake'

CLEAN << "pkg" << "doc" << "coverage"
task :default => [:spec, :features ]

Dir['tasks/**/*.rake'].each { |t| load t }

Rake::GemPackageTask.new(eval(File.read("arver.gemspec"))) { |pkg| }


