package Benchmark::Director;

use strict;
use warnings FATAL => 'all';
use Carp;
use Scalar::Util;


sub new {
    my ($class, %kwargs) = @_;

    for (qw/concurrency csv output_file_name ab ram_analyser/) {
        Carp::confess(sprintf("[!] Missing reqired argument '%s'", $_)) unless ($kwargs{$_});

        Carp::confess("Not an 'ARRAY' ref in 'concurrency")
            if (ref $kwargs{concurrency} ne 'ARRAY' || !@{$kwargs{concurrency}});

        Carp::confess("[!] Not a 'Text::CSV_XS' in 'csv'")
            if (!Scalar::Util::blessed($kwargs{csv}) || !$kwargs{csv}->isa('Text::CSV_XS'));

        Carp::confess("[!] Not a 'Benchmark::AB' in 'ab'")
            if (!Scalar::Util::blessed($kwargs{ab}) || !$kwargs{ab}->isa('Benchmark::AB'));

        Carp::confess("[!] Not a 'Benchmark::RAM' in 'ram_analyser'")
            if (!Scalar::Util::blessed($kwargs{ram_analyser}) || !$kwargs{ram_analyser}->isa('Benchmark::RAM'));
    }

    return bless(\%kwargs, $class);
}

#@method
sub run {
    my ($self) = @_;

    my $csv = $self->get_csv();
    my $fh = $self->get_filehandle();

    $csv->say($fh, [qw/concurrency requests_per_second time_per_request transfer_rate max_ram/]);

    my $ab = $self->get_ab();
    my $ram_analyser = $self->get_ram_analyser();
    my $concurency_list = $self->get_concurency();

    foreach my $concurency_value (@{$concurency_list}) {
        $ab->set_concurrency($concurency_value);

        my $ram_analyser_task = $ram_analyser->run_forever();
        my $ab_result = $ab->run_benchmark();
        my $ram_result = $ram_analyser->get_result($ram_analyser_task);

        $csv->say($fh, [
                $concurency_value,
                $ab_result->get_requests_per_second(),
                $ab_result->get_time_per_request(),
                $ab_result->get_transfer_rate(),
                $ram_result,
            ]);
    }

    return 1;
}

#@method
sub get_output_file_name {
    my ($self) = @_;

    return $self->{output_file_name};
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

#@returns Benchmark::AB
#@method
sub get_ab {
    my ($self) = @_;

    return $self->{ab};
}

#@returns Benchmark::RAM
#@method
sub get_ram_analyser {
    my ($self) = @_;

    return $self->{ram_analyser};
}

#@method
sub get_concurency {
    my ($self) = @_;

    return \@{$self->{concurrency}};
}



1;
