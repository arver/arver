Feature: Open luks

  Scenario: open a list of targets
    Given there is a key for all test Partitions
    And all disks seem closed
    When I run arver in test mode with arguments "--open location2,virtmachine1"
    Then I should see "opening: /location1/machine1_1.example.tld/virtmachine1"
    And I should see "opening: /location2/machine2/virt1_rootfs"
    And I should see "opening: /location2/machine2/virt2_rootfs"
    And I should see "opening: /location2/machine1/virt2_srv"
    And I should see "opening: /location2/machine1/virt1_rootfs"

  Scenario: old keys can be used
    Given there is an unpadded keyfile
    And all disks seem closed
    When I run arver in test mode with arguments "-o virtmachine1"
    Then I should see "Warning: you are using deprecated unpadded keyfiles. Please run garbage collect!"
    And I should see "opening: /location1/machine1_1.example.tld/virtmachine1"

  Scenario: open disks get skipepd 
    Given there is a key for all test Partitions
    And all disks seem open
    When I run arver in test mode with arguments "-o location2,virtmachine1"
    Then I should see "virtmachine1 already open. skipping."
    And I should see "virt1_rootfs already open. skipping."
