class TestKeystore < Test::Unit::TestCase
  
  def setup
    @luks_key = Arver::LuksKey.new "test"
    @keystore = Arver::Keystore.instance
    @partition = Arver::TestPartition.new("some/test")
  end
  
  def test_adding
    @keystore.add_luks_key @partition, @luks_key 
    assert_equal(@luks_key, @keystore.luks_key(@partition))
  end
  
  def test_marshalling
    if @keystore.luks_key(@partition) == nil
      @keystore.add_luks_key(@partition, @luks_key)
    end
    @keystore.save_to_disk
    @keystore.flush_keys
    @keystore.read_from_disk
    assert_equal(@luks_key,@keystore.luks_key(@partition))
  end
  
end
