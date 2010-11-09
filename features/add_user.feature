Feature: Adding a User

  Scenario: adding two disks in one keyfile
    Given there is a key for all test Partitions
    And there are no permissions set for "test2"
    When I run arver in test mode with arguments "-t /location2/machine1 --add-user test2"
    Then file "../spec/data/keys/test2/key_000002" is not created
    And file "../spec/data/keys/test2/key_000001" is created
    And I should see "adduser was called with target(s) machine1 and user test2"
  
  Scenario: trying to add a wrong user
    When I run arver in test mode with arguments "-t /location2 --add-user asf"
    Then I should see "no such user"
    And I should not see "adduser was called with target"
