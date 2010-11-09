Feature: Listing targets

  Scenario: list all targets
    Given there are no permissions set for "test"
    When I run arver in test mode with arguments "-l"
    Then I should see 10 lines of output

