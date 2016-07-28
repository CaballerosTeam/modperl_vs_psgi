package Core::PSGIHandler;

use strict;
use warnings FATAL => 'all';
use Core::Handler;


#@classmethod
#@method
sub get_psgi_application {
    return sub {
        return [
            '200',
            ['Content-Type' => 'text/html'],
            [Core::Handler::get_body()],
        ];
    };
}

1;
