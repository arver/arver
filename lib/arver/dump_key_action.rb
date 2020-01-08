module Arver
  class DumpKeyAction < Action
    def initialize(target_list)
      super(target_list)
      self.open_keystore
    end

    def verify?(partition)
      load_key(partition)
    end

    def execute_partition( partition )
      Arver::Log.info("key for #{partition.path}:")
      Arver::Log.info(key)
    end

    def pre_host( host )
    end

    def pre_partition( partition )
    end

    def post_partition( partition )
    end

    def post_host( host )
    end
  end
end
