# Git Duplicator

[![Gem Version](https://badge.fury.io/rb/git_duplicator.svg)](http://badge.fury.io/rb/git_duplicator) [![Build Status](https://travis-ci.org/Startappz/git_duplicator.svg?branch=master)](https://travis-ci.org/Startappz/git_duplicator) [![Coverage Status](https://coveralls.io/repos/Startappz/git_duplicator/badge.png?branch=master)](https://coveralls.io/r/Startappz/git_duplicator?branch=master) [![Dependency Status](https://gemnasium.com/Startappz/git_duplicator.svg)](https://gemnasium.com/Startappz/git_duplicator) [![Code Climate](https://codeclimate.com/github/Startappz/git_duplicator/badges/gpa.svg)](https://codeclimate.com/github/Startappz/git_duplicator)


Duplicating git repositories without forking.

- [x] Duplicate any repository
- [x] Additional Github support
- [x] Additional Bibucket support

## Installation

Add this line to your application's Gemfile:

    gem 'git_duplicator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_duplicator

## Usage

### Basic usage

Duplicate a repository. It assumes that you have the destination repository initiated. 

```ruby
require 'git_duplicator'
from = GitDuplicator::Repository
.new('source repo name', 'source repo url')
to = GitDuplicator::Repository
.new('destination repo name', 'destination repo url')
GitDuplicator.perform(from, to)

```
### Advanced usage
- You can create the destination repository automatically. This needs you to provide the needed authentication credentials for the script.
- You can set the clone working path locally for the script to work. It's a temporary workplace that will get swiped after finishing.

```ruby
require 'git_duplicator'
from = GitDuplicator::Repository
.new('source repo name', 'source repo url')
to = GitDuplicator::Services::GithubRepository
.new('destination repo name', 'destination owner', {auth2_token: 'some token'})
GitDuplicator.perform(from, to, force_create_destination: true, clone_path: 'path/to/tmp')
```

### Available Services

The script works with any repository that you have access to. However, right now, there are 2 services that are implemented to help you initiate an empty destination repository. That way, you don't need to create them manaullay before doing the duplicaton. The services are Github and Bitbucket.

### Adding new Services

Adding new service, if needed, should be straight forward. You can look at the source of the Bitbucket or Github services implementations, where they inherit a base abstract class that you need to inherit as well.

### Running tests

To be able to run the tests, specially the acceptance ones, you need to rename the `.test.env.example` to `.test.env` and add the needed credentials for your accounts.


## Contributing

1. Fork it ( https://github.com/Startappz/git_duplicator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
