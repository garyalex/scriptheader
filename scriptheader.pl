#!/usr/bin/env perl
# Version: v0.3
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
use File::Copy "cp";

# DEFAULTS
my $set=0;
my $author="";
my $version="";
my $summary="";
my $show="all";
my $file="";
my $help=0;
my $debug=0;

GetOptions(
  'set' => \$set,
  'show=s' => \$show,
  'author=s' => \$author,
  'version=s' => \$version,
  'summary=s' => \$summary,
  'file=s' => \$file,
  'help' => \$help,
  'debug' => \$debug,
) or die usage();

if ( $help ) {
  print usage();
  exit 0;
}

if ( $set ) {
  # Read-write
  if ( $author ne "" ) {
    print "Author lines: ".fieldexists("Author")."\n";
    if ( fieldexists("Author") eq 0 ) {
      my $insertion = insertfield("Author",$author);
    } else {
      my $replacement = replacefield("Author",$author);
    }
  }
  if ( $version ne "" ) { 
    print "Version lines: ".fieldexists("Version")."\n";
    if ( fieldexists("Version") eq 0 ) {
      my $insertion = insertfield("Version",$version);
    } else {
      my $replacement = replacefield("Version",$version);
    }
  }
  if ( $summary ne "" ) { 
    print "Summary lines: ".fieldexists("Summary")."\n";
    if ( fieldexists("Summary") eq 0 ) {
      my $insertion = insertfield("Summary",$summary);
    } else {
      my $replacement = replacefield("Summary",$summary);
    }
  }
} else {
  # Read only
  if ( $show =~ /all/i ) { 
    print grepfile("Author");
    print grepfile("Summary");
    print grepfile("Version");
  } else { 
    print grepfile($show);
  }
} 

if ( $debug ) {
  # DEBUG
  print "\n#DEBUG\n";
  print "Set:     $set\n";
  print "Show:    $show\n";
  print "Author:  $author\n";
  print "Version: $version\n";
  print "Summary: $summary\n";
  print "File:    $file\n";
}

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

sub fieldexists {
  my $fieldname = shift;
  my $matchedlines = 0;
  open( my $fh, '<', $file ) or die "Can't open $file: $!";
  while ( my $line = <$fh> ) {
    if ( $line =~ /^\# $fieldname/i ) {
      $matchedlines++;
    }
  }
  close $fh;
  return $matchedlines;
}

sub insertfield {
  my $fieldname = shift;
  my $content = shift;
  open( my $fh, '<', $file ) or die "Can't open $file: $!";
  cp( $file, "$file.new") or die "Copy failed to $file.new: $!";
  open( my $fho, '>', "$file.new" ) or die "Can't write $file.new: $!";
  while( <$fh> ) {
    if ( $. == 2) {
      print $fho "# $fieldname: $content\n";
    }
    print $fho $_;
  }
  close $fh;
  close $fho;
  return 0;
}

sub replacefield {
  my $fieldname = shift;
  my $content = shift;
  open( my $fh, '<', $file ) or die "Can't open $file: $!";
  cp( $file, "$file.new") or die "Copy failed to $file.new: $!";
  open( my $fho, '>', "$file.new" ) or die "Can't write $file.new: $!";
  while( <$fh> ) {
    if ( $_ =~ /^\# $fieldname/i ) {
      print $fho "# $fieldname: $content\n";
    } else {
      print $fho $_;
    }
  }
  close $fh;
  close $fho;
  return 0;
}

sub usage {
  my $usagemessage="Usage: $0 --set [ --author=\"AB\" | --version=\"0.1\" | --summary=\"Summ\" ] --file=file \nUsage: $0 --show=(all|author|version|summary) --file=filename\n";
  return $usagemessage;
}
