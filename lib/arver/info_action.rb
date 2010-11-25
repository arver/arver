module Arver
  class InfoAction < Action
    def initialize( target_list )
      super( target_list )
      self.open_keystore
    end

    def pre_host( host )
      Arver::Log.info( "-- "+host.name+":" );
    end

    def execute_partition( partition )
      caller = Arver::LuksWrapper.dump( partition )
      caller.execute
      result = caller.output
      a= {}
      bla = result.each{|s| 
                a1=s.split(':').compact; 
                v = '';
                v = a1[1].strip if not a1[1].nil?;
                v = v + ':' + a1[2].strip if not a1[2].nil?;
                a[a1[0].strip] = v if not a1[0].nil? }
      filling = 40-partition.device.length
      filling = 0 if filling < 0
      Arver::Log.info( "#{partition.device}#{' '*filling}: Slots: #{[0,1,2,3,4,5,6,7].map{|i| a['Key Slot '+i.to_s] == 'ENABLED' ? 'X' : '_'}.join}; LUKSv#{a['Version']}; Cypher: #{a['Cipher name']}:#{a['Cipher mode']}:#{a['Hash spec']}; UUID=#{a['UUID']}" )
      true
    end
  end
end
