module Arver
  class Hostgroup
    
    include PartitionHierarchyNode
      
    def initialize(name)
      super(name, Arver::Config.instance.tree)
    end
    
    def add_host(host)
      add_child(host)
    end
    
    def host(host_name)
      child(host_name)
    end
    
    def from_hash hash
      hash.each do | name, data |
        h = Arver::Host.new( name, self )
        h.from_hash( data )
      end
    end
  end
end