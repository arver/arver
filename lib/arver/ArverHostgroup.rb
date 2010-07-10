class ArverHostgroup
  
  include PartitionHierarchyNode
    
  def initialize aName
    super aName, Config.instance.arverTree
  end
  
  def addHost( aAverHost )
    addChild aArverHost
  end
  
  def getHost( arverHostName )
    return getChild( arverHostName )
  end
  
end