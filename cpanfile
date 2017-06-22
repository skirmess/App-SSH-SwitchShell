requires "Cwd" => "0";
requires "English" => "0";
requires "File::Spec" => "0";
requires "perl" => "5.006";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Capture::Tiny" => "0";
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "Test::MockModule" => "0";
  requires "Test::More" => "0";
  requires "Test::TempDir::Tiny" => "0";
  requires "autodie" => "0";
  requires "subs" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Test::Kwalitee" => "0";
  requires "Test::MinimumVersion" => "0";
  requires "Test::More" => "0";
  requires "Test::Perl::Critic" => "0";
  requires "autodie" => "0";
};
