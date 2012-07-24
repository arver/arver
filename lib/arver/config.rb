module Arver
  class Config
    
    attr_accessor :tree, :users
    
    include Singleton
    
    def initialize
      @tree = Arver::Tree.new
      @users = {}
    end
    
    def path
      File.expand_path( Arver::LocalConfig.instance.config_dir )
    end
    
    def load
      if( ! File.exists?( path ) )
        Arver::Log.error( "config-dir "+path+" does not exist" )
        exit
      end
      @users= ( load_file( File.join(path,'users') ) )
      tree.clear
      tree.from_hash( load_file( File.join(path,'disks') ) )
    end
    
    def load_file( filename )
      YAML.load( File.read(filename) ) if File.exists?( filename )
    end
    
    def save
      FileUtils.mkdir_p( path ) unless File.exists?( path )
      File.open( File.join(path,'users'), 'w' ) { |f| f.write( users.to_yaml ) }
      File.open( File.join(path,'disks'), 'w' ) { |f| f.write( tree.to_yaml ) }
    end
    
    def exists?( user )
      ! users[user].nil?
    end

    def gpg_key user
      users[user]['gpg'] if exists?(user)
    end

    def slot user
      users[user]['slot'] if exists?(user)
    end
    
    def == other
      return tree == other.tree && users == other.users if other.is_a?(Arver::Config)
      false
    end
  end
end
