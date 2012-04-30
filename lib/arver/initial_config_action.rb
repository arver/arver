module Arver
  class InitialConfigAction < Action
    def post_action
      if LocalConfig.instance.username.empty?
        Log.warn( "Please choose a username using '-u'" )
        return
      end
      local_config = LocalConfig.instance.path
      if File.exist?( local_config )
        Log.warn( "#{local_config} already exists" )
      else
        content = { 'username' => LocalConfig.instance.username }
        f = File.new(local_config, "w")
        f.write(content.to_yaml)
        f.close
      end

      config_path = LocalConfig.instance.config_dir

      if File.exist?( config_path )
        Log.warn( "#{config_path} already exists" )
      else
        Config.instance.users = {
          LocalConfig.instance.username => {
            'slot' => "<the next free luks slot>",
            'gpg'  => "<gpg fingerprint of #{LocalConfig.instance.username}>"
          }
        }
        Config.instance.tree = {
          'default' => {
            'sample_machine' => {
              'address'    => 'foo.bar.com',
              'post_open'  => 'script-after-opening-the-disks.sh',
              'a_disk' => {
                'device' => '/dev/sda'
              }
            }
          }
        }
        Config.instance.save
      end
    end
  end
end
