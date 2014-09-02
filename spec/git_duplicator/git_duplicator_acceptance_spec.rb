require_relative '../helper'

def random_name
  rand(36**5).to_s(36)
end

describe GitDuplicator do
  before(:each) { WebMock.allow_net_connect! }
  let(:clone_path) { '/tmp' }
  let(:credentials) do
    { consumer_key: ENV['BITBUCKET_CONSUMER_KEY'],
      consumer_secret: ENV['BITBUCKET_CONSUMER_SECRET'],
      token: ENV['BITBUCKET_TOKEN'],
      token_secret: ENV['BITBUCKET_TOKEN_SECRET'] }
  end
  let(:options) { { credentials: credentials } }

  describe '#perform' do
    it 'mirrors from service to service without ' \
    'force_create_destination option' do
      skip
      # Setup
      from = GitDuplicator::Services::GithubRepository
      .new('naught', 'avdi')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], options)
      to.create
      GitDuplicator.perform(from, to, clone_path: clone_path)
      source_name = random_name
      mirrored_name = random_name

      # Exercise
      source = Git.clone(from.url, source_name, path: clone_path)
      mirrored = Git.clone(to.url, mirrored_name, path: clone_path)

      # Verify
      expect(mirrored.object('HEAD^').to_s).to eq(source.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{source_name}")
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      to.delete
    end

    it 'mirrors from service to service with ' \
    'force_create_destination option' do
      skip
      # Setup
      from = GitDuplicator::Services::GithubRepository
      .new('naught', 'avdi')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], options)
      GitDuplicator.perform(from, to,
                            clone_path: clone_path,
                            force_create_destination: true)
      source_name = random_name
      mirrored_name = random_name

      # Exercise
      source = Git.clone(from.url, source_name, path: clone_path)
      mirrored = Git.clone(to.url, mirrored_name, path: clone_path)

      # Verify
      expect(mirrored.object('HEAD^').to_s).to eq(source.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{source_name}")
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      to.delete
    end

    it 'mirrors from basic to service with ' \
    'force_create_destination option' do
      skip
      # Setup
      from = GitDuplicator::Repository
      .new('naught', 'https://github.com/avdi/naught.git')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], options)
      GitDuplicator.perform(from, to,
                            clone_path: clone_path,
                            force_create_destination: true)
      source_name = random_name
      mirrored_name = random_name

      # Exercise
      source = Git.clone(from.url, source_name, path: clone_path)
      mirrored = Git.clone(to.url, mirrored_name, path: clone_path)

      # Verify
      expect(mirrored.object('HEAD^').to_s).to eq(source.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{source_name}")
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      to.delete
    end
  end

  describe '#perform_for_updates' do
    it 'mirrors from service to service without ' \
    'force_create_destination option' do
      skip
      # Setup
      from = GitDuplicator::Services::GithubRepository
      .new('naught', 'avdi')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], options)
      to.create
      GitDuplicator.perform_for_update(from, to, clone_path: clone_path)
      source_name = from.name
      mirrored_name = random_name

      # Exercise
      source = Git.bare("#{clone_path}/#{source_name}")
      mirrored = Git.clone(to.url, mirrored_name, path: clone_path)

      # Verify
      expect(mirrored.object('HEAD^').to_s).to eq(source.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{source_name}")
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      to.delete
    end

    it 'mirrors from service to service with ' \
    'force_create_destination option' do
      skip
      # Setup
      from = GitDuplicator::Services::GithubRepository
      .new('naught', 'avdi')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], options)
      GitDuplicator.perform_for_update(from, to,
                                       clone_path: clone_path,
                                       force_create_destination: true)
      source_name = from.name
      mirrored_name = random_name

      # Exercise
      source = Git.bare("#{clone_path}/#{source_name}")
      mirrored = Git.clone(to.url, mirrored_name, path: clone_path)

      # Verify
      expect(mirrored.object('HEAD^').to_s).to eq(source.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{source_name}")
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      to.delete
    end

    it 'mirrors from basic to service with ' \
    'force_create_destination option' do
      skip
      # Setup
      from = GitDuplicator::Repository
      .new('naught', 'https://github.com/avdi/naught.git')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], options)
      GitDuplicator.perform_for_update(from, to,
                                       clone_path: clone_path,
                                       force_create_destination: true)
      source_name = from.name
      mirrored_name = random_name

      # Exercise
      source = Git.bare("#{clone_path}/#{source_name}")
      mirrored = Git.clone(to.url, mirrored_name, path: clone_path)

      # Verify
      expect(mirrored.object('HEAD^').to_s).to eq(source.object('HEAD^').to_s)

      local_repo = GitDuplicator::Repository.new(
        'naught',
        'https://github.com/avdi/naught.git',
        "#{clone_path}/#{source_name}"
      )
      local_repo.update_mirrored

      #Teardown
      FileUtils.rm_rf("#{clone_path}/#{source_name}")
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      to.delete
    end
  end
end
