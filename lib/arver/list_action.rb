module Arver
  class ListAction < Action
    def post_action
      Arver::Log.write( Arver::Config.instance.tree.to_ascii )
    end
  end
end
