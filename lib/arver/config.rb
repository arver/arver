module Arver
  class Config
    
    include Singleton
    
    def initialize
      @config = {}
    end
    
    def load
      @config = YAML.load(File.read(".arver/config")) if File.exists?( ".arver/config" )
    end
    
    def save
      FileUtils.mkdir_p ".arver" unless File.exists?( ".arver" )
      File.open( ".arver/config", 'w' ) { |f| f.write( @config.to_yaml ) }
    end
  
    def tree
      @config[:luks_partitions_tree] ||= Arver::Tree.new
    end
      
    def tree= partitions
      @config[:luks_partitions_tree] = partitions
    end
      
  end
end