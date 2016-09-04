package Benchmark::RAM;

use strict;
use warnings FATAL => 'all';
use Carp;
use threads;
use Benchmark::RAM::Result;


sub new {
    my ($class, %kwargs) = @_;

    for (qw/uri processes_mask/) {
        Carp::confess(sprintf("[!] Missing required argument '%s", $_)) unless (defined $kwargs{$_});
    }

    return bless(\%kwargs, $class);
}

#@method
sub run_forever {
    my ($self) = @_;

    my $command = sprintf("ssh -o LogLevel=QUIET -t -t %s top -w 160 -b -n 1 | grep -E '%s' | awk '{total += (\$6 - \$7)} END {print total/1024}'"
        ,$self->get_uri()
        ,$self->get_processes_mask()
    );

    my $task_ref = $self->can('_task');

    my threads $t = threads->create(
        {context => 'scalar'},
        $task_ref,
        $command,
    );

#    $t->join();

    return $t;
}

#@method
sub get_uri {
    my ($self) = @_;

    my $result = [split('/', $self->{uri})]->[0];
    $result = [split(':', $result)]->[0];

    return $result;
}

#@method
sub get_processes_mask {
    my ($self) = @_;

    return $self->{processes_mask};
}

#@method
sub _task {
    my ($command) = @_;

    my ($do, $max) = (1, 0);

    $SIG{KILL} = sub { $do = 0; };

    while ($do) {
        my $out = `$command`;
        my $result = Benchmark::RAM::Result->new($out);
        my $ram_used = $result->get_value();
        $max = $ram_used if ($ram_used > $max);
        sleep(1);
    }

    return $max;
}

#@method
sub get_result {
    my threads $t = $_[1];

    $t->kill('KILL')->join();
}

1;
