module Arver
  class InfoAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
      Arver::Log.info("Warning: existence of a keyslot is not a guarantee that the user can access it")
    end

    def pre_host( host )
      Arver::Log.info( "\n-- "+host.path+":" )
    end

    def execute_partition(partition)
      cmd = Arver::LuksWrapper.dump(partition)
      cmd.execute
      info = cmd.output
      info =~ /Version:[\s]+(\d)/
      version = $1
      slots = []

      head = " #{sprintf("%0-10s",partition.name.first(10))} :"+
             " #{sprintf("%0-30s",partition.device_path.first(30))}"

      if version != '1' && version != '2'
        Arver::Log.info("#{head} : Unsupported luks version")
        return
      end

      if version == '1'
        info.each_line do |line|
          if line =~ /Key Slot (\d): ENABLED/
            slots << Integer($1)
          end
        end
      else
        keyslots = []
        start = false
        info.each_line do |line|
          if line =~ /Keyslots:/
            start = true
            next
          end
          next unless start
          break unless line =~ /^\s/
          if line =~ /[\s]+(\d): luks2/
            slots << Integer($1)
          end
        end
      end
      slots = slots.map{|s| "#{Config.instance.user_at(s)}(#{s})"}.join(",")
      Arver::Log.info("#{head} : #{slots}")
    end
  end
end
