Feature: Script Hooks

  Scenario: execute hooks on open
    Given there is a key for all test Partitions
    And all disks seem closed
    When I run arver in test mode with arguments "-t virtmachine1 --open"
    Then I should see "Running script: pre_open_host_script.sh on machine1_1.example.tld"
    And I should see "Running script: pre_open_disk_script.sh on machine1_1.example.tld"
    And I should see "Running script: post_open_host_script.sh on machine1_1.example.tld"
    And I should see "Running script: post_open_disk_script.sh on machine1_1.example.tld"
  
  Scenario: stop on failure
    Given there is a key for all test Partitions
    And all disks seem closed
    And there will be a failure
    When I run arver in test mode with arguments "-t virtmachine1 --open"
    Then I should see "Running script: pre_open_host_script.sh on machine1_1.example.tld"
    And I should not see "Running script: pre_open_disk_script.sh on machine1_1.example.tld"

  Scenario: execute hooks on close
    Given there is a key for all test Partitions
    And all disks seem open
    When I run arver in test mode with arguments "-t virtmachine1 --close"
    Then I should see "Running script: pre_close_host_script.sh on machine1_1.example.tld"
    And I should see "Running script: pre_close_disk_script.sh on machine1_1.example.tld"
    And I should see "Running script: post_close_host_script.sh on machine1_1.example.tld"
    And I should see "Running script: post_close_disk_script.sh on machine1_1.example.tld"
