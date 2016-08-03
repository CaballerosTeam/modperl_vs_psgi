package Benchmark::AB::Result;

use strict;
use warnings FATAL => 'all';


sub new {
    my ($class, $raw_data) = @_;

    Carp::confess(sprintf('[!] Missing data')) unless ($raw_data);

    return bless({raw_data => $raw_data}, $class);
}

#@method
sub get_requests_per_second {
    my ($self) = @_;

    my $raw_data = $self->get_raw_data();
    if ($raw_data =~ m/^Requests per second:[^\d]+(\d+(?:\.\d+)?)/m) {
        return $1;
    }
    else {
        warn "[!] Can't find 'Requests per second' row";
    }

    return;
}

#@method
sub get_time_per_request {
    my ($self) = @_;

    my $raw_data = $self->get_raw_data();
    if ($raw_data =~ m/^Time per request:[^\d]+(\d+(?:\.\d+)?)[^\[]+\[ms\][^(]+\(mean\)/m) {
        return $1;
    }
    else {
        warn "[!] Can't fing 'Time per request' row";
    }

    return;
}

#@method
sub get_transfer_rate {
    my ($self) = @_;

    my $raw_data = $self->get_raw_data();
    if ($raw_data =~ m/^Transfer rate:[^\d]+(\d+(?:\.\d+)?)/m) {
        return $1;
    }
    else {
        warn "[!] Can't fing 'Transfer rate' row";
    }

    return;
}

#@method
sub get_raw_data {
    my ($self) = @_;

    return $self->{raw_data};
}

1;
