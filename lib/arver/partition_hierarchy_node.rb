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
    
    def each_node(&blk)
      yield self
      children.each_value do | child |
        child.each_node(&blk)
      end
    end
    
    def each_partition(&blk)
      children.each_value do | child |
        child.each_partition(&blk)
      end
    end
    
    def target?( list )
      list.any? do |target|
        self.has_child?( target ) || self.has_parent?( target )
      end
    end
    
    def has_child?( child )
      return true if self.equal?( child )
      children.each_value do | my_child |
        return true if my_child.has_child?( child )
      end
      false
    end
    
    def has_parent?( node )
      return true if self.equal?( node )
      return false if parent.nil?
      return self.parent.has_parent?( node )
    end
  
    def find( name )
      found = []
      self.each_node do | node |
        found += [ node ] if (node.name == name || node.path =~ /#{name}$/)
      end
      found
    end
    
    def to_ascii
      list = ""
      children.each do | name, child |
        list += "+- "+name+"\n"
        list += ( child.to_ascii.indent_once ) +"\n" unless child.to_ascii.empty?
      end
      list.chop
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
        yaml += ( child.to_yaml.indent_once ) +"\n"
      end
      yaml.chop
    end
    
    def run_action( action )
      self.children.each_value do | child |
        action.run_on( child )
      end
    end
  end
end
