#! /usr/bin/env perl

# Author: Dominik Danter
#
# Purpose: Executes all files in folder "./foo.d", where foo is the
#          name passed, or if none was passed the name of the file
#          executing execute_d();

package execute_d;

use warnings;
use strict;
use Cwd 'abs_path';
use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK );
use YAML::Tiny;
use File::Spec;

$VERSION    = 0.01;
@ISA        = qw(Exporter);
@EXPORT     = ();
@EXPORT_OK  = qw(execute_d);

my ($volume, $directory) = File::Spec->splitpath( $INC{'execute_d.pm'} );
my $yaml_file = File::Spec->catpath( $volume, $directory, '../config.yaml' );
my $yaml = YAML::Tiny->read($yaml_file);

my $debug = $yaml->[0]->{debug};
print "debug on! \n" if $debug;

print "name of script: \t" .  $0 . "\n" if $debug;

sub execute_d() {
    my $script_name = shift;
    if (! defined $script_name ) $script_name = $0;
    my $scripts_directory = abs_path($script_name) . ".d";
    my @scripts = <$scripts_directory/*>;
    print "scripts directory:\t" . $scripts_directory . "\n" if $debug;
    foreach my $script (@scripts) {
        print "found file or folder:\t$script\n" if $debug;
        if ( -x $script && ! -d $script ) {
            if ($debug) {
                print "File is executable trying to execute ... \t\n";
                print `$script`; 
                print "\n";
            } else {
                `$script`;
            }
        }
    }
}
1;
