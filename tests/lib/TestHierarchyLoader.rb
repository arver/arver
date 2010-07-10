module TestHierarchyLoader

  def loadTesthierarchy
    @hg = ArverHostgroup.new "testG"
    @hg2 = ArverHostgroup.new "testG2"
    @h = ArverHost.new "testH", @hg
    @h2 = ArverHost.new "testH2", @hg2
    @h3 = ArverHost.new "testH3", @hg2
    @d = ArverPartition.new "testP1", @h
    @d2 = ArverPartition.new "testP2", @h2
    @d3 = ArverPartition.new "testP3", @h3
    @d4 = ArverPartition.new "testP4", @h3
  end

end