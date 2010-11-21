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
  s.required_rubygems_version = '>= 1.3.5'
  s.add_dependency('gpgme','>=1.0.8')
  s.add_dependency('highline','>=1.6.1')
  s.add_dependency('i18n','>=0.4.1')
  s.add_dependency('escape','>=0.0.4')
  s.add_dependency('activesupport','>=2.3.8')
end
