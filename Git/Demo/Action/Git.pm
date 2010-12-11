package Git::Demo::Action::Git;
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

    # Git output is slung to warn... catch and deal with warnings a bit better!
    local $SIG{__WARN__} = sub
      {
          foreach( @_ ){
              if( m/^fatal:/ ){
                  die( "$_\n" );
              }elsif( m/^git:/ ){
                  warn( "$_\n" );
              }else{
                  # Other git output
                  print "Git warning: $_\n";
              }
          }
      };

    my $git = $character->git();
    my @cmd = $event->action();
    push( @cmd, @{ $event->args() } );
    $self->{logger}->debug( sprintf( "%10s : %s# git %s", $character->name(), $character->dir(), join( ' ', @cmd ) ) );
    return $git->run( @cmd ) . "\n";
}


1;
