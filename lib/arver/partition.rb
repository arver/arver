class Arver::Partition

  include Arver::PartitionHierarchyNode
  include Arver::NodeWithScriptHooks

  attr_accessor :device

  def initialize(name, host)
    self.name = name
    self.device = ''
    self.parent = host
  end

  def each_partition(&blk)
    yield self
  end

  def ==(other_partition)
    return name == other_partition.name && device == other_partition.device if other_partition.is_a?(Arver::Partition)
    false
  end

  def to_yaml
    yaml = ""
    yaml += "'device': '#{device}'\n"
    yaml += script_hooks_to_yaml
    yaml.chop
  end

  def from_hash( hash )
    script_hooks_from_hash( hash )
    hash.each do | name, data |
      self.device= data if name == "device"
    end
  end

  def pre_execute( action )
    return action.pre_run_execute_partition(self)
  end

  def run_action( action )
    if( action.verify?( self ) )
      action.pre_partition(self)
      action.execute_partition(self)
      action.post_partition(self)
    end
  end

  def device_path
    return self.device if self.device =~ /^\/dev\//
    "/dev/#{self.device}"
  end
end
