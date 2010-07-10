class Config
  
  include Singleton
  
  def initialize
    @theConfig = {}
  end
  
  def load
    if( File.exists?( ".arver/config" ) )
      file = File.new( ".arver/config", 'r' )
      serialized = file.read
      file.close
      @theConfig = YAML.load( serialized )
    end
  end
  
  def save
    if( ! File.exists?( ".arver" ) )
      FileUtils.mkdir_p ".arver"
    end
    file = File.new( ".arver/config", 'w' )
    file.write( @theConfig.to_yaml )
    file.close
  end

  def arverTree
    if( @theConfig[:luksPartitionTree].nil? )
      @theConfig.store( :luksPartitionTree, ArverTree.new )
      
    end
    return @theConfig[:luksPartitionTree]
  end
    
  def arverTree= allPartitionsInstance
    @theConfig[:luksPatitionsTre] = allPartitionsInstance
  end
    
end