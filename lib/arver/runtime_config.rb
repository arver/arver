module Arver
  class RuntimeConfig 
    
    #this Config Object holds the runtime config (i.e. commandline switches etc..)
    
    include Singleton

    attr_accessor :test_mode, :dry_run, :force, :violence, :ask_password, :trust_all, :global_key_path
    
    instance.test_mode= false
    instance.dry_run= false
    instance.force= false
    instance.violence= false
    instance.ask_password= false
    instance.trust_all= false

    def trust_all
      # in test mode trust all keys since running arver in cucumber creates a fresh gpg-keyring
      @trust_all || @test_mode
    end
  end
end
