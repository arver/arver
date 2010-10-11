Feature: Opening luks

  Scenario: Open a Disk verbose
    When I run executable "../bin/arver" with arguments "-u test -c /home/x/productive/eharddisks/data -t machine1/virt1_rootfs --open"
    Then I should see "/Passphrase for 89540A072/"
    And I should see "(test Mode)\nOpening virt1_rootfs on machine1\nAll done."
