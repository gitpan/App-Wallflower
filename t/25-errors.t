use strict;
use warnings;
use Test::More;
use File::Temp qw( tempdir );
use File::Spec;
use App::Wallflower;

my $dir = tempdir( CLEANUP => 1 );
my $file = File::Spec->catfile( $dir, 'uggh' );
{
    open my $fh, '>', $file or die "Can't open $file for writing: $!";
    close $fh;
}

# setup test data
my @tests_new = (
    [ [], 'no arguments' => qr/^application is required / ],
    [   [   application => 'dummy',
            destination => File::Spec->catdir( $dir, 'bap' ),
        ],
        'non-existing destination' => qr/^destination is invalid /,
    ],
    [   [   application => 'dummy',
            destination => $file,
        ],
        'non-directory destination' => qr/^destination is invalid /,
    ],
);

my @tests_get = (
    [   [ application => sub { {} }, destination => $dir ],
        'app that returns a HASHREF',
        qr/^Unknown response from application: HASH\(0x[0-9a-f]+\) /,
    ],
    [   [ application => sub { sub {} }, destination => $dir ],
        'app that returns a CODEREF',
        qr/^Delayed response and streaming not supported yet /,
    ],
    [   [ application => sub { [ 200, [], {} ] }, destination => $dir ],
        'app that returns a bad body',
        qr/^Don't know how to handle body: HASH\(0x[0-9a-f]+\) /,
    ],
);

plan tests => 2 * @tests_new + 3 * @tests_get;

for my $t (@tests_new) {
    my ( $args, $desc, $re ) = @$t;

    my $wf = eval { App::Wallflower->new(@$args); };
    is( $wf, undef, "new( $desc ) failed" );
    like( $@, $re, "expected error message for $desc" );
}

for my $t (@tests_get) {
    my ( $args, $desc, $re ) = @$t;

    my $wf = eval { App::Wallflower->new(@$args); };
    isa_ok( $wf, 'App::Wallflower', "new( $desc )" );
    ok( !eval { $wf->get('/'); }, "($desc)->get failed" );
    like( $@, $re, "expected error message for $desc" );
}

