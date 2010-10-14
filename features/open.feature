Feature: Opening luks

  Scenario: Open a Disk verbose
    When I run executable "../bin/arver" with arguments "-u test -c ../spec/data -t machine1/virt1_rootfs --dry-run --open"
    Then I should see "opening: /location2/machine1/virt1_rootfs"
