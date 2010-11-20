require 'rake/testtask'
require "rake/gempackagetask"
require "rake/clean"

CLEAN << "pkg" << "doc" << "coverage"
task :default => [:spec, :features ]

Rake::GemPackageTask.new(eval(File.read("arver.gemspec"))) { |pkg| }


