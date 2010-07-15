module Arver
  module PartitionHierarchyNode
        
    attr_writer :name
    attr_reader :parent
    
    def initialize(a_name, parent_node)
      @name = a_name
      self.parent = parent_node
    end
    
    def name
      @name
    end
    
    def path
      parent.path<<"/"<<@name
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
        
    def == other_node
      equals = true
      children.each do | name, child |
        equals &= child == other_node.child( name )
      end
      equals
    end
    
    def to_yaml
      yaml = ""
      children.each do | name, child |
        yaml += "'"+name+"':\n"
        yaml += ( child.to_yaml.indent( " ", 2 ) ) +"\n"
      end
      yaml.chop
    end
  end
end