#!/usr/bin/env perl

use warnings;
use strict;

#my (%addresse) = (`ip addr show` =~ /inet\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/(\d\d?)/g );
#
#for my $ip ( keys %addresse ) {
#    print "$ip: $addresse{$ip}\n";
#}

my $cidr = 16;
my $netmask = 0;
print_rev_bit($netmask);
$netmask = ~$netmask;
print_rev_bit($netmask);
$netmask = $netmask << ($cidr);
print_rev_bit($netmask);
$netmask = ~$netmask;
print_rev_bit($netmask);
$netmask = $netmask << (32 - $cidr);
print_rev_bit($netmask);


sub print_rev_bit {
    my $bit = shift;
    my $octet = 0;
    while ($bit > 0) {
        print ( $bit % 2);
        $bit = int($bit / 2); 
        $octet++;
        $octet = $octet % 8;
        if ( $octet == 0 ) {print "."};
    }
    print "\n";
}
