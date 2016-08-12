package Benchmark::AB;

use strict;
use warnings FATAL => 'all';
use Carp;
use threads;
use Benchmark::AB::Result;

my $AB_NAME = 'ab2';


sub new {
    my ($class, %kwargs) = @_;

    Carp::confess("[!] Not an ARRAY ref or empty ARRAY")
        if (ref $kwargs{concurency} ne 'ARRAY' || !@{$kwargs{concurency}});

    for (qw/requests_number uri output_file_name csv/) {
        Carp::confess(sprintf("[!] Missing required argument '%s'", $_)) unless ($kwargs{$_});
    }

    return bless(\%kwargs, $class);
}

#@method
sub run {
    my ($self) = @_;

    my $csv = $self->get_csv();
    my $fh = $self->get_filehandle();

    $csv->say($fh, [qw/concurrency requests_per_second time_per_request transfer_rate/]);

    my $concurency_list = $self->get_concurency();
    if (ref $concurency_list eq 'ARRAY' && @{$concurency_list}) {
        foreach my $concurency_value (@{$concurency_list}) {
            my $result = $self->run_benchmark(
                concurency => $concurency_value,
                requests_number => $self->get_requests_number(),
                uri => $self->get_uri(),
            );

            $csv->say($fh, [
                    $concurency_value,
                    $result->get_requests_per_second(),
                    $result->get_time_per_request(),
                    $result->get_transfer_rate(),
                ]);
        }
    }

    return 1;
}

#@method
sub get_concurency {
    my ($self) = @_;

    return $self->{concurency};
}

#@staticmethod
#@returns Benchmark::AB::Result
#@method
sub run_benchmark {
    my (undef, %kwargs) = @_;

    for (qw/concurency requests_number uri/) {
        Carp::confess(sprintf("[!] Missing required argument '%s'", $_)) unless ($kwargs{$_});
    }

    my $command = sprintf('%s -c %u -n %u %s', $AB_NAME, $kwargs{concurency}, $kwargs{requests_number}, $kwargs{uri});

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

#@returns Text::CSV_XS
#@method
sub get_csv {
    my ($self) = @_;

    return $self->{csv};
}

#@method
sub get_filehandle {
    my ($self) = @_;

    my $key = '__filehandle';
    unless (defined $self->{$key}) {
        my $output_file_name = $self->get_output_file_name();

        open(my $fh, '>>', $output_file_name)
            or Carp::confess(sprintf("Can't open output file: %s: %s", $output_file_name, $!));

        $self->{$key} = $fh;
    }

    return $self->{$key};
}

#@method
sub get_output_file_name {
    my ($self) = @_;

    return $self->{output_file_name};
}

1;
