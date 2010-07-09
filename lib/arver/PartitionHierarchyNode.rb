module PartitionHierarchyNode
      
  attr_writer :name
  attr_accessor :parent
  attr_accessor :children
  
  def name
    return parent().name() +"/"+ @name
  end
  
  def addToParent
    parent.addChild self
  end
  
  def lazyInit
    @children = {} if @children.nil?
  end
  
  def addChild child
    self.lazyInit
    @children[ child.name ] = child
  end
  
  def getChild name
    self.lazyInit
    return @children[ name ]
  end
  
  def eachPartition &blk
    self.lazyInit
    @children.each_value do | child |
      child.eachPartition( &blk )
    end
  end
  
  
end