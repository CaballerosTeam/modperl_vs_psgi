#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use FindBin;
use lib sprintf('%s/../lib', $FindBin::Bin);
use Benchmark::Factory;


my $benchmark = Benchmark::Factory->create(
    concurency => [1..20],
    requests_number => 100_000,
    uri => 'mod_perl.example.com/',
    output_file_name => 'mod_perl__max_spare_servers_35.csv',
);

$benchmark->run();
