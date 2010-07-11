class TestKeySaver < Test::Unit::TestCase
  def test_key_saver
    s = "test\ntest"
    Arver::KeySaver.save( s )
    assert( Arver::KeySaver.read == s )
  end
end