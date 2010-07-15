module Arver
  class Tree

    include PartitionHierarchyRoot
    
    def initialize
      self.name= ""
    end
    
    def add_host_group(host_group)
      add_child(host_group)
    end
    
    def from_hash hash
      hash.each do | name, data |
        hg = Arver::Hostgroup.new( name )
        hg.from_hash( data )
      end
    end
    
    def clear
      @children = {}
    end
  end
end