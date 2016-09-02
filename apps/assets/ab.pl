#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use Scalar::Util;
use POSIX;
use FindBin;
use lib sprintf('%s/../lib', $FindBin::Bin);
use Benchmark::Factory;


my %kwargs = @ARGV;
if (
    !@ARGV
    || !$kwargs{'-r'}
    || !Scalar::Util::looks_like_number($kwargs{'-r'})
    || !$kwargs{'-u'}
    || !$kwargs{'-n'}
    || !Scalar::Util::looks_like_number($kwargs{'-n'})
    || !$kwargs{'-m'}
) {
    printf("Usage: %s -r [REQUSTS NUMBER] -u [URL] -n [REPEATS] -m [PROCESSES MASK]\n", $0);
    exit(0);
}

for (1..int($kwargs{'-n'})) {
    my $domain = [split('/', $kwargs{'-u'})]->[0];
    my $cdate = POSIX::strftime('%d%m%Y_%H%M%S', localtime(time));

    my $benchmark = Benchmark::Factory->create(
        concurrency => [1..20],
        requests_number => $kwargs{'-r'},
        uri => $kwargs{'-u'},
        output_file_name => sprintf('%s__%s.csv', $domain, $cdate),
        processes_mask => $kwargs{'-m'},
    );

    $benchmark->run();
}
