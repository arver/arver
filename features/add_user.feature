Feature: Adding a User

  Scenario: adding two disks in one keyfile
    Given there is a key for all test Partitions
    And there are no permissions set for "test2"
    When I run arver in test mode with arguments "--add-user test2 /location2/machine1" 
    Then file "../spec/data/keys/test2/key_000002" is not created
    And file "../spec/data/keys/test2/key_000001" is created
    And I should see "adduser was called with target(s) machine1 and user test2"
  
  Scenario: trying to add a wrong user
    When I run arver in test mode with arguments "--add-user asf /location2"
    Then I should see "no such user"
    And I should not see "adduser was called with target"
  
  Scenario: adduser fails
    Given there will be a failure
    When I run arver in test mode with arguments "--add-user test2 /location2"
    Then I should see "adduser was called with target(s)"
    And I should see "Could not add user to /location2"
