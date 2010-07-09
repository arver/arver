class Keystore
    
  include Singleton
  
  def initialize
    @keys = {}
  end
  
  def readFromDisk
    serialized = KeySaver.read
    @keys = deserializeKeys( serialized )
  end
  
  def saveToDisk
    serialized = self.serializeKeys( @keys )
    KeySaver.save( serialized )
  end
  
  def serializeKeys hash
    return hash.to_yaml
  end
  
  def deserializeKeys string
    return YAML.load( string )
  end
  
  def flushKeys
    @keys = {}
  end

  def getLuksKey( anArverPartition )
    return @keys[ anArverPartition.name() ]
  end
  
  def addLuksKey( anArverPartition, aLuksKey )
    @keys[ anArverPartition.name() ] = aLuksKey
  end
  
end