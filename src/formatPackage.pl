#!/usr/bin/perl
use strict;
use warnings;
my $input="exbank.sty";
my $output="exbank.stripped.sty";
my $toFile=1;
if ($toFile==1){
  open (my $OUTPUT, '>', "$output") or die $!;
  STDOUT->fdopen(\*$OUTPUT, 'w') or die $!;
}

open(my $FILE, "<", $input) or die "could not open input file '$input'\n";

sub say
{
  my ($words) = @_;
	print STDERR "$words";
}
while (my $line = <$FILE>) {
  $_=$line;
  # remove \makeatletter and \makeatother
  s/(?:\\makeatletter|\\makeatother)//g;
  # Remove all unecessary spaces before commands
  s/(\\[a-z]+|\})\ +(\\[a-z]+)/$1$2/g;
  # Remove all spaces at beginning of groups
  s/\{\s+/\{/g;
  # Remove all spaces at end of groups
  s/\s+\}/\}/g;
  # Remove comments that starts but has no content following it
  # and blank lines
  if(/^\s*[%]*\s*$/){next;}
  print $_;
}
