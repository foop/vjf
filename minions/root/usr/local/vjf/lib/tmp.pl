#!/usr/bin/env perl 

# TODO the weirdest thing, won't find &get_ip_addresses
# unless I load Data::Dumper
use Data::Dumper; 

use warnings;
use strict;

use lib '.';

use constant VJF_NET => "10.7.0.0";
use constant VJF_CIDR => 16;

use ip_tools qw(&get_ip_addresses);

my $machine_hash = &get_ip_addresses(VJF_NET, VJF_CIDR);
my $machine;
foreach (keys %$machine_hash) {
    print;
    $machine = $_;
}



my @bytes = split (/\./, $machine); 
my $pack_addr = pack ("C4", @bytes); 

my ($name, $alt_name, $addr_type, $len, @addr_list) = gethostbyaddr ($pack_addr, 2) or die "Address of $machine could not be found";

#if (!(($name, $altnames, $addrtype, $len, @addrlist) = gethostbyaddr ($packaddr, 2))) { 
#    die ("Address $machine not found.\n"); 
#} 

print ("Principal name: $name\n"); 
if ($alt_name ne "") { 
    print ("Alternative names:\n"); 
    my @alt_list = split (/\s+/, $alt_name); 
    for (my $i = 0; $i < @alt_list; $i++) { 
        print ("\t$alt_list[$i]\n"); 
    } 
} 
 
