Feature: Garbage collection

  Scenario: doing garbage collect
    Given there are two keyfiles
    When I run arver in test mode with arguments "-g"
    Then there should be 1 keyfiles for user "test" 
  
