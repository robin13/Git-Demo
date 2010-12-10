package Git::Demo;
use strict;
use warnings;
use Git::Repository;
use Git::Demo::Story;
use Git::Demo::Action;

use Log::Log4perl;
use File::Util;
use IO::File;
use File::Temp;

sub new{
    my $class = shift;
    my $conf = shift;

    foreach( qw/story_file/ ){
        if( ! $conf->{$_} ){
            die( "Cannot start without $_ being defined\n" );
        }
    }

    my $self = {};
    $self->{conf} = $conf;
    my $logger = Log::Log4perl->get_logger( "Git::Demo::Story" );
    $self->{logger} = $logger;

    $self->{dir} = File::Temp->newdir( UNLINK => 1 );

    if( ! $self->{dir} ){
        die( "Could not create temporary directory to work in" );
    }
    $logger->info( "Working directory: $self->{dir}" );
    $self->{story} = Git::Demo::Story->new( { story_file => $conf->{story_file},
                                              dir        => $self->{dir} } );

    bless $self, $class;

    return $self;
}

sub play{
    my $self = shift;
    if( ! $self->{story} ){
        warn( "No story to play!" );
        return undef;
    }
    $self->{story}->play();
}


sub story{
    my $self = shift;
    return $self->{story};
}

sub save_story{
    my $self = shift;
    if( $self->{story} ){
        $self->{story}->save_story();
    }
}

sub dir{
    my $self = shift;
    return $self->{dir};
}

sub pause{
    my $self = shift;
    if( $self->{no_pause} ){
        return;
    }
    print "Continue?";
    my $in = <STDIN>
}
1;
