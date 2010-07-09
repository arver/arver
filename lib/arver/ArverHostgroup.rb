class ArverHostgroup
  
  include PartitionHierarchyNode
    
  def initialize( aName )
    self.name= aName
    self.parent= AllPartitions.instance
    addToParent
  end
  
  def addHost( aAverHost )
    addChild aArverHost
  end
  
  def getHost( arverHostName )
    return getChild( arverHostName )
  end
  
end