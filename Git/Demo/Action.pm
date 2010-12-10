package Git::Demo::Action;
use strict;
use warnings;
use Git::Demo::Action::Git;
use Git::Demo::Action::Print;

sub new{
    my $class = shift;
    my $args = shift;
    foreach( qw/event demo/ ){
        if( ! $args->{$_} ){
            die( "$_ required" );
        }
    }

    if( $args->{event}->type() eq 'git' ){
        return Git::Demo::Action::Git->new( $args );
    }elsif( $args->{event}->type() eq 'print' ){
        return Git::Demo::Action::Print->new( $args );
    }else{
        die( "Unknown event type: " . $args->{event}->type() );
    }
}

sub characters{
    my $self = shift;
    my @characters;
    if( $self->{event}->character() eq 'ALL' ){
        @characters = @{ $self->{demo}->story()->characters() };
    }else{
        push( @characters, $self->{event}->character() );
    }
    return @characters;
}

1;
