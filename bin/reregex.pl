#!/usr/bin/perl

=head1 NAME

reregex.pl - Given multiple regular expressions, construct a string from their captures

=head1 SYNOPSIS

  reregex.pl

    --verbose    be noisier


=head1 DESCRIPTION

=cut

use strict;
use warnings;

use Carp qw( croak confess );

use Data::Dumper;
local $Data::Dumper::Terse  = 1;
local $Data::Dumper::Indent = 1;

our($VERSION) = ( '$Revision$' =~ /^[\$]Revision: ([0-9.]+) [\$]$/ );

my(@All_Parameters) = qw/
	template=s
/;
my(@Required_Parameters) = qw/template/;

use Getopt::Long;
my $getopt = new Getopt::Long::Parser 'config' => [qw/auto_help/];
$getopt->getoptions(\my %opts, 'verbose', @All_Parameters)
	or die "failed to parse all options\n";
my $opt_verbose = $opts{'verbose'};

foreach my $key (@Required_Parameters) {
	die "missing required parameter --$key\n" unless defined $opts{$key};
}

my $template = $opts{'template'};

my $string = pop @ARGV;
$string = <STDIN> if $string eq '-';
chomp($string);

my(@patterns) = map { qr/$_/i } @ARGV;


my(@captures) = ( $string, map { $string =~ $_ } @patterns );

if ($opt_verbose) {
	warn '$template => ', Dumper($template),
		'; \@patterns => ', Dumper(\@patterns),
		'; \@captures => ', Dumper(\@captures),
		"\n";
}

{
	no warnings 'uninitialized';
	$template =~ s/\%(\d+)/$captures[$1]/g;
}

print "$template\n";


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



