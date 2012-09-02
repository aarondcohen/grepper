#!/usr/bin/env perl

use strict;
use warnings;

use FindBin ();
use Getopt::Long ();

use lib "$FindBin::Bin/lib";
use Grepper;

my @files;
my $grepper = Grepper->new;

Getopt::Long::GetOptions(
	'' => sub { push @files, \*STDIN },
	'ignore-case|i!' => sub { $grepper->is_case_sensitive(! $_[1]) },
	'file=s' => \@files,
	'invert-match|v!' => sub { $grepper->is_inverted($_[1]) },
	'line|n!' =>  sub { $grepper->show_line_number($_[1]) },
	'filename!' => sub { $grepper->show_file_name($_[1]) },
);

$grepper->pattern(shift);
push @files, @ARGV;
@files = (\*STDIN) unless @files;

$grepper->match($_) for @files;
