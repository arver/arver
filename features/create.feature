Feature: Createing luks

  Scenario: create a bunch of Disks
    Given there is a key for all test Partitions
    When I run arver in test mode with arguments "--force -t machine1/virt1_rootfs,machine2 --create"
    Then I should see "creating: /location2/machine2/virt1_rootfs"
    And I should see "creating: /location2/machine2/virt2_rootfs"
    And I should see "creating: /location2/machine1/virt1_rootfs"

