module Arver
  class InfoAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end

    def pre_host( host )
      Arver::Log.info( "\n-- "+host.path+":" )
      true
    end

    def execute_partition( partition )
      caller = Arver::LuksWrapper.dump( partition )
      caller.execute
      result = caller.output
      a= {}
      result.each do |s|
                a1=s.split(':').compact
                v = ''
                v = a1[1].strip if a1[1]
                v = v + ':' + a1[2].strip if a1[2]
                a[a1[0].strip] = v if a1[0]
      end
      filling = 40-partition.device.length
      filling = 0 if filling < 0
      Arver::Log.info( "  #{partition.device}#{' '*filling}: Slots: #{(0..7).map{|i| a['Key Slot '+i.to_s] == 'ENABLED' ? 'X' : '_'}.join}; LUKSv#{a['Version']}; Cypher: #{a['Cipher name']}:#{a['Cipher mode']}:#{a['Hash spec']}; UUID=#{a['UUID']}" )
      true
    end
  end
end
