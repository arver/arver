module Arver
  class Host
    
    attr_accessor :postscript, :port
    
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
    
    def to_yaml
      yaml = ""
      yaml += "'postscript': '"+postscript+"'\n" unless postscript.nil?
      yaml += "'port': '"+port+"'\n" unless port.nil?
      children.each do | name, child |
        yaml += "'"+name+"': "+child.to_yaml+"\n"
      end
      yaml.chop
    end
    
    def from_hash hash
      hash.each do | name, data |
        if( name == "postscript" )
          self.postscript = data
          next
        end
        if( name == "port" )
          self.port = data
          next
        end
        p = Arver::Partition.new( name, self )
        p.from_hash( data )
      end
    end
  end
end