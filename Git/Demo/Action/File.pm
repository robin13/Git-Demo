package Git::Demo::Action::File;
use strict;
use warnings;
use File::Spec::Functions;

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
    my( $self, $character, $event ) = @_;
    my $logger = $self->{logger};
    if( $event->action() eq 'touch' ){
        $self->_touch( $character, $event );
    }elsif( $event->action() eq 'append' ){
        $self->_append( $character, $event );
    }else{
        die( "Unknown action: " . $event->action() );
    }
}


sub _touch{
    my( $self, $character, $event ) = @_;
    my $logger = $self->{logger};
    foreach my $arg( @{ $event->args() } ){
        my $path = catfile( $character->dir(), $arg );
        $logger->debug( "touching: $path" );
        if( ! open( FH, ">", $path ) ){
            die( "Could not open file ($path): $!" );
        }
        close FH;
    }
}

sub _append{
    my( $self, $character, $event ) = @_;
    my $logger = $self->{logger};
    my @args = @{ $event->args() };
    if( scalar( @args ) != 2 ){
        die( "Incorrect number of arguments" );
    }
    my $path = catfile( $character->dir(), $args[0] );
    my $text = $args[1];

    # Some text replacements
    my $name = $character->name();
    my $date = '' . localtime();
    $text =~ s/\[% NAME %\]/$name/g;
    $text =~ s/\[% DATE %\]/$date/g;

    $logger->debug( "appending to: $path" );
    if( ! open( FH, ">>", $path ) ){
        die( "Could not open file ($path): $!" );
    }
    print FH $text . "\n";
    close FH;
}

1;
