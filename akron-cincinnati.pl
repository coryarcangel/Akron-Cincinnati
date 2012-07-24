#!/usr/bin/perl -w

use Net::Twitter::Lite;
use Data::Dumper;

#Sleep to make this look like it is not a cron.
$random_number = 60 * int(&random_number);
print "sleep = " . $random_number . "\n";
sleep($random_number);

$current_city = "New York";

#Where am I?
open (MYFILE, 'current_city.txt');
while (<MYFILE>) 
{
	chomp;
	$current_city = $_;
	#print "$_\n";
}
close (MYFILE); 

$travel_destination = "Unknown";

%cities = (
			"Deluth", 10,
			"Akron", 20,
			"Cincinnati", 20,
			"St. Paul", 20,
			"New York", 30
			);

#pick a random city

$value_percent_counter = 0;
$random_number = &random_number;

for my $key ( keys %cities ) 
{
    my $value = $cities{$key};
    $value_percent_counter = $value_percent_counter + $value;
    if ($value_percent_counter < $random_number)
    {
        #print $value_percent_counter . "<" . $random_number . " ";
        $value_percent_counter . "<" . $random_number . " ";
    }
    else
    {
		$travel_destination = $key;
		last;
    }
    # print "$key => $value\n";
}

#print "travel destination = " . $travel_destination . "\n";

if ($current_city eq $travel_destination)
{
}
else
{
	#print to commandline.
	print "$current_city" . " --> " . $travel_destination . "\n";
	print &current_time . "\n";
	
	#print to twitter
	#&post_to_twitter($current_city, $travel_destination);

	#update current city
	$current_city = $travel_destination;

	#Save current city
	open (MYFILE, '>current_city.txt');
	print MYFILE $current_city;
	close (MYFILE); 

}

sub post_to_twitter 
{
	#print to social media outlet. 
	my %consumer_tokens = (
	consumer_key    => 'xxxxxx',
	consumer_secret => 'xxxxxx',
	);
	my %access_tokens=(
	access_token => 'xxxxxx',
	access_token_secret => 'xxxxxx',
	);

	my $nt = Net::Twitter::Lite->new(%consumer_tokens, %access_tokens, legacy_lists_api=>1);

	my $string = $_[0] . " --> " . $_[1];
	my $status = $nt->update({ status => $string });
	#print Dumper $status;

}

sub random_number 
{
	my $range = 100;
	my $random_number = int(rand($range));
}

sub current_time
{

@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;
$myTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
return $myTime;

}