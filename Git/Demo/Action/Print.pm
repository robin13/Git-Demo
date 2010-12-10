package Git::Demo::Action::Print;
use strict;
use warnings;

sub new{
    my $class = shift;
    my $args = shift;

    my $self = {};
    my $logger = Log::Log4perl->get_logger( __PACKAGE__ );
    $self->{logger} = $logger;

    bless $self, $class;
    return $self;
}

sub run{
    my $self = shift;
    warn( __PACKAGE__ . "->execute not implemented yet!\n" );
}


1;
