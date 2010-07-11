module Arver
  class KeySaver
    def self.save(key)
      File.open( "/tmp/key", 'w' ) do |f|
        f.write key
      end
    end
    def self.read
      File.read( "/tmp/key")
    end
  end
end