Feature: Garbage collection

  Scenario: doing garbage collect
    Given there are two keyfiles
    When I run arver in test mode with arguments "-g"
    Then file "../spec/data/keys/test/key_000002" is not created
  
