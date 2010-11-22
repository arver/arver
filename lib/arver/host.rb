module Arver
  class Host
    
    attr_accessor :postscript, :port, :username
    attr_writer :address
    
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
      yaml += "'postscript': '"+postscript+"'\n" unless @postscript.nil?
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
        if( name == "address" )
          self.address = data
          next
        end
        if( name == "username" )
          self.username= data
          next
        end
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
