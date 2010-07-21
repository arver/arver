module Arver
  class Partition

    attr_accessor :device
  
    include PartitionHierarchyNode

    def initialize(name, host)
      self.name = name
      self.device = ''
      self.parent = host
    end
    
    def each_partition(&blk)
      yield self
    end
    
    def == other_partition
      return name == other_partition.name if other_partition.is_a?(Arver::Partition)
      false
    end
    
    def to_yaml
      "'"+self.device+"'"
    end
    
    def from_hash string
      self.device= string 
    end
  end
end