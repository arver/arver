class TestConfig < Test::Unit::TestCase
  
  include TestHierarchyLoader

  def test_saving
    load_test_hierarchy
    old_tree = Arver::Config.instance.tree
    Arver::Config.instance.save
    Arver::Config.instance.load
    assert_equal(Arver::Config.instance.tree.partition_list,old_tree.partition_list)
  end
  
end