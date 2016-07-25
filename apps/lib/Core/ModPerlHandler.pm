package Core::ModPerlHandler;

use strict;
use warnings FATAL => 'all';
use Apache2::RequestRec;
use Apache2::RequestIO;
use Apache2::Const -compile => 'OK';


sub handler {
    my Apache2::RequestRec $r = shift;
    $r->content_type('text/html');
    print '<h1>It\'s work! '.time.'</h1>';

    return Apache2::Const::OK;
}

1;
