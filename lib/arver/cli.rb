require 'optparse'

module Arver
  class CLI
    def self.execute(output,arguments=[])

      Arver::Log.logger= IOLogger.new( output )

      options = {
        :user     => '',
        :config_dir   => '',
        :dry_run  => false,
        :test_mode => false,
        :ask_password  => false,
        :force  => false,
        :violence  => false,
        :action => nil,
        :argument => {},
      }
      
      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          arver.

          Usage: #{File.basename($0)} [options] ACTION

          Options:
        BANNER
        opts.on("-c", "--config-dir PATH", String,
                "Path to config dir.",
                "Default: .arver") { |arg| options[:config_dir] = arg }
        opts.on("-u", "--user NAME", String,
                "Username." ) { |arg| options[:user] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { Arver::Log.write opts; return }
        opts.on("--dry-run",
                "Test your command.") { options[:dry_run] = true }
        opts.on("--ask-password",
                "Ask for Password when --add-user.") { options[:ask_password] = true }
        opts.on("-t", "--trust-all",
                "Use untrusted GPG Keys.") { options[:trust_all] = true }
        opts.on("--force",
                "Apply force (allow duplicate keys)") { options[:force] = true }
        opts.on("--violence",
                "Apply violence (allow destruction of disk)") { options[:violence] = true }
        opts.on("-v",
                "Verbose") { Arver::Log.level( Arver::LogLevels::Debug ) }
        opts.on("--vv",
                "Max Verbose") { Arver::Log.level( Arver::LogLevels::Trace ) }
        opts.on( "-l", "--list-targets",
                "List targets." ) { options[:action] = :list; }
        opts.on( "-g", "--garbage-collect",
                "Expunge old keys." ) { options[:action] = :gc; }
        opts.on( "-k TARGET", "--keys TARGET", String,
                "List local keys for this target.") { |arg| options[:argument][:target] = arg; options[:action] = :key_info; }
        opts.on("--test-mode",
                "Test mode (internal use)") { options[:test_mode] = true }
        opts.separator "Targets:"
        opts.on(
                "        Possible Paths are: 'Group', 'Host', 'Device', 'Host/Device',\n"+
                "        'Group/Host/Device' or 'ALL'.\n"+
                "        Multiple Parameters can be given as comma separated list.\n"+
                "        Ambigues Target parameters will not be executed." )
        opts.separator "Actions:"
        opts.on_tail( "--create TARGET", String,
                "Create new arver partition on Target." ) { |arg| options[:argument][:target] = arg; options[:action] = :create; }
        opts.on_tail( "-o TARGET", "--open TARGET", String,
                "Open target." ) { |arg| options[:argument][:target] = arg; options[:action] = :open; }
        opts.on_tail( "-c TARGET", "--close TARGET", String,
                "Close target." ) { |arg| options[:argument][:target] = arg; options[:action] = :close; }
        opts.on_tail( "-a USER TARGET", "--add-user USER TARGET", String,
                "Add a user to target.") { |user| options[:action] = :adduser; options[:argument][:user] = user;  }
        opts.on_tail( "-d USER TARGET", "--del-user USER TARGET", String,
                "Remove a user from target.") { |user| options[:action] = :deluser; options[:argument][:user] = user;  }
        opts.on_tail( "-i TARGET", "--info TARGET", String,
                "LUKS info about a target.") { |arg| options[:argument][:target] = arg; options[:action] = :info; }
        
        begin
          opts.parse!(arguments)
        rescue
          Arver::Log.write opts; return
        end
                
        if options[:action] == :deluser || options[:action] == :adduser
          options[:argument][:target] = arguments.last
        end
        
        if options[:action].nil? || 
           ( options[:action] != :list && options[:action] != :gc && ! options[:argument][:target] ) ||
           ( ( options[:action] == :adduser || options[:action] == :deluser ) && ! options[:argument][:target] )
          Arver::Log.write opts; return
        end
      end
      
      unless( Arver::Bootstrap.run( options ) )
        return
      end

      target_list = TargetList.get_list( options[:argument][:target] )
      if target_list.empty? && ( options[:action] != :list && options[:action] != :gc )
        Arver::Log.write( "No targets found" )
        return false
      end
 
      run_action( options[:action], target_list, options[:argument][:user] )
    end
    
    def self.run_action( action, target_list, target_user )
      actions = {
        :list => Arver::ListAction,
        :gc => Arver::GCAction,
        :create => Arver::CreateAction,
        :open => Arver::OpenAction,
        :close => Arver::CloseAction,
        :adduser => Arver::AdduserAction,
        :deluser => Arver::DeluserAction,
        :info => Arver::InfoAction,
        :key_info => Arver::KeyInfoAction,
      }

      action = (actions[ action ]).new( target_list )
            
      return false unless( action.on_user( target_user ) )
      
      catch ( :abort_action ) do
        action.pre_action
        action.run_on( Arver::Config.instance.tree )
        action.post_action
      end

    end
  end
end
