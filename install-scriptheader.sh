#!/bin/bash

echo "Choose automatic CPAN config in the next section or exit from CPAN shell"
echo "Enter to continue..."
read NULL
sudo perl -MCPAN -e shell
sudo perl -MCPAN -e "install 'Getopt::Long'"
sudo perl -MCPAN -e "install 'File::Copy'"
