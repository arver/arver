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
  
end