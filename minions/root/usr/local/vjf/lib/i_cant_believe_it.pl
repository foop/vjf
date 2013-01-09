#!/usr/bin/env perl

use warnings;
use strict;
# The weirdest thing, won't fi
use Data::Dumper;

use lib '.';

use ip_tools qw(&get_ip_addresses &octet_to_int &cidr_to_netmask);

&get_ip_addresses("10.7.0.0", 16);
