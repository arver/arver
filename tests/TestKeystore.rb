class TestKeystore < Test::Unit::TestCase
  
  def setup
    @luksKey = LuksKey.new "test"
    @keystore = Keystore.instance
    @partition = TestPartition.new "some/test"
  end
  
  def testAdding
    @keystore.addLuksKey @partition, @luksKey 
    assert( @luksKey = @keystore.getLuksKey( @partition ) )
  end
  
  def testMarshalling
    if @keystore.getLuksKey( @partition ) == nil
      @keystore.addLuksKey( @partition, @luksKey )
    end
    @keystore.saveToDisk
    @keystore.flushKeys
    @keystore.readFromDisk
    puts @keystore.getLuksKey( @partition )
    assert( @luksKey = @keystore.getLuksKey( @partition ) )
  end
  
end