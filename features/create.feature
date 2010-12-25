Feature: Createing luks

  Scenario: create a bunch of Disks
    Given there are no permissions set for "test"
    When I run arver in test mode with arguments "--force -t machine1/virt1_rootfs,machine2 --create"
    Then I should see "creating: /location2/machine2/virt1_rootfs"
    And I should see "creating: /location2/machine2/virt2_rootfs"
    And I should see "creating: /location2/machine1/virt1_rootfs"
    And file "../spec/data/keys/test/key_000001" is created
    And file "../spec/data/keys/test/key_000002" is not created

  Scenario: create an disk but key exists
    Given there is a key for all test Partitions
    When I run arver in test mode with arguments "-t machine1/virt1_rootfs --create"
    Then I should see "DANGEROUS: you do have already a key for partition"
    And I should not see "creating: "

  Scenario: failing creation
    Given there are no permissions set for "test"
    And there will be a failure
    When I run arver in test mode with arguments "--force -t machine1/virt1_rootfs --create"
    Then I should see "Could not create Partition"

  Scenario: existing luksDevice
   Given there are no permissions set for "test"
   And external commands will return "LUKS header information for"
   When I run arver in test mode with arguments "--force -t machine1/virt1_rootfs --create"
   Then I should see "is already formatted with LUKS - returning"
   And I should not see "starting key generation"
  
  Scenario: overwriting existing luksDevice
   Given there are no permissions set for "test"
   And external commands will return "LUKS header information for"
   When I run arver in test mode with arguments "--force --violence -t machine1/virt1_rootfs --create"
   Then I should see "is already formatted with LUKS - returning"
   And I should see "you applied --violence, so we will"
   And I should see "starting key generation"
