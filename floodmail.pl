#!/usr/bin/perl -w

# simplest version
use LWP::Simple;

my $URL = "http://waterdata.usgs.gov/wa/nwis/uv/?station=12149000";

$content = get($URL);

my @lines = split(/\s/, $content);
my @infos;

my $j = 0;
for ($i = 0; $i <= $#lines; $i++) {
    if ($lines[$i] eq "value:") {
	$infos[$j] = $lines[$i + 1];
	$j++;
    }
}

print "Discharge, cubic feet per second: $infos[0]\n";
print "Gage height, feet: $infos[1]\n";

$difference = 54 - $infos[1];
my $message =  "McBride Farm HIGH RIVER ALERT!\nDischarge, cubic feet per second: $infos[0]\nGage height, feet: $infos[1]\n$difference ft below flood stage.";

if ($infos[1] > 50) {
    sendEmail("cid\@u.washington.edu", "floodwarning\@mcbridefarm.org", "McBride Farm Flood Warning Center HIGH RIVER ALERT", $message);
    sendEmail("cindy\@mcbridefarm.org", "floodwarning\@mcbridefarm.org", "FloodWatch", $message);
}

#Simple Email Function
#($to, $from, $subject, $message)
sub sendEmail
{
    my ($to, $from, $subject, $message) = @_;
    my $sendmail = '/usr/lib/sendmail';
    open(MAIL, "|$sendmail -t $to");
    print MAIL "From: $from\n";
    print MAIL "To: $to\n";
    print MAIL "Subject: \n\n";
    print MAIL "$message\n";
    close(MAIL);

}
