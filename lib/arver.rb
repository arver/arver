%w{ singleton yaml fileutils active_support gpgme highline/import escape }.each {|f| require f }
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
 
%w{ action create_action target_list command_wrapper ssh_command_wrapper log_levels string_logger io_logger log string script_logic local_config config test_config_loader partition_hierarchy_node host hostgroup tree partition test_partition key_generator key_saver keystore runtime_config }.each {|f| require "arver/#{f}" }

module Arver
  VERSION = '0.0.1'
end
