#! /usr/bin/env perl

# Author: Dominik Danter
#
# Purpose: Set of useful ip tools

package ip_tools;

use warnings;
use strict;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK );

$VERSION    = 0.01;
@ISA        = qw(Exporter);
@EXPORT     = ();
@EXPORT_OK  = qw(get_ip_addresses cidr_to_netmask is_in_same_subnet octet_to_int);

sub get_ip_addresses {
    my ($network, $cidr) = @_;
    my (%address) = (`ip addr show` =~ /inet\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/(\d\d?)/g );
    if ( defined $network && defined $cidr) {
        my @address_in_subnet = grep { &is_in_same_subnet(&octet_to_int($network), &octet_to_int($_), $cidr) } keys %address;
        %address = map {$_ => $address{$_} } @address_in_subnet;
    }    
    return \%address;
}


#sub get_own_dns_name {
#my (@address) = @_;
#@address = &get_ip_adresses unless @address;
#my %names;
#foreach (@address) {
#}
#}

sub cidr_to_netmask {
    my $cidr = shift;
    my $netmask = ~0;
    $netmask =  $netmask << ($cidr);
    $netmask = ~$netmask;
    $netmask =  $netmask << (32 - $cidr);
    return $netmask;
}

sub octet_to_int {
    my $string = shift or die "no argument (ip adress octet string rep) provided";
    my (@octet) = ( $string =~ /(\d{1,3})/g );
    if ( scalar @octet != 4 ) {die "Screw you, this ($string) is no ip address string (x.x.x.x)"};
    return $octet[0] * 256 ** 3 + $octet[1] * 256 ** 2 + $octet[2] * 256 ** 1 + $octet[1];
}

sub is_in_same_subnet {
    my ($addr1, $addr2, $cidr) = @_;
    return !(($addr1 ^ $addr2) & &cidr_to_netmask($cidr));
}
1;
