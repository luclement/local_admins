Active Directory Local Admins

This PowerShell script will search you Windows Active Directory domain given a list of computers on the domain (with the domain name prefix) in a line seperated file named 'computers.txt'.

This script will output 'localadmins.csv', giving the names of all local admin account on the machines that were able to be queried. All offline computers will be output in another file 'offline.txt'.
