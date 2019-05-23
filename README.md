# opexport
Export items from 1Password on Linux
This script will allow you to export all of your passwords from
1Password into a csv format that you can import into another
password Manager. If you have more than one account you can uncomment
the four lines in the elif clause.
By default this will create a separate CSV for each of the vaults
in your 1Password account. The CSV will have colums for the following
information:
URL, Username, Password, Notes, Title, Tags

To run the command you need to make sure that this file is in the
same folder as the 'op' binary that you downloaded from the
1Password website.

You must also append the account name you use to login to 1Password
after the name of this file.

# Usage
sh ./opexport.sh email1@login.com
