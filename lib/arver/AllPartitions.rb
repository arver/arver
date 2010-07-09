class AllPartitions
  
  include Singleton
  include PartitionHierarchyRoot
  
  def initialize
    self.name= ""
  end
  
  def addArverHostgroup aHostGroup
    addChild aHostGroup
  end

  
end