Feature: Adding a User

  Scenario: adding two disks in one keyfile
    Given there is a key for all test Partitions
    And there are no permissions set for "test2"
    When I run arver in test mode with arguments "--add-user test2 /location2/machine1" 
    Then there should be 1 keyfiles for user "test2"
    And I should see "adduser was called with target(s) machine1 and user test2"
  
  Scenario: adding a disk to my own keyfile does not generate a second key
    Given there is a key for all test Partitions
    When I run arver in test mode with arguments "--add-user test /location2/machine1" 
    Then there should be 1 keyfiles for user "test"
    And I should see "adduser was called with target(s) machine1 and user test"
  
  Scenario: closed disks are not skipped
    Given there is a key for all test Partitions
    And there are no permissions set for "test2"
    And all disks seem closed
    When I run arver in test mode with arguments "--add-user test2 /location2/machine1" 
    Then there should be 1 keyfiles for user "test2"
  
  Scenario: trying to add a wrong user
    When I run arver in test mode with arguments "--add-user asf /location2"
    Then I should see "No such user"
    And I should not see "adduser was called with target"
  
  Scenario: adduser fails
    Given there will be a failure
    When I run arver in test mode with arguments "--add-user test2 /location2"
    Then I should see "adduser was called with target(s)"
    And I should see "Could not add user to /location2"
