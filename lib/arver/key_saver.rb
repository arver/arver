module Arver
  class KeySaver
    
    def self.save( user, key )
      unless check_key( user )
        return
      end
      gpg_key = key_of( user )
      key = add_padding( key )
      begin
        if( Arver::RuntimeConfig.instance.test_mode )
          # in test mode trust all keys since running arver in cucumber creates a fresh gpg-keyring
          key_encrypted = GPGME::encrypt( gpg_key, key , {:armor => true, :always_trust => true})
        else
          key_encrypted = GPGME::encrypt( gpg_key, key , {:armor => true})
        end
      rescue GPGME::Error => gpgerr
        Arver::Log.error( "GPGME Error #{gpgerr} Message: #{gpgerr.message}" )
        return
      end
      unless( Arver::RuntimeConfig.instance.dry_run )
        FileUtils.mkdir_p key_path(user) unless File.exists?( key_path(user) )
        filename = key_path(user)+"/"+OpenSSL::Digest::SHA1.new(key_encrypted).to_s
        File.open( filename, 'w' ) do |f|
          f.write key_encrypted
        end
      end
      filename
    end
    
    def self.key_of user
      conf = Arver::Config.instance
      conf.gpg_key( user )
    end
    
    def self.check_key( user )
      FileUtils.mkdir_p config_path+"/keys/public" unless File.exists?( config_path+"/keys/public" )
      key_id = key_of( user )
      if key_id.nil?
        Arver::Log.error( "No such user "+user )
        return false
      end
      user_pubkey = config_path+"/keys/public/"+user
      found_in_keyring = ! GPGME::list_keys( key_id ).empty?
      found_on_disk = File.exists?( user_pubkey )
      if( ! found_in_keyring && ! found_on_disk )
        Arver::Log.error( "No publickey for "+user+" found. Keys not saved" )
        return false
      end
      if( ! found_in_keyring && found_on_disk )
        key = File.read( user_pubkey )
        GPGME::import( key )
      end
      if( found_in_keyring )
        if( ! Arver::RuntimeConfig.instance.test_mode && GPGME::list_keys( key_id ).first.owner_trust != 5 )
          Arver::Log.error( "You do not trust the key of #{user}!\nYou have to set the trust-level using 'gpg --edit-key #{key_id}'.\nYou should verify the fingerprint over a secure channel." );
          return false
        end
        key = GPGME::export( key_id, { :armor => true } )
        if( found_on_disk )
          key_on_disk = File.read( user_pubkey )
          return true if key_on_disk == key
        end
        File.open( user_pubkey, 'w' ) do |f|
          f.write( key )
        end
      end
      true
    end
    
    def self.key_path( user )
      config_path+"/keys/"+user
    end
    
    def self.config_path
      Arver::LocalConfig.instance.config_dir
    end
    
    def self.purge_keys( user )
      FileUtils.rm_rf( key_path( user ) )
    end

    def self.num_of_key_files( user )
      Dir.entries( key_path( user ) ).size - 2
    end
    
    def self.read( user )
      check_key( user )
      return [] unless File.exists?( key_path( user ) )
      decrypted = []
      Dir.entries( key_path( user ) ).sort.each do | file |
        unless( file == "." || file == ".." )
          Arver::Log.trace( "Loading keyfile "+file )
          key_encrypted = File.read( key_path( user )+"/"+file )
          if( Arver::RuntimeConfig.instance.test_mode )
            `gpg --import ../spec/data/fixtures/test_key 2> /dev/null`
            decrypted_key = GPGME::decrypt( key_encrypted )
          else
            decrypted_key = GPGME::decrypt( key_encrypted, { :passphrase_callback => method( :passfunc) } )
          end
          decrypted_key = substract_padding( decrypted_key )
          decrypted += [ decrypted_key ];
        end
      end
      decrypted
    end

    def self.add_padding( key )
      marker = "--"+ActiveSupport::SecureRandom.base64( 52 )
      size = rand( 328800 )
      padding = ActiveSupport::SecureRandom.base64( 148800 + size )
      marker +"\n"+ key + "\n" + marker + "\n" + padding
    end
    
    def self.substract_padding( key )
      if( key.starts_with? '--- ' )
        Arver::Log.warn( "Warning: you are using deprecated unpadded keyfiles. Please run garbage collect!" )
        return key
      end
      marker = ""
      striped_key = ""
      key.each do |line|
        if( marker.empty? )
           marker = line
        elsif( line == marker )
          break
        else
          striped_key += line
        end
      end
      striped_key.chomp
    end
  end
end


def passfunc(hook, uid_hint, passphrase_info, prev_was_bad, fd)
  Arver::Log.write("Passphrase for #{uid_hint}: ")
  begin
    io = IO.for_fd(fd, 'w')
    io.puts( ask("") { |q| q.echo = false } )
    io.flush
  ensure
    (0 ... $_.length).each do |i| $_[i] = ?0 end if $_
  end
  Arver::Log.write("")
end

def testpassfunc(hook, uid_hint, passphrase_info, prev_was_bad, fd)
  $stderr.write("Passphrase for #{uid_hint}: (test Mode) ")
  $stderr.flush
  begin
    io = IO.for_fd(fd, 'w')
    io.puts( "test" )
    io.flush
  ensure
    (0 ... $_.length).each do |i| $_[i] = ?0 end if $_
  end
  $stderr.puts
end

