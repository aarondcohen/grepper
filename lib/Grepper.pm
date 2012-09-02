package Grepper;

use strict;
use Moose;

has is_case_sensitive => (is => 'rw', isa => 'Bool', default => 1);
has is_inverted => (is => 'rw', isa => 'Bool', default => 0);
has pattern => (is => 'rw');
has show_file_name => (is => 'rw', isa => 'Bool', default => 0);
has show_line_number => (is => 'rw', isa => 'Bool', default => 0);

no Moose;

sub match {
	my $this = shift;
	my ($in) = @_;

	my $compiled_pattern = qr|(?${\( $this->is_case_sensitive ? '' : 'i' )}:${\( $this->pattern )})|;
	my $format = join(':',
		$this->show_file_name ? defined fileno($in) ? "[${\( { 0 => 'STDIN' }->{fileno($in)} || $in )}]" : "[$in]" : (),
		$this->show_line_number ? '[%d]' : (),
		'%s'
	);
	my $is_inverted = $this->is_inverted;

	my $in_stream;

	if (ref $in eq 'GLOB') {
		$in_stream = $in;
	} else {
		open($in_stream, '<', $in) || die "Failed to open file [$in] - $!";
	}

	my $count = 0;
	while (my $line = <$in_stream>) {
		++$count;
		printf($format, $this->show_line_number ? $count : (), $line)
			if $is_inverted xor $line =~ $compiled_pattern;
	}
}

1;
