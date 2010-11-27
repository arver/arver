module Arver
  class GCAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end
    
    def post_action
      keystore.save
      true
    end
  end
end
