Feature: Disk info

  Scenario: show usage 
    When I run arver in test mode with arguments "-i ALL"
    Then I should see "Unsupported luks version"

