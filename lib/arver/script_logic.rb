module Arver
  class ScriptLogic
    def self.open args
      target = args[:target]
      puts "open was called with target "+target
    end
    def self.adduser args
      target = args[:target]
      user = args[:user]
      puts "adduser was called with target "+target+" and user "+user
    end
    def self.deluser args
      target = args[:target]
      user = args[:user]
      puts "deluser was called with target "+target+" and user "+user
    end
  end
end