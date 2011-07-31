Feature: Listing targets

  Scenario: list all targets
    Given there are no permissions set for "test"
    When I run arver in test mode with arguments "-l"
    Then I should see 10 lines of output

  Scenario: not unique target
    Given there are no permissions set for "test"
    When I run arver in test mode with arguments "-i machine1"
    Then I should see "Target not unique. Found:"
  
  Scenario: no target
    Given there are no permissions set for "test"
    When I run arver in test mode with arguments "-i alsdjkfhakl"
    Then I should see "No such target"
