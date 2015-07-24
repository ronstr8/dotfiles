#!/usr/bin/perl

## playrandom.pl <files or directories>
##	Plays all MP3 given on cmdline, prefacing with name/title/whatever.
## --
## quinn@fazigu.org

$PLAYER_OPTIONS='';
$PLAYER_OPTIONS=' -b 1024';
#$PLAYER='/usr/local/bin/mplayer -really-quiet -ao alsa:device=hw=0.3'; # pulse'; # "/usr/bin/mpg123 -q $BUFFER";
$PLAYER='mpg123'; # "/usr/bin/mpg123 -q $BUFFER";
#$PLAYER='mplayer'; # -really-quiet'; # -ao alsa:device=hw=0.3'; # pulse'; # "/usr/bin/mpg123 -q $BUFFER";
$SPEAKER='festival --tts';

$TEXTPREFIX='$artist, "$title"';
@SPEECH=(
	"Here is \$artist with \$title.",
	"Next up is \$title from \$artist.",
	"From the album \$album, here is \$artist with \$title.",
	"\$artist here with \$title.",
	"Now we hear \$artist performing \$title from the album \$album."
	);

$PAUSETIME=1;  # sleep between songs
$SLEEPTIME=10; # sleep between entire rotations

use MP3::Info;
@INTERESTING_INFO = ('VBR', 'BITRATE', 'FREQUENCY', 'SIZE', 'TIME');
@INTERESTING_TAGS = ('TITLE', 'ARTIST', 'ALBUM', 'YEAR', 'COMMENT',
			'GENRE', 'TRACK');

$RELOAD = 0;
sub catch_hup($signame) { $RELOAD = 1; }
$SIG{HUP} = \&catch_hup;

@ALLFILES = @ARGV;
if (not @ALLFILES) { chop($pwd = `pwd`); @ALLFILES= ($pwd); }

while (1) {
	$musicref = getrotation(@ALLFILES);
	rotate($musicref);
	sleep $SLEEPTIME;
}

sub rotate
{
	my $musicref = shift;
	my %music    = %{$musicref};

	while (%music) {
		@whatsleft = keys(%music);
		$f  = $whatsleft[rand(scalar(@whatsleft))];
		$fn = $music{$f};
		delete $music{$f};

		$fn =~ s/\"/\\\"/g;
		$player_cmdline = "$PLAYER \"$fn\"";

		$mp3 = my_mp3info($fn);

		chop($nowtime =  `date +"%A at %H:%M"`);
		$songsleft = scalar(@whatsleft);

#		print "$fn\n";
		print "$nowtime, ", my_mp3sub($mp3, $TEXTPREFIX);
		print "\n$songsleft song(s) left in current rotation.\n\n";

		if ($SPEAKER and @SPEECH) {
			$message = $SPEECH[rand(scalar(@SPEECH))];
			$message = my_mp3sub($mp3, $message);
			$speaker_cmdline = "echo $message | $SPEAKER";
			system($speaker_cmdline);
		}

		sleep $PAUSETIME;
		system($player_cmdline);

		if ($RELOAD) {
			$RELOAD = 0;
			return;
		}

	}
}

sub getrotation
{
	my @ALLFILES = @_;
	my $music = {};

	foreach $rotdir (@ALLFILES) {
		if (-d $rotdir) {
			if (opendir(DP, "$rotdir")) {
				my @allfiles = readdir(DP);
				closedir(DP);
				my @choices = grep { /\.mp3$/i } @allfiles;
				foreach $f (@choices) {
					$music->{$f} = "$rotdir/$f";
				}	
			}
			else {
				print "failed to open folder $rotdir: $!\n";
			}
		}
		else {
			$music->{$rotdir} = $rotdir;
		}
	}

	return $music;
}

sub my_mp3info
{
	my $fn = shift;
	my $info   = MP3::Info::get_mp3info($fn);
	my $tag    = MP3::Info::get_mp3tag($fn);
	my $mp3    = {};
	my $WERX = "([a-z_0-9 ']+)";   # filename word element regex pattern
	my $WSRX = "(?:--| - )";  # filename word separator regex pattern
	my %guesses;

	foreach $key (@INTERESTING_INFO) { $mp3->{$key} = $info->{$key}; }
	foreach $key (@INTERESTING_TAGS) { $mp3->{$key} = $tag->{$key}; }

	$fn =~ s~^.*/([^/]*)$~$1~g;

	if ($fn =~ /$WERX$WSRX$WERX$WSRX(\d+)--?$WERX\.mp3$/i) {
		$guesses{artist} = $1;
		$guesses{album} = $2;
		$guesses{track} = $3;
		$guesses{title} = $4;
	}
	elsif ($fn =~ /$WERX$WSRX$WERX$WSRX$WERX\.mp3$/i) {
		$guesses{artist} = $1;
		$guesses{album} = $2;
		$guesses{title} = $3;
	}
	elsif ($fn =~ /$WERX$WSRX$WERX\.mp3$/i) {
		$guesses{artist} = $1;
		$guesses{title} = $2;
	}
	elsif ($fn =~ /(.+).mp3$/i) {
		$guesses{title} = $1;
	}

	foreach $key (keys %guesses) {
		$guesses{$key} =~ s~^[/\.]/~~g;
		$guesses{$key} =~ s/_/ /g;
		$guesses{$key} =~ tr/A-Za-z0-9 './/cd;
	}

	$mp3->{TITLE}  = $mp3->{TITLE} || $guesses{title} || $fn;
	$mp3->{ARTIST} = $mp3->{ARTIST} || $guesses{artist};
	$mp3->{ALBUM}  = $mp3->{ALBUM} || $guesses{album};
	$mp3->{TRACK}  = $mp3->{TRACK} || $guesses{track};

	foreach $key (@INTERESTING_TAGS) {
		next if $mp3->{$key};
		$mp3->{$key} = "unknown " . lc $key;
	}

	return $mp3;
}

sub my_mp3sub
{
	my($mp3, $msg) = @_;

	$msg =~ s/([^\\]?)\$(\w+)/sprintf("%s%s", $1, $mp3->{uc $2})/gie;

	return $msg;
}

