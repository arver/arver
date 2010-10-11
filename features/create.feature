Feature: Createing luks

  Scenario: create a Disk verbose

    When I run executable (dry-run) "../bin/arver" with arguments "-u test -c /home/x/productive/eharddisks/data --dry-run -t machine1/virt1_rootfs --create"
      Then I get the command that will be executed (the passphrase is erased)

    When I run executable "../bin/arver" with arguments "-u test -c /home/x/productive/eharddisks/data -t machine1/virt1_rootfs --create"
    It there are already key files (1 or more) you get a passphrase promt of your GPG keystore, to verify, that there is not already a passphrase for the harddisk set.
    Then I should see "creating: /location2/machine1/virt1_rootfs."
    Then I should see "Command successful."

