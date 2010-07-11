module Arver
  class Hostgroup
    
    include PartitionHierarchyNode
      
    def initialize(name)
      super(name, Arver::Config.instance.tree)
    end
    
    def add_host(host)
      add_child(host)
    end
    
    def get_host(host_name)
      get_child(host_name)
    end
    
  end
end