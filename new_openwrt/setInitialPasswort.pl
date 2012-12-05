#!/usr/bin/perl
use Net::Telnet ();
use strict;
use 5.010;
use warnings;

my $ip_addr = shift(@ARGV) || "192.168.1.1";
my $passwd = shift(@ARGV) || "default_password";
my $prompt_default = 'm&root\@OpenWrt:/#\s&' ;
my $prompt_password = "/New password:/";
my $prompt_password_2 = "/Retype password:/";
my $t;

$t = new Net::Telnet (Timeout => 10);
$t->open($ip_addr);
$t->waitfor($prompt_default);
say "prompt received";
$t->print("passwd");
say "command typed in";
$t->waitfor($prompt_password);
say "password prompt received";
$t->print($passwd);
say "typing in password ... ";
$t->waitfor($prompt_password_2);
say "2nd password prompt received";
say "typing in password 2nd time ...";
$t->print($passwd);
$t->waitfor($prompt_default);
say "all done!";
exit;
