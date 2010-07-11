module Arver
  class Config
    
    include Singleton
    
    def initialize
      @theConfig = {}
    end
    
    def load
      @theConfig = YAML.load(File.read(".arver/config")) if File.exists?( ".arver/config" )
    end
    
    def save
      FileUtils.mkdir_p ".arver" unless File.exists?( ".arver" )
      File.open( ".arver/config", 'w' ) { |f| f.write( @theConfig.to_yaml ) }
    end
  
    def tree
      @theConfig[:luks_partitions_tree] ||= Arver::Tree.new
    end
      
    def tree= partitions
      @theConfig[:luks_partitions_tree] = partitions
    end
      
  end
end