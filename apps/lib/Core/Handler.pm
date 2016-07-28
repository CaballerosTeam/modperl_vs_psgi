package Core::Handler;

use strict;
use warnings FATAL => 'all';
use Math::PI;


#@method
sub get_body {
    my $limit = 300;

    return sprintf('<h1>Wallis product is %s</h1><h1>PI number is %s</h1>'
        ,Math::PI::wallis_product($limit)
        ,Math::PI::wallis_product($limit) * 2
    );
}

1;
