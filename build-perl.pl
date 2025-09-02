#!/usr/bin/env perl

use v5.42;
use utf8;
use strict;
use warnings;
use Carp qw/croak/;

my $perl_version = shift;

sub execute_or_die(@cmd) {
    my $cmd = join ' ', @cmd;
    print STDERR "> $cmd\n";
    my $code = system(@cmd);
    if ($code != 0) {
        croak "failed to execute $cmd: exit code $code";
    }
}

execute_or_die("curl", "-sSL", "-o", "perl.tar.gz", "https://github.com/Perl/perl5/archive/refs/tags/v$perl_version.tar.gz");
execute_or_die("tar", "-xvf", "perl.tar.gz");

chdir("perl5-$perl_version") or croak "chdir failed: $!";
execute_or_die("patchperl");
execute_or_die("./Configure", "-des", "-Dusedevel");
execute_or_die("make", "depend");
execute_or_die("make");
