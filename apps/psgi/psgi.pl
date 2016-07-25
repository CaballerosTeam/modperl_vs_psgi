#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use FindBin;
use lib sprintf('%s/../lib', $FindBin::Bin);
use Core::PSGIHandler;


my $app = Core::PSGIHandler->get_psgi_application();
