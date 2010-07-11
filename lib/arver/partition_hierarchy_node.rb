module Arver
  module PartitionHierarchyNode
        
    attr_writer :name
    attr_reader :parent
    
    def initialize(a_name, parent_node)
      @name = a_name
      self.parent = parent_node
    end
    
    def name
      parent.name<<"/"<<@name
    end
    
    def parent=(parent_node)
      @parent = parent_node
      parent_node.add_child(self)
    end
    
    def children
      @children ||= {}
    end
    
    def add_child(child)
      children[child.name] = child
    end
    
    def child(name)
      children[name]
    end
    
    def each_partition(&blk)
      children.each_value do | child |
        child.each_partition(&blk)
      end
    end
    
    # TODO: what's that for?
    def partition_list
      list = []
      each_partition do | partition |
        list += [ partition ]
      end
      list
    end
      
  end
end