class TestPartitionHierarchy < Test::Unit::TestCase

  include TestHierarchyLoader
  
  def setup
    load_test_hierarchy
  end
  
  def test_naming
    assert_equal(@d.name,"/testG/testH/testP1" )
  end
  
  def test_iterating
    test_disks = [ @d, @d2, @d3, @d4 ]
    
    Arver::Config.instance.tree.each_partition do | partition |
      test_disks.delete(partition)
    end
    assert_equal(test_disks.size,0)
  end
  
end
