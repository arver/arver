require 'optparse'

module Arver
  class CLI
    def self.execute(stdout, arguments=[])

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
                "Show this help message.") { stdout.puts opts; return }
        opts.on("--dry-run",
                "Test your command.") { options[:dry_run] = true }
        opts.on("--ask-password",
                "Ask for Password when --add-user.") { options[:ask_password] = true }
        opts.on("--force",
                "Apply force (allow duplicate keys)") { options[:force] = true }
        opts.on("--violence",
                "Apply violence (allow destruction of disk)") { options[:violence] = true }
        opts.on("--test-mode",
                "Test mode") { options[:test_mode] = true }
        opts.on_tail( "-l", "--list-targets",
                "List targets." ) { options[:action] = :list; }
        opts.on_tail( "-g", "--garbage-collect",
                "Expunge old keys." ) { options[:action] = :gc; }
        opts.on_tail( "-t", "--target TARGETLIST", String,
                "Select Target. Allowed Targets are commaseparated lists of:",
                "'Group', 'Host', 'Device', 'Host/Device', 'Group/Host/Device' or 'ALL'.") { |arg| options[:argument][:target] = arg; }
        opts.separator "Actions:"
        opts.on_tail( "--create",
                "Create new arver partition on Target." ) { options[:action] = :create; }
        opts.on_tail( "-o", "--open",
                "Open target." ) { options[:action] = :open; }
        opts.on_tail( "-c", "--close",
                "Close target." ) { options[:action] = :close; }
        opts.on_tail( "-a", "--add-user USER", String,
                "Add a user to target.") { |user| options[:action] = :adduser; options[:argument][:user] = user;  }
        opts.on_tail( "-d", "--del-user USER", String,
                "Remove a user from target.") { |user| options[:action] = :deluser; options[:argument][:user] = user;  }
        opts.on_tail( "-i", "--info", String,
                "Info about a target.") { |user| options[:action] = :info; }
        opts.parse!(arguments)
                
        if options[:action].nil? || 
           ( options[:action] != :list && options[:action] != :gc && ! options[:argument][:target] ) ||
           ( ( options[:action] == :adduser || options[:action] == :deluser ) && ! options[:argument][:target] )
          stdout.puts opts; return
        end
      end
      
      Arver::ScriptLogic.bootstrap( options )
     
      #TODO: here we should implement a choosing object pattern, which each action represented by an appropriate object
      # this object can then be passed along the tree as visitor by script_logic
       
      case options[:action]
        when :list
          Arver::ScriptLogic.list( options[:argument] )
        when :gc
          Arver::ScriptLogic.gc( options[:argument] )
        when :create
          Arver::ScriptLogic.create( options[:argument] )
        when :open
          Arver::ScriptLogic.open( options[:argument] )
        when :close
          Arver::ScriptLogic.close( options[:argument] )
        when :adduser
          Arver::ScriptLogic.adduser( options[:argument] )
        when :deluser
          Arver::ScriptLogic.deluser( options[:argument] )
        when :info
          Arver::ScriptLogic.info( options[:argument] )
      end
      
    end
  end
end
