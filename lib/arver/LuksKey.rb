class LuksKey
  attr_accessor :key
  
  def initialize aKey
    @key= aKey
  end
  
  def to_s
    @key
  end
  
end