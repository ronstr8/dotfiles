#!/usr/bin/perl

=head1 NAME

rename-tracks.pl - Normalize names of audio files

=head1 SYNOPSIS

  rename-tracks.pl

    --verbose    be noisier


=head1 DESCRIPTION

for dn in [0-9]* ; do echo "===== $dn" ; perl ~/bin/rename-tracks.pl "$dn" --dry-run  ; done

=cut

use strict;
use warnings;

use Carp    qw( croak confess  );
use English qw( -no_match_vars );
use DirHandle;
use Quack;

use Data::Dumper;
local $Data::Dumper::Terse  = 1;
local $Data::Dumper::Indent = 0;

our($VERSION) = ( '$Revision$' =~ /^[\$]Revision: ([0-9.]+) [\$]$/ );

### Getopt Boilerplate {{{

my(@All_Parameters) = qw/
	dry-run
	lax
/;
my(@Required_Parameters) = qw//;

use Getopt::Long;
my $getopt = new Getopt::Long::Parser 'config' => [qw/auto_help/];
$getopt->getoptions(\my %opts, 'verbose:+', @All_Parameters)
	or die "failed to parse all options\n";

foreach my $key (@Required_Parameters) {
	die "missing required parameter --$key\n" unless defined $opts{$key};
}

my $verbose = $opts{'verbose'} || 0;
my $dry_run = $opts{'dry-run'};

### }}}

my $dn = shift @ARGV or die "missing requirement argument of root directory";
$dn =~ s{/$}{};
$dn = "./$dn" unless $dn =~ m{^/};

my @de = _get_audio_file_contents($dn);
die "no mp3 files found in $dn" unless @de;

quack { \@de } if $verbose;
my %renames;

foreach my $fn (@de) {
	my($prejunk, $rawtitle) = ( $fn =~ /^([0-9A-Z -]+\s+)(.+)$/ );
	$rawtitle = trim($rawtitle);

	if (not $rawtitle) {
		warn "$fn :: failed to match $fn!";
		die unless $opts{'lax'};
	}

	my($track, $pretitle) = ( $prejunk =~ m/\D((\d{1,2})(\D.*))$/ )[1 .. 2];
	if (not $track) {
		warn "$fn :: failed to match a track on $prejunk!";
		die unless $opts{'lax'};
	}

	$pretitle = trim($pretitle);
	$pretitle =~ s/-//g;
	$pretitle =~ s/^([A-Z]{2,}\s?)+//;
	$pretitle = trim($pretitle);

	my $name = $pretitle ? "$pretitle $rawtitle" : $rawtitle;
	$name = "$track - $name";

	$renames{$fn} = $name;
	if ($verbose) {
		quack { $fn, $prejunk, $rawtitle, $track, $pretitle, $name } if $verbose >  1;
		quack { $fn, $name } if $verbose <= 1;
	}
}

foreach my $fn ( sort keys %renames ) {
	my($src, $dst) = map { shellesc("$dn/$ARG") } ( $fn, $renames{$fn} );

	my $cmdline = "mv $src $dst";
	warn "$cmdline\n" if $verbose;

	next if $dry_run;
	qx{$cmdline};
	warn "FAIL :: $src => $dst :: $OS_ERROR\n" if $OS_ERROR;
}

sub _get_audio_file_contents
{
	my $dn = shift;

	my $dh = DirHandle->new($dn) or die "failed to open directory $dn: $!";
	my @de = grep { !/^\./ and /\.mp3/i } $dh->read;
	$dh->close;

	return @de;

}

sub trim
{
	my $s = shift;
	$s =~ s/\s+$//;
	$s =~ s/^\s+//;
	return $s;
}

sub shellesc
{
	my $s = shift;

	if ($s !~ m/\'/) {
		$s = qq{'$s'};
	}
	elsif ($s !~ /["\$*!]/) {
		$s = qq{"$s"};
	}
	elsif ($s =~ /[;&><|]/) {
		die "shell characters in $s; not risking it";
	}
	else {
		## Escape whitespace, at least.
		$s =~ s/\s/\\ /g;
	}

	return $s;
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

## vim: foldmethod=marker



