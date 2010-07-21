Feature: Opening luks

  Scenario: Open a Disk verbose
    When I run executable "bin/arver" with arguments "-u test -c spec/data -d -v open immer1 xen12_srv"
    Then I should see "Passphrase for 89540A072"
    And I should see "(test Mode)\nOpening xen12_srv on immer1\nAll done."
      
  Scenario: Open a Disk
    When I run executable "bin/arver" with arguments "-u test -c spec/data -d -v open immer1 xen12_srv"
    Then I should see "Passphrase for 89540A072"
    And I should see "1" lines of output