package Benchmark::Factory;

use strict;
use warnings FATAL => 'all';
use Text::CSV_XS;
use Benchmark::AB;
use Benchmark::RAM;
use Benchmark::Director;


#@classmethod
#@returns Benchmark::Director
#@method
sub create {
    my (undef, %kwargs) = @_;

    my $csv = Text::CSV_XS->new();
    my $ab = Benchmark::AB->new(map {$_ => $kwargs{$_}} (qw/requests_number uri/));
    my $ram = Benchmark::RAM->new(map {$_ => $kwargs{$_}} (qw/uri processes_mask/));

    return Benchmark::Director->new(
        concurrency => $kwargs{concurrency},
        csv => $csv,
        output_file_name => $kwargs{output_file_name},
        ab => $ab,
        ram_analyser => $ram,
    );
}

1;
