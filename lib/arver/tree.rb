module Arver
  class Tree

    include PartitionHierarchyRoot
    
    def initialize
      self.name= ""
    end
    
    def add_host_group(host_group)
      add_child(host_group)
    end
  end
end