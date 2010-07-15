%w{ singleton yaml fileutils active_support gpgme }.each {|f| require f }
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
 
%w{ string config test_hierarchy_loader partition_hierarchy_node partition_hierarchy_root host hostgroup tree partition test_partition key_saver keystore luks_key }.each {|f| require "arver/#{f}" }

module Arver
  VERSION = '0.0.1'
end
