Feature: Adding a User

  Scenario: adding two disks in one keyfile
    Given there are no permissions set
    When I run arver in test mode with arguments "-t /location2/machine1 --add-user test"
    Then file "../spec/data/keys/test/key_000002" is not created
    And I should see "adduser was called with target(s) machine1 and user slot-no 7"
  
  Scenario: trying to add a wrong user
    When I run arver in test mode with arguments "-t /location2 --add-user asf"
    Then I should see "no such user"
