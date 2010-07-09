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
    serialized = ""
    hash.each_pair do | name, key |
      serialized += name + ";" + key.to_s + "\n"
    end
    return serialized
  end
  
  def deserializeKeys string
    hash = {}
    string.split( "\n" ).each do | line |
      fields = line.split( ";" )
      hash[fields[0]] = LuksKey.new( fields[1] )
    end
    return hash
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