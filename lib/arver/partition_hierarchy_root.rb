module Arver
  module PartitionHierarchyRoot
    
    include PartitionHierarchyNode
    
    def path
        self.name
    end
      
  end
end