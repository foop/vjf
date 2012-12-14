#!/usr/bin/perl

use warnings;
use strict;

use YAML::Tiny;
use FILE::Copy qw(copy);
use File::Spec;

use constant STAT_CTIME => 10;

sub walk_the_dir {
    my $root = shift;
    my $file_call_back = shift;
    my $dir_call_back = shift;
    my $original_root = shift;
    unless (defined $original_root) {
        $original_root = $root;
    }
    my $cwd = getcwd();
    
    chdir($root) or die "Unable to change to $root:$!\n";
    opendir(my $dir_handle, $root) or die "Unable to open $root:$!\n";
    my @files = readdir($dir_handle) or die "Unable to read $root:$!\n"; 
    closedir($dir_handle);
    foreach my $file (@files) {
        next if ( $file eq ".");
        next if ( $file eq "..");
        if (-d $file ) {
            &dir_call_back(abs_path($file), $file_call_back, $dir_call_back, $original_root);
            next;
        }
        if (-f $file ) {
            &file_call_back(abs_path($file), $original_root);
            next;
        }
    chdir ($cwd) or die "Unable to change back to $cod:$!\n";
    1;
}


sub replace_if_newer {
    my ($old_file, $new_file) = @_;
# TODO we probably need a filehandle for stat
# TODO we want to replace if there is no target file too
    if ((stat($old_file))[STAT_CTIME] < (stat($new_file))[STAT_CTIME]) {
        copy($old_file, $new_file);
    }
    1;
}

sub relative_replace {
    my ( $file_with_path, $original_root, $target_root ) = @_;
    my $rel_file_path = File::Spec->abs2rel( $file_with_path, $original_root);
    my ($volume, $rela_dir_path, $file_name) = File::Spec->splitpath($rela_file_path);
    my ($target_file_with_path = File::Spec->catfile($target_root, $rela_dir_path, $file_name);
    replace_if_newer($file_with_path, $target_file_with_path);
    1;
}

sub get_relative_replace_with_fixed_target {
    my $target = shift;
    return sub {
        relative_replace(shift, shift, $target);
    }
}

my ($configfile) = @ARGV;
unless (defined $configfile) { 
    $configfile = '/etc/vjf/file_update.yaml';
}

my $yaml = YAML::Tiny->read($configfile);
my $root = $yaml->[0]->{root};


1;
