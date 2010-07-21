module Arver
  class KeySaver
    
    def self.save( user, key )
      gpg_key = key_of( user )
      conf = Arver::Config.instance
      gpg_key = conf.gpg_key( user )
      GPGME::list_keys()
      key_encrypted = GPGME::encrypt( gpg_key, key )
      FileUtils.mkdir_p config_path+"/keys" unless File.exists?( config_path+"/keys" )
      FileUtils.mkdir_p config_path+"/keys/"+user unless File.exists?( config_path+"/keys/"+user )

      File.open( key_path( user ), 'w' ) do |f|
        f.write key_encrypted
      end
    end
    
    def self.key_of user
      conf = Arver::Config.instance
      conf.gpg_key( user )
    end
    
    def self.key_path( user )
      config_path+"/keys/"+user+"/key"
    end
    
    def self.config_path
      Arver::LocalConfig.instance.config_dir
    end
    
    def self.isTestUser user
      key_of( user ) == "46425E3B"
    end
    
    def self.read( user )
      return if( ! File.exists?( key_path( user ) ) )
      key_encrypted = File.read( key_path( user ) )
      if( isTestUser( user ) )
        GPGME::decrypt( key_encrypted, { :passphrase_callback => method( :testpassfunc ) } )
      else
        GPGME::decrypt( key_encrypted, { :passphrase_callback => method( :passfunc ) } )
      end
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
