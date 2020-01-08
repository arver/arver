require 'rspec'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'arver'

RSpec.configure do |c|
  c.expect_with(:rspec) { |c| c.syntax = :should }
end
