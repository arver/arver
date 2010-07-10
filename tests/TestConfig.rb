class TestConfig < Test::Unit::TestCase
  
  include TestHierarchyLoader

  def testSaving
    loadTesthierarchy
    oldTree = Config.instance.arverTree
    Config.instance.save
    Config.instance.load
    assert( Config.instance.arverTree.partitionList == oldTree.partitionList )
  end
  
end