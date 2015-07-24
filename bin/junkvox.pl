#!/usr/bin/perl

=head1 NAME

junkvox.pl - Play random media files

=head1 SYNOPSIS

  junkvox.pl

    --verbose    be noisier

    --viewing-time=n
                 total viewing time desired (in seconds)

	--default-duration=n

                 duration of media in seconds if it cannot
				 be derived from metadata

=head1 DESCRIPTION

=cut

use strict;
use warnings;

use Carp qw/croak confess/;
use DirHandle;
use List::Util qw/shuffle/; 

use Data::Dumper;
local $Data::Dumper::Terse  = 1;
local $Data::Dumper::Indent = 0;

my(@All_Parameters) = qw/viewing-time=n default-duration=s/;
my(@Required_Parameters) = qw//;

use Getopt::Long;
my $getopt = new Getopt::Long::Parser 'config' => [qw/auto_help/];
$getopt->getoptions(\my %opts, 'verbose', @All_Parameters)
	or die "failed to parse all options\n";
my $verbose = $opts{'verbose'};

foreach my $key (@Required_Parameters) {
	die "missing required parameter --$key\n" unless defined $opts{$key};
}

my $viewing_time = $opts{'viewing-time'} || 86400;
my $default_duration = $opts{'default-duration'} || 600;

my $basedir = shift @ARGV || '.';

my(@files) = shuffle grep { -f "$basedir/$_" }
	DirHandle->new($basedir)->read;

my(%durs) = map { $_ => 0 } qw/actual guessed approx/;
my(@chosen_ones);

foreach my $fn (@files) {
	my $filepath = quote_filename_for_shell("$basedir/$fn");

	print "==== $fn\n" if $verbose;

	my $durkey = 'actual';
	my $duration = fetch_duration($filepath);
	
	if (not $duration) {
		$duration = $default_duration;
		$durkey = 'guessed';
	}

	## Skip any one file greater than the entire viewing time
	next if $duration > $viewing_time;

	$durs{$durkey}  += $duration;
	$durs{'approx'} += $duration;

#	printf '%5d seconds :: %s%s', $duration, $fn, "\n";
	push(@chosen_ones, $filepath);
	last if $durs{'approx'} > $viewing_time;
}


sub quote_filename_for_shell
{
	my $fn = shift;

	return qq{"$fn"};
}

sub fetch_duration
{
	my $fn = shift;

	## Rather system() than learn Python.  :(
	my $metadata = qx{ /usr/bin/hachoir-metadata --raw $fn 2> /dev/null };
	my($hours, $minutes, $seconds) =
		($metadata =~ /duration:\s+(\d+):(\d+):(\d+)/);

	if (defined $seconds) {
		return $hours * 3600 + $minutes * 60 + $seconds;
	}

	return;
}


__END__

=head1 SEE ALSO

=begin CHANGELOG

$Log$

=end CHANGELOG

=head1 AUTHOR

Ron "Quinn" Straight E<lt>quinnfazigu@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Public domain.  Free to use and distribute, appreciate attribution.

=cut



