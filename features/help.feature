Feature: Arver help

  Scenario: show usage 
    When I run arver in test mode with arguments "-h"
    Then I should see "Usage: "

