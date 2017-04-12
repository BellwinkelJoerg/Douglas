#!/usr/bin/perl

#
# Run using
# ES_SERVER=http://192.168.99.100:32806 perl RunHTTPLog.pl '09/Apr/2017:20:21:22' '12/Apr/2017:20:28:29' access.log 10
#
use strict;
use warnings;
use Date::Parse;

my @filecontent; # content of logfile
my @ArrayOfTime; # array with entries belongs to timeperiod
my @Response200; # array with entries belongs to HTTP 200 responses
my $my_percentage;
my $filename=$ARGV[2];
my $StartTime=$ARGV[0];
my $StopTime=$ARGV[1];
my $ElasticID=$ARGV[3];

sub input_intoES {
    
    my $number = shift;

    system("curl -XPUT \'$ENV{'ES_SERVER'}/mydouglas/logs/$number?pretty\' -d \'{ \"start_date\" : \"$StartTime\", \"end_date\" : \"$StopTime\", \"count_total\" : \"$#ArrayOfTime\", \"count_200\" : \"$#Response200\", \"percentage\" : \"$my_percentage\" }\'");
    
}

sub read_log_file{
    my $openfile = shift;
    open (LOGFILE, "$openfile");
    @filecontent=<LOGFILE>;
    close (LOGFILE);
}

sub get_timerange{
    my $line;
    # convert date/time strings to seconds since epoch
    my $start_sec = str2time($StartTime);
    my $stop_sec = str2time($StopTime);

    print "Start time: $StartTime ($start_sec)\n";
    print "Stop time: $StopTime ($stop_sec)\n";

    foreach (@filecontent){
        my $line = $_; # save original line
        if(/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\s-\s-\s\[([0-9]{2}\/[a-zA-Z]{3}\/[0-9]{4}:[0-9]{2}:[0-9]{2}:[0-9]{2})/){
                my $timedate = $1;
                # convert date/time string in log entro to epoch seconds
                my $seconds = str2time($timedate);
                # print line if it falls into the range
                push @ArrayOfTime,$line if(($seconds >= $start_sec)&&($seconds <= $stop_sec));
        }
    }

}

sub get_http200 {
    foreach (@ArrayOfTime){
        my $line = $_; # save original line
        # condense one or more whitespace character to one single space
        s/\s+/ /go;
        
        #  break each apache access_log record into nine variables
        my ($clientAddress,    $rfc1413,      $username,
        $localTime,         $httpRequest,  $statusCode,
        $bytesSentToClient, $referer,      $clientSoftware) =
        /^(\S+) (\S+) (\S+) \[(.+)\] \"(.+)\" (\S+) (\S+) \"(.*)\" \"(.*)\"/o;
        
        if($statusCode == 200){
            # print line if it falls into the range
            push @Response200,$line; #if($http_code == 200);
            #print $line,"\n"; #sleep 1;
        }
    }
}

sub calc_percentage {
    my $all_counts=$#ArrayOfTime;
    my $only_200=$#Response200;
    
    $my_percentage=$all_counts/$only_200;
    
}

# get command line arguments (3)
die "
Usage: ES_SERVER=http://192.168.99.100:32806 $0 '<START_TIME>' '<STOP_TIME>' <LOG_FILE> <ELASTICID>
E.g.: ES_SERVER=http://192.168.99.100:32806 $0 '09/Apr/2017:20:21:22' '09/Apr/2017:20:28:29' /var/log/httpd/access_log 10\n"
unless($#ARGV == 3);

# make sure the log file exists
die "$filename: No such file\n" unless(-f$filename);

read_log_file($filename);
get_timerange();
get_http200();
calc_percentage();
input_intoES($ElasticID);

