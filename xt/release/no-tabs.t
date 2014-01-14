use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.06

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/App/Nopaste.pm',
    'lib/App/Nopaste/Command.pm',
    'lib/App/Nopaste/Service.pm',
    'lib/App/Nopaste/Service/Codepeek.pm',
    'lib/App/Nopaste/Service/Debian.pm',
    'lib/App/Nopaste/Service/Gist.pm',
    'lib/App/Nopaste/Service/PastebinCom.pm',
    'lib/App/Nopaste/Service/Pastie.pm',
    'lib/App/Nopaste/Service/Shadowcat.pm',
    'lib/App/Nopaste/Service/Snitch.pm',
    'lib/App/Nopaste/Service/Ubuntu.pm',
    'lib/App/Nopaste/Service/ssh.pm',
    'script/nopaste'
);

notabs_ok($_) foreach @files;
done_testing;
