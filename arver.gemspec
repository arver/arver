# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)
require 'arver/version'

Gem::Specification.new do |s|
  s.name         = "arver"
  s.version      = Arver::VERSION
  s.authors      = ["o","andreas","mh"]
  s.email        = "arver@lists.immerda.ch"
  s.homepage     = "https://git.codecoop.org/projects/arver"
  s.summary      = "Open crypted devices automatically"
  s.description  = "Arver helps you to manage a large amount of crypted devices easily and safe amongst a certain amount of members"


  s.files        = `git ls-files lib`.split("\n") + %w(README.textile CHANGELOG.textile man/arver.5)
  s.executables =  [ 'arver' ]
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'
  s.add_dependency('gpgme','>=2.0.0')
  s.add_dependency('highline','>=1.6.2')
  s.add_dependency('escape','>=0.0.2')
  s.add_dependency('activesupport','<3.0.0')
  s.add_development_dependency('cucumber', '>=0.10.2')
  s.add_development_dependency('rspec', '>=2.5.0')
  s.add_development_dependency('rake', '>=0.9.2')
end
