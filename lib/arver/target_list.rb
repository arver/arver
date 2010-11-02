module Arver
  class TargetList
    def self.get_list( names )
      
      return "ALL" if names.eql? "ALL"
      
      tree = Arver::Config.instance.tree

      targets = []

      names.split( "," ).each do |target_name|
        target = tree.find( target_name )
        if( target.size == 0 )
          Arver::Log.error( "No such target" )
          return []
        end
        if( target.size > 1 )
          Arver::Log.error( "Target not unique. Found:" )
          target.each do |t|
            Arver::Log.error( t.path )
          end
          return []
        end
        targets += [ target[0] ]
      end

      targets
    end
  end
end
  