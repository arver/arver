module Arver
  class KeySaver
    
    def self.save( user, key )
      check_key( user )
      gpg_key = key_of( user )
      key_encrypted = GPGME::encrypt( gpg_key, key )
      FileUtils.mkdir_p config_path+"/keys/"+user unless File.exists?( config_path+"/keys/"+user )
      File.open( next_key_path( user ), 'w' ) do |f|
        f.write key_encrypted
      end
    end
    
    def self.key_of user
      conf = Arver::Config.instance
      conf.gpg_key( user )
    end
    
    def self.check_key( user )
      FileUtils.mkdir_p config_path+"/keys/public" unless File.exists?( config_path+"/keys/public" )
      key_id = key_of( user )
      if key_id.nil?
        puts "no such user "+user
        exit
      end
      user_pubkey = config_path+"/keys/public/"+user
      found_in_keyring = ! GPGME::list_keys( key_id ).empty?
      found_on_disk = File.exists?( user_pubkey )
      if( ! found_in_keyring && ! found_on_disk )
        puts "No publickey for "+user+" found"
        exit
      end
      if( ! found_in_keyring && found_on_disk )
        key = File.read( user_pubkey )
        GPGME::import( key )
      end
      if( found_in_keyring && ! found_on_disk )
        key = GPGME::export( key_id, { :armor => true } )
        File.open( user_pubkey, 'w' ) do |f|
          f.write( key )
        end
      end
    end
    
    def self.next_key_path( user )
      nextNumber = Dir.entries( key_path( user ) ).size - 2
      nextNumber += 1 while( File.exists?( key_path( user )+"/key_"+nextNumber.to_s ) )
      key_path(user)+"/key_"+nextNumber.to_s
    end

    def self.key_path( user )
      config_path+"/keys/"+user
    end
    
    def self.config_path
      Arver::LocalConfig.instance.config_dir
    end
    
    def self.isTestUser user
      key_of( user ) == "46425E3B"
    end
    
    def self.purge_keys( user )
      FileUtils.rm_rf( key_path( user ) )
    end
    
    def self.read( user )
      check_key( user )
      return [] unless File.exists?( key_path( user ) )
      decrypted = []
      Dir.entries( key_path( user ) ).sort.each do | file |
        unless( file == "." || file == ".." )
          key_encrypted = File.read( key_path( user )+"/"+file )
          if( isTestUser( user ) )
            decrypted += [ GPGME::decrypt( key_encrypted, { :passphrase_callback => method( :testpassfunc ) } ) ]
          else
            decrypted += [ GPGME::decrypt( key_encrypted, { :passphrase_callback => method( :passfunc ) } ) ]
          end
        end
      end
      decrypted
    end
  end
end

def passfunc(hook, uid_hint, passphrase_info, prev_was_bad, fd)
  $stderr.write("Passphrase for #{uid_hint}: ")
  $stderr.flush
  begin
    io = IO.for_fd(fd, 'w')
    io.puts( ask("") { |q| q.echo = false } )
    io.flush
  ensure
    (0 ... $_.length).each do |i| $_[i] = ?0 end if $_
  end
  $stderr.puts
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
