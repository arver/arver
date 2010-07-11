module Arver
  class Host
    
    include PartitionHierarchyNode
      
    def initialize( name, hostgroup )
      self.name = name
      self.parent = hostgroup
    end
    
    def add_partition(partition)
      add_child(partition)
    end
    
    def partition(name)
      child(name)
    end
    
  end
end