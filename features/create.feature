Feature: Createing luks

  Scenario: create a bunch of Disks
    When I run executable "../bin/arver" with arguments "-u test -c ../spec/data --test-mode --force -t machine1/virt1_rootfs,machine2 --create"
    Then I should see "creating: /location2/machine2/virt1_rootfs"
    And I should see "creating: /location2/machine2/virt2_rootfs"
    And I should see "creating: /location2/machine1/virt1_rootfs"

