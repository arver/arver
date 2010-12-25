# add a reset instance for singleton
require 'singleton'
class <<Singleton
  def included_with_reset(klass)
    included_without_reset(klass)
    class <<klass
      def reset_instance
        Singleton.send :__init__, self
        self
      end
    end
  end
  alias_method :included_without_reset, :included
  alias_method :included, :included_with_reset
end

require File.dirname(__FILE__) + "/../../lib/arver"

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'

require 'spec/stubs/cucumber'

Before do
  @tmp_root = File.dirname(__FILE__) + "/../../tmp"
  @home_path = File.expand_path(File.join(@tmp_root, "home"))
  @lib_path  = File.expand_path(File.dirname(__FILE__) + "/../../lib")
  FileUtils.rm_rf   @tmp_root
  FileUtils.mkdir_p @home_path
  ENV['HOME'] = @home_path

  @test_data_home = File.join(File.dirname(__FILE__),'..','testdata')
  @local_configs = {
    :valid => File.join(@test_data_home,'valid_local_config.yaml'),
    :invalid => File.join(@test_data_home,'invalid_local_config.yaml'),
    :nonexisting => File.join(@test_data_home,'nonexisting_local_config.yaml'),
  }
end
