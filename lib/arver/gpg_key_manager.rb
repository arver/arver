module Arver
  class GPGKeyManager
    class << self
      def _key_of( user )
        conf = Arver::Config.instance
        fp = conf.gpg_key( user )
        return false if fp.nil?
        fp = fp.gsub(" ","")
        key = GPGME::Key.find(:public, fp)
        if key.size != 1
          return false
        end
        key = key.first
        if fp.size != 8 && fp != key.fingerprint
          return false
        end
        key
      end

      def key_of( user )
        key = _key_of( user )
        unless key
          Arver::Log.error( "There is no unique gpg key for #{user} with the fiven fingerprint available." )
          return false
        end
        key
      end
      
      def check_key_of( user )
        conf = Arver::Config.instance
        fp = conf.gpg_key( user )
        if fp.nil?
          Arver::Log.error( "#{user} has no gpg fingerprint defined." )
          return false
        end
        fp = fp.gsub(" ","")
        if fp.size == 8
          Arver::Log.error( "Please use the full fingerprint to define the gpg key for #{user}. The current config might be ambiguous." )
        end
        
        if( Arver::RuntimeConfig.instance.test_mode )
          `gpg --import ../spec/data/fixtures/test_key 2> /dev/null`
        end

        config_path = Arver::LocalConfig.instance.config_dir
        FileUtils.mkdir_p "#{config_path}/keys/public" unless File.exists?( "#{config_path}/keys/public" )
        key = _key_of( user )
        user_pubkey_file = config_path+"/keys/public/"+user
        on_disk = File.exists?( user_pubkey_file )
        
        if ! key && ! on_disk
          Arver::Log.error( "No publickey for #{user} found. Aborting all actions." )
          return false
        end
        if ! key && on_disk
          Arver::Log.warn( "Importing Publickey for #{user} from #{user_pubkey_file} into gpg keyring." )
          key_import = File.read( user_pubkey_file )
          GPGME::Key.import(key_import)
          key = _key_of( user )
        end
        if key 
          if( ! Arver::RuntimeConfig.instance.trust_all && key.owner_trust != 5 )
            Arver::Log.error( "You do not trust the key of #{user}!\nYou have to set the trust-level using 'gpg --edit-key #{key.primary_subkey.keyid}'.\nYou should verify the fingerprint over a secure channel." );
            return false
          end
          key_export = key.export( :armor => true ).read
          if on_disk
            key_on_disk = File.read( user_pubkey_file )
            return true if key_on_disk == key_export
          end
          File.open( user_pubkey_file, 'w' ) do |f|
            f.write( key_export )
          end
        end
        true
      end
    end
  end
end

