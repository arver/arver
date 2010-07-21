module Arver
  class KeySaver
    def self.save( user, key )
      conf = Arver::Config.instance
      gpg_key = conf.gpg_key( user )
      GPGME::list_keys()
      key_encrypted = GPGME::encrypt( gpg_key, key )
      FileUtils.mkdir_p ".arver/keys" unless File.exists?( ".arver/keys" )
      FileUtils.mkdir_p ".arver/keys/"+user unless File.exists?( ".arver/keys/"+user )

      File.open( keyPath( user ), 'w' ) do |f|
        f.write key_encrypted
      end
    end
    
    def self.keyPath( user )
      ".arver/keys/"+user+"/key"
    end
    
    def self.read( user )
      return if( ! File.exists?( keyPath( user ) ) )
      key_encrypted = File.read( keyPath( user ) )
      GPGME::decrypt( key_encrypted, { :passphrase_callback => method( :passfunc ) } )
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
