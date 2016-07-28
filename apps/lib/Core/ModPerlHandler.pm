package Core::ModPerlHandler;

use strict;
use warnings FATAL => 'all';
use Apache2::RequestRec;
use Apache2::RequestIO;
use Apache2::Const -compile => 'OK';
use Core::Handler;


sub handler {
    my Apache2::RequestRec $r = shift;

    $r->content_type('text/html');

    print Core::Handler::get_body();

    return Apache2::Const::OK;
}

1;
