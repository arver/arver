Feature: Createing luks

  Scenario: create a bunch of Disks
    Given there are no permissions set for "test"
    When I run arver in test mode with arguments "--force --create machine1/virt1_rootfs,machine2"
    Then I should see "creating: /location2/machine2/virt1_rootfs"
    And I should see "creating: /location2/machine2/virt2_rootfs"
    And I should see "creating: /location2/machine1/virt1_rootfs"
    And there should be 1 keyfiles for user "test"

  Scenario: create an disk but key exists
    Given there is a key for all test Partitions
    When I run arver in test mode with arguments "--create machine1/virt1_rootfs"
    Then I should see "DANGEROUS: you do have already a key for partition"
    And I should not see "creating: "

  Scenario: failing creation
    Given there are no permissions set for "test"
    And there will be a failure
    When I run arver in test mode with arguments "--force --create machine1/virt1_rootfs"
    Then I should see "Could not create Partition"

  Scenario: existing luksDevice
   Given there are no permissions set for "test"
   And external commands will return "LUKS header information for"
   When I run arver in test mode with arguments "--force --create machine1/virt1_rootfs"
   Then I should see "is already formatted with LUKS - returning"
   And I should not see "generating a new key for partition"
  
  Scenario: overwriting existing luksDevice
   Given there are no permissions set for "test"
   And external commands will return "LUKS header information for"
   When I run arver in test mode with arguments "--force --violence --create machine1/virt1_rootfs"
   Then I should see "is already formatted with LUKS - returning"
   And I should see "you applied --violence, so we will"
   And I should see "generating a new key for partition"
