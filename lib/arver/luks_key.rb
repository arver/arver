module Arver
  class LuksKey
    attr_accessor :key
    
    def initialize(key)
      @key = key
    end
    
    def to_s
      @key
    end
    
    def ==(other_key)
      self.key == other_key.try(:key)
    end
    
  end
end