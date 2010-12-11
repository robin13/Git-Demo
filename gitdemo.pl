#!/usr/bin/perl
use strict;
use warnings;
use Log::Log4perl;
use Git::Demo;
use YAML::Any qw/LoadFile/;

my $conf = LoadFile( 'config.yaml' );
Log::Log4perl->init( 'log4perl.conf' );
my $logger = Log::Log4perl->get_logger( 'gitdemo' );

my $demo = Git::Demo->new( $conf );
$demo->play();
$logger->debug( "Test before warning" );
warn( "This is a warning!" );
my $in = <STDIN>;


