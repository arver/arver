Feature: Close luks

  Scenario: open a list of targets
    Given there is a key for all test Partitions
    When I run arver in test mode with arguments "--close -t machine2"
    Then I should see "closing: /location2/machine2/virt1_rootfs" 
    And I should see "closing: /location2/machine2/virt2_rootfs"

