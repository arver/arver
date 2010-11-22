module Arver
  class ListAction < Action
    def post_execution
      Arver::Log.write( Arver::Config.instance.tree.to_ascii )
    end
  end
end
