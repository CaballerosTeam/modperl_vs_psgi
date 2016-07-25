package Core::PSGIHandler;

use strict;
use warnings FATAL => 'all';


#@classmethod
#@method
sub get_psgi_application {
    return sub {
        return [
            '200',
            ['Content-Type' => 'text/html'],
            ['<h1>It\'s work! '.time.'</h1>'],
        ];
    };
}

1;
