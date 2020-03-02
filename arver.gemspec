# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)
require 'arver/version'

Gem::Specification.new do |s|
  s.name         = "arver"
  s.version      = Arver::VERSION
  s.authors      = ["o","andreas","mh"]
  s.email        = "arver@lists.immerda.ch"
  s.homepage     = "https://code.immerda.ch/immerda/apps/arver"
  s.summary      = "LUKS for groups"
  s.description  = "Arver helps you to share access to LUKS devices easily and safely in a team"

  s.files        = `git ls-files lib`.split("\n") + %w(README.textile CHANGELOG.textile man/arver.5)
  s.executables =  [ 'arver' ]
  s.platform     = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2'
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'
  s.add_dependency('gpgme','>=2.0.0')
  s.add_dependency('highline','>=1.6.2')
  s.add_development_dependency('cucumber', '>=0.10.2')
  s.add_development_dependency('rspec', '>=2.5.0')
  s.add_development_dependency('rake', '>=0.9.2')
end
