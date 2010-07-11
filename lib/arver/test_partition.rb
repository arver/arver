module Arver
  class TestPartition < Partition
  
    def initialize(name)
      super(name,Arver::Host.new('foo.host',Arver::Hostgroup.new('foo')))
    end
    
  end
end