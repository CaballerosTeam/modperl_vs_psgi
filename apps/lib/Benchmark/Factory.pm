package Benchmark::Factory;

use strict;
use warnings FATAL => 'all';
use Text::CSV_XS;
use Benchmark::AB;


#@classmethod
#@returns Benchmark::AB
#@method
sub create {
    my (undef, %kwargs) = @_;

    my $csv = Text::CSV_XS->new();
    $kwargs{csv} = $csv;

    return Benchmark::AB->new(%kwargs);
}

1;
