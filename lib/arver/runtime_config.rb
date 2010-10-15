module Arver
  class RuntimeConfig 
    
    #this Config Object holds the runtime config (i.e. commandline switches etc..)
    
    include Singleton

    attr_accessor :test_mode, :dry_run, :force, :violence, :ask_password
    
  end
end
