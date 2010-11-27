Feature: Close luks

  Scenario: close a list of targets
    Given there is a key for all test Partitions
    And all disks seem open
    When I run arver in test mode with arguments "--close -t machine2"
    Then I should see "closing: /location2/machine2/virt1_rootfs" 
    And I should see "closing: /location2/machine2/virt2_rootfs"

  Scenario: closed disks get skipepd 
    Given there is a key for all test Partitions
    And all disks seem closed
    When I run arver in test mode with arguments "-t location2,virtmachine1 --close"
    Then I should see "virtmachine1 not open. skipping."
    And I should see "virt1_rootfs not open. skipping."
