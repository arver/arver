module Arver
  class InfoAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end

    def pre_host( host )
      Arver::Log.info( "\n-- "+host.path+":" )
    end

    def execute_partition(partition)
      info = {}
      (caller = Arver::LuksWrapper.dump(partition)).execute
      caller.output.each_line do |line|
        next unless line =~ /^[A-Z].*: .*$/
        info.store(*line.split(':',2).collect{|f| f.strip })
      end
      Arver::Log.info("  #{sprintf("%0-20s",partition.name.first(20))}:  #{sprintf("%0-40s",partition.device_path.first(40))}: Slots: #{(0..7).map{|i| info["Key Slot #{i}"] == 'ENABLED' ? 'X' : '_'}.join}; LUKSv#{info['Version']}; Cypher: #{info['Cipher name']}:#{info['Cipher mode']}:#{info['Hash spec']}; UUID=#{info['UUID']}")
    end
  end
end
