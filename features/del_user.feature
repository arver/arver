Feature: Deleting a User

  Scenario: on a target without permission
    Given there are no permissions set for "test"
    When I run arver in test mode with arguments "-d test -t machine2"
    Then I should see "No permission on /location2/machine2/virt1_rootfs"
    And I should see "No permission on /location2/machine2/virt2_rootfs"
  
  Scenario: default deluser
    Given there is a key for all test Partitions
    When I run arver in test mode with arguments "-d test -t machine2"
    Then I should see "remove user user test (slot-no 7) from /location2/machine2/virt2_rootfs"
    And I should not see "No permission on this target"

  Scenario: not working
    Given there is a key for all test Partitions
    And there will be a failure
    When I run arver in test mode with arguments "-d test -t machine2"
    Then I should see "remove user user test (slot-no 7) from /location2/machine2/virt2_rootfs"
    And I should not see "No permission on this target"
    And I should see "Could not remove user:"
