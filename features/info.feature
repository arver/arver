Feature: Disk info

  Scenario: show usage 
    When I run arver in test mode with arguments "-i ALL"
    Then I should see "/dev/storage/virt1_rootfs_e             : Slots: ________; LUKSv; Cypher: ::; UUID="

