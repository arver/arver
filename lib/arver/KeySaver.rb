class KeySaver
  def self.save keyString
    file = File.new( "/tmp/key", 'w' )
    file.write keyString
    file.close
  end
  def self.read
    file = File.new( "/tmp/key", 'r' )
    keyString = file.read()
    file.close
    return keyString
  end
end