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
  requires "perl" => "5.006";
  requires "subs" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Dist::Zilla" => "5";
  requires "Dist::Zilla::Plugin::Authority" => "0";
  requires "Dist::Zilla::Plugin::AutoPrereqs" => "0";
  requires "Dist::Zilla::Plugin::BumpVersionAfterRelease" => "0";
  requires "Dist::Zilla::Plugin::CPANFile" => "0";
  requires "Dist::Zilla::Plugin::CheckMetaResources" => "0";
  requires "Dist::Zilla::Plugin::ConfirmRelease" => "0";
  requires "Dist::Zilla::Plugin::CopyFilesFromBuild" => "0";
  requires "Dist::Zilla::Plugin::ExecDir" => "0";
  requires "Dist::Zilla::Plugin::Git::Check" => "0";
  requires "Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch" => "0";
  requires "Dist::Zilla::Plugin::Git::GatherDir" => "0";
  requires "Dist::Zilla::Plugin::GithubMeta" => "0";
  requires "Dist::Zilla::Plugin::InsertCopyright" => "0";
  requires "Dist::Zilla::Plugin::License" => "0";
  requires "Dist::Zilla::Plugin::MakeMaker" => "0";
  requires "Dist::Zilla::Plugin::Manifest" => "0";
  requires "Dist::Zilla::Plugin::ManifestSkip" => "0";
  requires "Dist::Zilla::Plugin::MetaJSON" => "0";
  requires "Dist::Zilla::Plugin::MetaNoIndex" => "0";
  requires "Dist::Zilla::Plugin::MetaProvides::Package" => "0";
  requires "Dist::Zilla::Plugin::MetaTests" => "0";
  requires "Dist::Zilla::Plugin::MetaYAML" => "0";
  requires "Dist::Zilla::Plugin::MinimumPerl" => "0";
  requires "Dist::Zilla::Plugin::NextRelease" => "0";
  requires "Dist::Zilla::Plugin::OnlyCorePrereqs" => "0";
  requires "Dist::Zilla::Plugin::Pod2Readme" => "0";
  requires "Dist::Zilla::Plugin::PodSyntaxTests" => "0";
  requires "Dist::Zilla::Plugin::Prereqs::AuthorDeps" => "0";
  requires "Dist::Zilla::Plugin::PromptIfStale" => "0";
  requires "Dist::Zilla::Plugin::PruneCruft" => "0";
  requires "Dist::Zilla::Plugin::ReadmeAnyFromPod" => "0";
  requires "Dist::Zilla::Plugin::RewriteVersion" => "0";
  requires "Dist::Zilla::Plugin::RunExtraTests" => "0";
  requires "Dist::Zilla::Plugin::ShareDir" => "0";
  requires "Dist::Zilla::Plugin::Test::MinimumVersion" => "0";
  requires "Dist::Zilla::Plugin::Test::Portability" => "0";
  requires "Dist::Zilla::Plugin::Test::ReportPrereqs" => "0";
  requires "Dist::Zilla::Plugin::Test::Version" => "0";
  requires "Dist::Zilla::Plugin::TestRelease" => "0";
  requires "Dist::Zilla::Plugin::UploadToCPAN" => "0";
  requires "Software::License::FreeBSD" => "0";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::Kwalitee" => "0";
  requires "Test::MinimumVersion" => "0";
  requires "Test::More" => "0";
  requires "Test::Perl::Critic" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Portability::Files" => "0";
  requires "Test::Version" => "1";
  requires "autodie" => "0";
};
