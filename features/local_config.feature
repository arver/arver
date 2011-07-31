Feature: Local user specific config
  In order to to be able to identify myself
  Arver should
  Read a local config which contains local configuration data
  
  Scenario: Opening an existing valid localconfiguration
    Given a valid local configuration file
    When I load the local_config
    Then the local_config value username should be foo
    And the local_config value config_dir should be bar

  Scenario: Opening an existing invalid local configuration
    Given a invalid local configuration file
    When I load the local_config
    Then the local_config value username should be 
    And the local_config value config_dir should be ~/.arverdata
    
  Scenario: Opening a non existing invalid local configuration
    Given a nonexisting local configuration file
    When I load the local_config
    Then the local_config value username should be 
    And the local_config value config_dir should be ~/.arverdata        
