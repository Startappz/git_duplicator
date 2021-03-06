# Git Duplicator

[![Gem Version](https://badge.fury.io/rb/git_duplicator.svg)](http://badge.fury.io/rb/git_duplicator) [![Build Status](https://travis-ci.org/Startappz/git_duplicator.svg?branch=master)](https://travis-ci.org/Startappz/git_duplicator) [![Coverage Status](https://coveralls.io/repos/Startappz/git_duplicator/badge.png?branch=master)](https://coveralls.io/r/Startappz/git_duplicator?branch=master) [![Dependency Status](https://gemnasium.com/Startappz/git_duplicator.svg)](https://gemnasium.com/Startappz/git_duplicator) [![Code Climate](https://codeclimate.com/github/Startappz/git_duplicator/badges/gpa.svg)](https://codeclimate.com/github/Startappz/git_duplicator)


Duplicating git repositories without forking. It depends on the flow described in [this](https://help.github.com/articles/duplicating-a-repository) article.

- [x] Duplicate any repository in two ways: one time usage and frequent updates.
- [x] Additional Github [support](https://github.com/Startappz/git_duplicator/blob/master/lib/git_duplicator/services/github.rb) to create and delete repositories.
- [x] Additional Bibucket [support](https://github.com/Startappz/git_duplicator/blob/master/lib/git_duplicator/services/bitbucket.rb)  to create and delete repositories.

## Installation

Add this line to your application's Gemfile:

    gem 'git_duplicator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_duplicator

## Usage

### Duplicate with no future updates 

Duplicate a repository. Then you can turn off the source repo and move to the mirrored one.

#### Basic usage

It assumes that you have the destination repository initiated. 

```ruby
require 'git_duplicator'

from = GitDuplicator::Repository.new('source repo name', 'source repo url')

to = GitDuplicator::Repository.new('mirrored repo name', 'mirrored repo url')

GitDuplicator.perform(from, to)


```
#### Advanced usage
- You can create the destination repository automatically. This needs you to provide the needed authentication credentials for the script.
- You can set the clone working path locally for the script to work. It's a temporary workplace that will get swiped after finishing.

```ruby
require 'git_duplicator'

from = GitDuplicator::Repository.new('source repo name', 'source repo url')

to = GitDuplicator::Services::GithubRepository.new(
  'mirrored repo name', 'mirrored owner',
  credentials: { oauth2_token: 'some token' },
  remote_options: { has_issues: false, has_wiki: false }
)

GitDuplicator.perform(
  from, to,
  force_create_destination: true,
  clone_path: 'path/to/clone/folder'
)

```
### Duplicate with future updates 

Duplicate a repository. To update your mirror, fetch updates and push, which could be automated by running a cron job.

#### Basic usage

It assumes that you have the destination repository initiated. 

```ruby
require 'git_duplicator'

from = GitDuplicator::Repository.new('source repo name', 'source repo url')

to = GitDuplicator::Repository.new('mirrored repo name', 'mirrored repo url')

GitDuplicator.perform_for_update(from, to)

# Later on if you want to update the mirrored one
local_repo = GitDuplicator::Repository.new(
  'source repo name',
  'source repo url',
  'path/to/working/directory'
)

local_repo.update_mirrored

```
#### Advanced usage
- You can create the destination repository automatically. This needs you to provide the needed authentication credentials for the script.
- You can set the clone working path locally for the script to work. It's a temporary workplace that will get swiped after finishing.

```ruby
require 'git_duplicator'

from = GitDuplicator::Repository.new('source repo name', 'source repo url')

to = GitDuplicator::Services::GithubRepository.new(
  'mirrored repo name',
  'mirrored owner',
  credentials: { oauth2_token: 'some token' },
  remote_options: { has_issues: false, has_wiki: false }
)

GitDuplicator.perform_for_update(
  from, to,
  force_create_destination: true,
  clone_path: 'path/to/clone/folder'
)

# Later on if you want to update the mirrored one
local_repo = GitDuplicator::Repository.new(
  'source repo name',
  'source repo url',
  'path/to/working/directory'
)

local_repo.update_mirrored

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
