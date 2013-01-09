#!/usr/bin/env perl

use warnings;
use strict;
use Data::Dumper;

use lib '.';

use ip_tools qw(&get_ip_addresses &octet_to_int &cidr_to_netmask);

print Dumper(&octet_to_int("10.7.2.1"));
print Dumper(&octet_to_int("10.7.0.0"));
print Dumper(&get_ip_addresses("10.7.0.0", 16));
print Dumper(&cidr_to_netmask(16));

#my (%addresse) = (`ip addr show` =~ /inet\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/(\d\d?)/g );
#
#for my $ip ( keys %addresse ) {
#    print "$ip: $addresse{$ip}\n";
#}

