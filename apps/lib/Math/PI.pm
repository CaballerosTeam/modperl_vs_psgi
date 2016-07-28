package Math::PI;

use strict;
use warnings FATAL => 'all';


#@staticmethod
#@method
sub wallis_product {
    my $limit = shift || 10;

    my $result = 1;
    foreach my $n (1..$limit) {
        $result *= 2*$n / (2*$n - 1) * 2*$n / (2*$n + 1);
    }

    return $result;
}

1;
