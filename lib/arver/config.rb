module Arver
  class Config
    
    attr_accessor :tree, :users
    
    include Singleton
    
    def initialize
      @tree = Arver::Tree.new
      @users = {}
    end
    
    def path
      return Arver::LocalConfig.instance.config_dir
    end
    
    def load
      if( ! File.exists?( path ) )
        puts "No such Config directory: "+path
        exit
      end
      @users= ( load_file( path+"/users" ) )
      tree.clear
      tree.from_hash( load_file( path+"/disks" ) )
    end
    
    def load_file( filename )
      YAML.load( File.read(filename) ) if File.exists?( filename )
    end
    
    def save
      FileUtils.mkdir_p( path ) unless File.exists?( path )
      File.open( path+"/users", 'w' ) { |f| f.write( users.to_yaml ) }
      File.open( path+"/disks", 'w' ) { |f| f.write( tree.to_yaml ) }
    end
  
    def gpg_key user
      users[user]['gpg']
    end
    
    def == other
      return tree == other.tree && users == other.users if other.is_a?(Arver::Config)
      false
    end
  end
end