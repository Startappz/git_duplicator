require_relative '../helper'

def random_name
  rand(36**5).to_s(36)
end

describe GitDuplicator do
  before(:each) { WebMock.allow_net_connect! }
  let(:clone_path) { '/tmp' }

  describe '#perform' do

    let(:credentials) do
      { consumer_key: ENV['BITBUCKET_CONSUMER_KEY'],
        consumer_secret: ENV['BITBUCKET_CONSUMER_SECRET'],
        token: ENV['BITBUCKET_TOKEN'],
        token_secret: ENV['BITBUCKET_TOKEN_SECRET'] }
    end

    it 'mirrors from service to service without ' \
    'force_create_destination option' do
      # Setup
      from = GitDuplicator::Services::GithubRepository
      .new('naught', 'avdi')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], credentials)
      to.create
      GitDuplicator.perform(from, to, clone_path: clone_path)
      mirrored_name = random_name
      result_name = random_name

      # Exercise
      mirrored = Git.clone(from.url, mirrored_name, path: clone_path)
      result = Git.clone(from.url, result_name, path: clone_path)

      # Verify
      expect(result.object('HEAD^').to_s).to eq(mirrored.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      FileUtils.rm_rf("#{clone_path}/#{result_name}")
      to.delete
    end

    it 'mirrors from service to service with ' \
    'force_create_destination option' do
      # Setup
      from = GitDuplicator::Services::GithubRepository
      .new('naught', 'avdi')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], credentials)
      GitDuplicator.perform(from, to,
                            clone_path: clone_path,
                            force_create_destination: true)
      mirrored_name = random_name
      result_name = random_name

      # Exercise
      mirrored = Git.clone(from.url, mirrored_name, path: clone_path)
      result = Git.clone(from.url, result_name, path: clone_path)

      # Verify
      expect(result.object('HEAD^').to_s).to eq(mirrored.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      FileUtils.rm_rf("#{clone_path}/#{result_name}")
      to.delete
    end

    it 'mirrors from basic to service with ' \
    'force_create_destination option' do
      # Setup
      from = GitDuplicator::Repository
      .new('naught', 'https://github.com/avdi/naught.git')
      to = GitDuplicator::Services::BitbucketRepository
      .new(ENV['TESTING_REPO'], ENV['BITBUCKET_USER'], credentials)
      GitDuplicator.perform(from, to,
                            clone_path: clone_path,
                            force_create_destination: true)
      mirrored_name = random_name
      result_name = random_name

      # Exercise
      mirrored = Git.clone(from.url, mirrored_name, path: clone_path)
      result = Git.clone(from.url, result_name, path: clone_path)

      # Verify
      expect(result.object('HEAD^').to_s).to eq(mirrored.object('HEAD^').to_s)

      # Teardown
      FileUtils.rm_rf("#{clone_path}/#{mirrored_name}")
      FileUtils.rm_rf("#{clone_path}/#{result_name}")
      to.delete
    end

  end

end
