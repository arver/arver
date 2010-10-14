Feature: Createing luks

  Scenario: create a Disk verbose

    When I run executable "../bin/arver" with arguments "-u test -c ../spec/data --dry-run -t machine1/virt1_rootfs --create"
    Then I should see "creating: /location2/machine1/virt1_rootfs"

