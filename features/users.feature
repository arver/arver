Feature: Users

  Scenario: open a list of targets
    When I run arver in test mode with user "sdfgsdf" and arguments "-l"
    Then I should see "No such user sdfgsdf"
