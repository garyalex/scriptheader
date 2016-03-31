#!/usr/bin/env perl
# Copyright 2016 
# Author: Gary Alexander garyalex@gmail.com github.com/garyalex
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Summary: Log generation utility in perl
# Details: Use for testing of your logging setup

use 5.014;
use warnings;
use Getopt::Long;

# DEFAULTS
my $set=0;
my $author="Joe Bloggs";
my $version="v0.1";
my $summary="Short idea of what the script does";
my $file="";

GetOptions(
  'set' => \$set,
  'author' => \$author,
  'version' => \$version,
  'summary' => \$summary,
  'file=s' => \$file,
) or print usage();

if ( $set ) {
  # Read-write

} else {
  # Read only
  if ( $author eq "1" ) { 
    print grepfile("Author");
  }
  if ( $version eq "1" ) { 
    print grepfile("Version");
  }
  if ( $summary eq "1" ) { 
    print grepfile("Summary");
  }
}

# DEBUG
print "\n#DEBUG\n";
print "Set:     $set\n";
print "Author:  $author\n";
print "Version: $version\n";
print "Summary: $summary\n";
print "File:    $file\n";

exit 0;

sub grepfile {
  my $fieldname = shift;
  my $matchedlines = "";
  open( my $fh, '<', $file ) or die "Can't open $file: $!";
  while ( my $line = <$fh> ) {
    if ( $line =~ /^\# $fieldname/i ) {
      $matchedlines .= $line;
    }
  }
  close $fh;
  if ( $matchedlines eq "" ) {
    $matchedlines = "Field: ".$fieldname." not found in file!\n";
  }
  return $matchedlines;
}

sub usage {
  my $usagemessage="Usage: $0 --set [ --author=\"Author\" | --version=\"0.1\" | --summary=\"Summary\" ] --file=filename \nUsage: $0 [ --author | --version | --summary ] --file=filename\n";
  return $usagemessage;
}
