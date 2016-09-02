package Benchmark::RAM::Result;

use strict;
use warnings FATAL => 'all';
use Carp;


sub new {
    my ($class, $data) = @_;

    Carp::confess("[!] Missing required argument 'data") unless ($data);

    return bless({data => $data}, $class);
}

sub get_value {
    my ($self) = @_;

    my $value = 0;
    if ($self->data =~ m/^\d+(?:\.\d+)$/m) {
        $value = $&;
    }

    return $value;
}

sub data {
    my ($self) = @_;

    return $self->{data};
}

1;
