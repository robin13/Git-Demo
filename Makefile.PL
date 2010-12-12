use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Git::Demo',
    AUTHOR              => q{Robin Clarke <rcl@cpan.org>},
    VERSION_FROM        => 'lib/Git/Demo.pm',
    ABSTRACT_FROM       => 'lib/Git/Demo.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Git-Demo-*' },
);
