Feature: Bootstrapping the run
  In order to to be able to work correctly
  Arver should
  Bootstrap its configuration
  
  Scenario: Bootstrap with local configuration
    Given a valid local configuration file
    And I don't supply any user as the one I use is correct
    When I boostrap arver
    Then the bootstrap process should be true

  Scenario: Bootstrap with no local configuration
    Given a nonexisting local configuration file
    When I boostrap arver
    Then the bootstrap process should be false
    
  Scenario: Bootstrap with no local configuration but a username
    Given a nonexisting local configuration file
    And I supply a username with a existing key
    When I boostrap arver
    Then the bootstrap process should be true

  Scenario: Bootstrap with no local configuration but a username without a key
    Given a nonexisting local configuration file
    And I supply a username with a nonexisting key
    When I boostrap arver
    Then the bootstrap process should be false