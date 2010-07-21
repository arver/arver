module Arver
  class Config
    
    attr_accessor :tree, :users
    
    include Singleton
    
    def initialize
      @tree = Arver::Tree.new
      @users = {}
    end
    
    def load
      users= load_file( ".arver/users" )
      tree.clear
      tree.from_hash( load_file( ".arver/disks" ) )
    end
    
    def load_file( filename )
      YAML.load( File.read(filename) ) if File.exists?( filename )
    end
    
    def save
      FileUtils.mkdir_p ".arver" unless File.exists?( ".arver" )
      File.open( ".arver/users", 'w' ) { |f| f.write( users.to_yaml ) }
      File.open( ".arver/disks", 'w' ) { |f| f.write( tree.to_yaml ) }
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