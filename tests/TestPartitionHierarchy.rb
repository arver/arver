class TestPartitionHierarchy < Test::Unit::TestCase

  include TestHierarchyLoader
  
  def setup
    loadTesthierarchy
  end
  
  def testNaming
    puts @d.name
    assert( @d.name ==  "/testG/testH/testP1" )
  end
  
  def testIterating
    testDisks = [ @d, @d2, @d3, @d4 ]
    Config.instance.arverTree.eachPartition do | partition |
      puts "-"+partition.name
      testDisks -= [ partition ]
    end
    assert( testDisks.size == 0 )
  end
  
end