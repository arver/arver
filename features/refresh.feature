Feature: Refreshing a key

  Scenario: refreshing a key
    Given there is a key for all test Partitions
    When I run arver in test mode with arguments "--refresh /location2/machine1" 
    Then there should be 1 keyfiles for user "test"
    And I should see "refresh was called with target(s) machine1"

