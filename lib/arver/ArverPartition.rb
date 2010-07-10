class ArverPartition
  
  include PartitionHierarchyNode
   
  def initialize( aName, aArverHost )
    self.name= aName
    self.parent= aArverHost
    addToParent
  end

  def eachPartition &blk
    yield self
  end
  
  def to_s
    name
  end
  
  def == otherPartition
    if ! otherPartition.is_a? ArverPartition
      puts "jj"
      return false
    end
    puts name+" == "+otherPartition.name
    return name == otherPartition.name
  end
  
end