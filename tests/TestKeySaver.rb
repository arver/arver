class TestKeySaver < Test::Unit::TestCase
  def testKeySaver
    s = "test\ntest"
    KeySaver.save( s )
    assert( KeySaver.read == s )
  end
end