package Git::Demo::Action::File;
use strict;
use warnings;
use File::Spec::Functions;
use File::Util;
use File::Basename;

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

sub _copy{
    my( $self, $character, $event ) = @_;
    my $logger = $self->{logger};

    my @args = @{ $event->args() };
    if( scalar( @args ) < 2 ){
        die( "need at least two paths for a copy" );
    }

    my $target_rel = pop( @args );
    my $target_abs = catdir( $character->dir(), $target_rel );

    # If there are more than one file to copy, the target must be a directory
    if( scalar( @args ) > 1 && -f $target_abs ){
        die( "Cannot copy multiple files to one target" );
    }
    if( ! -d $target_abs ){
        my $f = File::Util->new();
        if( ! $f->make_dir( $target_abs ) ){
            die( "Could not create dir ($target_abs): $!" );
        }
    }

    foreach my $path( @args ){
        my $source_path = catfile( $character->dir(), $path );
        my $target_path = undef;
        if( scalar( @args ) > 1 ){
            $target_path = catfile( $target_abs, fileparse( $source_path ) );
        }else{
            $target_path = $target_abs;
        }
        if( -f $source_path ){
            if( ! rename( $source_path, $target_path ) ){
                die( "Could not reanme from $source_path to $target_path: $!" );
            }
        }else{
            warn( "File does not exist: $source_path\n" );
        }
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
