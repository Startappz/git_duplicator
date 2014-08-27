# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_duplicator/version'

Gem::Specification.new do |gem|
  gem.name          = "git_duplicator"
  gem.version       = GitDuplicator::Version
  gem.authors       = ["Khaled alHabache"]
  gem.email         = ["khellls@gmail.com"]
  gem.summary       = %q{Duplicating git repositories withou forking.}
  gem.description   = %q{Duplicating git repositories withou forking.}
  gem.homepage      = "https://github.com/Startappz/git_duplicator"
  gem.license       = 'LGPL-3'
  gem.required_ruby_version = '>= 1.9.3'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files = Dir.glob('gem/**/*')
  gem.require_paths = ['lib']
  gem.add_dependency 'http', '~> 0.6'
  gem.add_dependency 'git', '~> 1.2'
  gem.add_dependency 'simple_oauth', '~> 0.2'
end
