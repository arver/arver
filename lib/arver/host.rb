module Arver
  class Host
    
    attr_accessor :postscript, :port, :username
    attr_writer :address
    
    include Arver::PartitionHierarchyNode
    include Arver::NodeWithScriptHooks
      
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
    
    def address
      return @address unless @address.nil?
      self.name
    end

    def port
      return @port unless @port.nil?
      '22'
    end

    def username
      return @username unless @username.nil?
      'root'
    end
    
    def to_yaml
      yaml = ""
      yaml += "'address': '"+address+"'\n" unless @address.nil?
      yaml += "'port': '"+port+"'\n" unless @port.nil?
      yaml += "'username': '"+username+"'\n" unless @username.nil?
      yaml += script_hooks_to_yaml
      yaml += super
    end
    
    def from_hash( hash )
      script_hooks_from_hash( hash )
      hash.each do | name, data |
        if( name == "port" )
          self.port = data
          next
        end
        if( name == "address" )
          self.address = data
          next
        end
        if( name == "username" )
          self.username= data
          next
        end
        #no matching keyword -> its a partition:
        p = Arver::Partition.new( name, self )
        p.from_hash( data )
      end
    end
    
    def execute( action )
      action.pre_host( self )
      super
      action.post_host( self )
    end
  end
end
