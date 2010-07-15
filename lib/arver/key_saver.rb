module Arver
  class KeySaver
    def self.save( user, key )
      conf = Arver::Config.instance
      gpg_key = conf.gpg_key( user )
      key_encrypted = GPGME::encypt( gpg_key, key )
      File.open( "/tmp/key", 'w' ) do |f|
        f.write key_encrypted
      end
    end
    def self.read
      key_encrypted = File.read( "/tmp/key")
      GPGME::decrypt( key_encrypted )
    end
  end
end