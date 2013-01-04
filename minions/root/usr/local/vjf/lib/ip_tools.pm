#! /usr/bin/env perl

# Author: Dominik Danter
#
# Purpose: Executes all files in folder "./foo.d", where foo is the name
#          of the file executing execute_d();

package ip_tools;

use warnings;
use strict;

my $VERSION    = 0.01;
my @ISA        = qw(Exporter);
my @EXPORT     = ();
my @EXPORT_OK  = qw(get_ip_adresses cidr_to_netmask is_in_same_subnet);

sub get_ip_addresses {
    my ($network, $cidr) = @_;
    my (%address) = (`ip addr show` =~ /inet\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/(\d\d?)/g );
    if ( defined $network && defined $cidr) {
        my @address_in_subnet = grep { is_in_same_subnet($network, $_, $cidr) } keys %address;
        %address = @address{@address_in_subnet};
    }    
    return ${%address};
}

sub cidr_to_netmask {
    my $cidr = shift;
    my $netmask = ~0;
    $netmask = $netmask << ($cidr);
    $netmask = ~$netmask;
    $netmask = $netmask << (32  - $cidr);
    return $netmask;
}

sub oz_is_in_same_subnet {
    my ($addr1, $addr2, $cidr) = @_;
    return ~(($addr1 ^ $addr2) & &cidr_to_netmask($cidr));
}
1;
