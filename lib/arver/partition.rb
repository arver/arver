class Arver::Partition

  include Arver::PartitionHierarchyNode

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
    "'#{self.device}'"
  end

  def from_hash(string)
    self.device = string 
  end

  def pre_execute(action)
    action.pre_run_execute_partition(self)
  end

  def execute(action)
    action.pre_partition(self)
    action.execute_partition(self)
    action.post_partition(self)
  end

  def device_path
    return self.device 
  end
end
