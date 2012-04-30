module Arver
  class KeySaver
    
    def self.save( user, key )
      unless GPGKeyManager.check_key_of( user )
        return
      end
      gpg_key = GPGKeyManager.key_of( user )
      key = add_padding( key )
      crypto = GPGME::Crypto.new :armor => true
      begin
        if( Arver::RuntimeConfig.instance.trust_all )
          encrypted = crypto.encrypt( key, {:recipients => gpg_key.fingerprint, :always_trust => true})
        else
          encrypted = crypto.encrypt( key, {:recipients => gpg_key.fingerprint, :armor => true})
        end
      rescue GPGME::Error => gpgerr
        Arver::Log.error( "GPGME Error #{gpgerr} Message: #{gpgerr.message}" )
        return
      end
      key_encrypted = encrypted.read
      unless( Arver::RuntimeConfig.instance.dry_run )
        FileUtils.mkdir_p key_path(user) unless File.exists?( key_path(user) )
        filename = key_path(user)+"/"+OpenSSL::Digest::SHA1.new(key_encrypted).to_s
        File.open( filename, 'w' ) do |f|
          f.write key_encrypted
        end
      end
      filename
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
      GPGKeyManager.check_key_of( user )
      return [] unless File.exists?( key_path( user ) )
      decrypted = []
      crypto = GPGME::Crypto.new
      Dir.entries( key_path( user ) ).sort.each do | file |
        unless( file == "." || file == ".." )
          Arver::Log.trace( "Loading keyfile "+file )
          key_encrypted = File.read( key_path( user )+"/"+file )
          if( Arver::RuntimeConfig.instance.test_mode )
            `gpg --import ../spec/data/fixtures/test_key 2> /dev/null`
            decrypted_txt = crypto.decrypt( key_encrypted )
          else
            decrypted_txt = crypto.decrypt( key_encrypted, { :passphrase_callback => method( :passfunc ) } )
          end
          decrypted_key = substract_padding( decrypted_txt.read )
          decrypted += [ decrypted_key ];
        end
      end
      decrypted
    end

    def self.add_padding( key )
      marker = "--"+ActiveSupport::SecureRandom.base64( 82 )
      size = 450000
      padding_size = size - key.size
      if padding_size <= 0
        padding_size = 0
        Arver::Log.warn( "Warning: Your arver keys exceed the maximal padding size, therefore i can no longer disguise how many keys you possess.")
      end
      padding = ActiveSupport::SecureRandom.base64( padding_size )
      marker +"\n"+ key + "\n" + marker + "\n" + padding
    end
    
    def self.substract_padding( key )
      if( key.starts_with? '--- ' )
        Arver::Log.warn( "Warning: you are using deprecated unpadded keyfiles. Please run garbage collect!" )
        return key
      end
      marker = ""
      striped_key = ""
      key.each_line do |line|
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

