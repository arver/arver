require 'optparse'

module Arver
  class CLI
    def self.execute(stdout, arguments=[])

      options = {
        :user     => '',
        :config_dir   => '.arver',
        :dry_run  => false,
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
                "Show this help message.") { stdout.puts opts; exit }
        opts.on("--dry-run",
                "Test your command.") { options[:dry_run] = true }
        opts.on_tail( "-t", "--target TARGET", String,
                "Select Target. Allowed Targets are:",
                "'Hostgroup', 'Host', 'Host/Device' or 'ALL'.") { |arg| options[:argument][:target] = arg; }
        opts.separator "Actions:"
        opts.on_tail( "-o", "--open",
                "Open target." ) { options[:action] = :open; }
        opts.on_tail( "-a", "--add-user USER", String,
                "Add a user to target.") { |user| options[:action] = :adduser; options[:argument][:user] = user;  }
        opts.on_tail( "-d", "--del-user USER", String,
                "Remove a user from target.") { |user| options[:action] = :deluser; options[:argument][:user] = user;  }
        opts.parse!(arguments)
                
        if ( options[:action].nil? || ! options[:argument][:target] ) ||
           ( ( options[:action] == :adduser || options[:action] == :deluser ) && ! options[:argument][:target] )
          stdout.puts opts; exit
        end
      end
      Arver::ScriptLogic.send( options[:action], options[:argument] )
    end
  end
end