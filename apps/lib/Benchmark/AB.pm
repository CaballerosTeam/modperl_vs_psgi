package Benchmark::AB;

use strict;
use warnings FATAL => 'all';
use Carp;
use threads;
use Benchmark::AB::Result;

my $AB_NAME = 'ab2';


sub new {
    my ($class, %kwargs) = @_;

    for (qw/requests_number uri/) {
        Carp::confess(sprintf("[!] Missing required argument '%s'", $_)) unless ($kwargs{$_});
    }

    return bless(\%kwargs, $class);
}

#@returns Benchmark::AB::Result
#@method
sub run_benchmark {
    my ($self) = @_;

    my $command = sprintf('%1$s -c %2$u -n %3$u %4$s'
        ,$AB_NAME
        ,$self->get_concurrency()
        ,$self->get_requests_number()
        ,$self->get_uri()
    );

    my threads $t = threads->create(
        {context => 'scalar'},
        sub {
            return `$_[0]`;
        },
        $command
    );

    my $raw_data = $t->join();

    return Benchmark::AB::Result->new($raw_data);
}

#@method
sub get_requests_number {
    my ($self) = @_;

    return $self->{requests_number};
}

#@method
sub get_uri {
    my ($self) = @_;

    return $self->{uri};
}

#@method
sub set_concurrency {
    my ($self, $concurrency) = @_;

    Carp::confess("[!] Missing required argument 'concurrency'") unless ($concurrency);

    $self->{concurrency} = $concurrency;
}

#@method
sub get_concurrency {
    my ($self) = @_;

    return int($self->{concurrency}) || 1;
}

1;
