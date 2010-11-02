module Arver
  class RuntimeConfig 
    
    #this Config Object holds the runtime config (i.e. commandline switches etc..)
    
    include Singleton

    attr_accessor :test_mode, :dry_run, :force, :violence, :ask_password
    
    instance.test_mode= false
    instance.dry_run= false
    instance.force= false
    instance.violence= false
    instance.ask_password= false
    
  end
end
