
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Sorry I can't dance, I'm hanging on to my friend's purse",
  "AUTHOR" => "Philippe Bruhat (BooK) <book\@cpan.org>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Spec" => 0,
    "File::Temp" => 0,
    "List::Util" => 0,
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "App-Wallflower",
  "EXE_FILES" => [
    "bin/wallflower"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::Wallflower",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Exporter" => 0,
    "Getopt::Long" => 0,
    "HTML::LinkExtor" => 0,
    "HTTP::Date" => 0,
    "HTTP::Headers" => 0,
    "Path::Class" => 0,
    "Plack::Util" => 0,
    "Pod::Find" => 0,
    "Pod::Usage" => 0,
    "URI" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "1.004",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



