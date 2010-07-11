module Arver
  class Partition
  
    include PartitionHierarchyNode
     
    def initialize(name, host)
      self.name = name
      self.parent = host
    end
  
    def each_partition(&blk)
      yield self
    end
    
    def to_s
      name
    end
    
    def == other_partition
      return name == other_partition.name if other_partition.is_a?(Arver::Partition)
      false
    end
    
  end
end