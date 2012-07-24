module Arver
  class LuksWrapper
    def self.addKey( key_slot, partition )
      Arver::SSHCommandWrapper.create( "cryptsetup", [ "--batch-mode", "--key-slot=#{key_slot}", "luksAddKey", partition.device_path ], partition.parent, true )
    end
    def self.changeKey( key_slot, partition )
      Arver::SSHCommandWrapper.create( "cryptsetup", [ "--batch-mode", "--key-slot=#{key_slot}", "luksChangeKey", partition.device_path ], partition.parent, true )
    end
    def self.close( partition )
      Arver::SSHCommandWrapper.create( "cryptsetup", [ "luksClose", "#{partition.name}"], partition.parent, true )
    end
    def self.dump( partition )
      Arver::SSHCommandWrapper.create( "cryptsetup", [ "luksDump", partition.device_path ], partition.parent, true )
    end
    def self.create( key_slot, partition )
      Arver::SSHCommandWrapper.create( "cryptsetup", [ "--batch-mode", "--key-slot=#{key_slot}", "--cipher=aes-cbc-essiv:sha256", "--key-size=256", "luksFormat", partition.device_path ], partition.parent, true )
    end
    def self.killSlot( key_slot, partition )
      Arver::SSHCommandWrapper.create( "cryptsetup", [ "--batch-mode", "luksKillSlot", partition.device_path, key_slot ], partition.parent, true )
    end
    def self.open( partition )
      Arver::SSHCommandWrapper.create( "cryptsetup", [ "--batch-mode", "luksOpen", "-T 1", partition.device_path, partition.name ], partition.parent, true )
    end
    def self.open?( partition )
      Arver::SSHCommandWrapper.create( "test", [ "-b", "/dev/mapper/#{partition.name}" ], partition.parent, true )
    end
    def self.was_wrong_key?( command_wrapper )
      # before version 1.2 return value was 234
      command_wrapper.return_value == 234 || command_wrapper.return_value == 2
    end
  end
end
