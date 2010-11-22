module Arver
  class LuksWrapper
    def self.addKey( key_slot, partition )
      Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "--key-slot=#{key_slot}", "luksAddKey", partition.device_path ], partition.parent )
    end
    def self.close( partition )
      Arver::SSHCommandWrapper.new( "cryptsetup", [ "luksClose", "#{partition.name}"], partition.parent )
    end
    def self.dump( partition )
      Arver::SSHCommandWrapper.new( "cryptsetup", [ "luksDump", partition.device_path ], partition.parent )
    end
    def self.create( key_slot, partition )
      Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "--key-slot=#{key_slot}", "--cipher=aes-cbc-essiv:sha256", "--key-size=256", "luksFormat", partition.device_path ], partition.parent )
    end
    def self.killSlot( key_slot, partition )
      Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "luksKillSlot", partition.device_path, key_slot ], partition.parent )
    end
    def self.open( partition )
      Arver::SSHCommandWrapper.new( "cryptsetup", [ "--batch-mode", "luksOpen", partition.device_path, partition.name ], partition.parent )
    end
  end
end
