class ArverHost
  
  include PartitionHierarchyNode
    
  def initialize( aName, aArverHostgroup )
    self.name= aName
    self.parent= aArverHostgroup
    addToParent
  end
  
  def addPartition( aArverPartition )
    addChild aArverPartition
  end
  
  def getPartition( arverPartitionName )
    return getChild( arverPartitionName )
  end
  
end