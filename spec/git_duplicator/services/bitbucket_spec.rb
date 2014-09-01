require_relative '../../helper'

describe GitDuplicator::Services::BitbucketRepository do
  let(:credentials) do
    { consumer_key: ENV['BITBUCKET_CONSUMER_KEY'],
      consumer_secret: ENV['BITBUCKET_CONSUMER_SECRET'],
      token: ENV['BITBUCKET_TOKEN'],
      token_secret: ENV['BITBUCKET_TOKEN_SECRET'] }
  end
  let(:name) { ENV['TESTING_REPO'] }
  let(:owner) { ENV['BITBUCKET_USER'] }
  let(:remote_options) do
    { scm: 'git', is_private: true, fork_policy: 'no_public_forks' }
  end
  let(:options) { { credentials: credentials, remote_options: remote_options } }
  let(:repo) { described_class.new(name, owner, options) }

  describe '#delete' do
    it 'deletes the repo in case it exists' do
      stub_request(:delete, described_class::BASE_URI +
                   "/repositories/#{owner}/#{name}")
      .to_return(body: '', status: 204)
      expect { repo.delete }.not_to raise_error
    end
    it 'raises an exception in case of unknow problem' do
      stub_request(:delete, described_class::BASE_URI +
                   "/repositories/#{owner}/#{name}")
      .to_return(body: 'something wrong', status: 401)
      expect { repo.delete }
      .to raise_error(GitDuplicator::RepositoryDeletionError, /something wrong/)
    end
  end

  describe '#create' do
    it 'creates the repository in case of not defined' do
      stub_request(:post, described_class::BASE_URI +
                   "/repositories/#{owner}/#{name}")
      .with(body: remote_options.to_json)
      .to_return(body: '', status: 200)
      expect { repo.create }.not_to raise_error
    end

    it 'raises an exception in case of errors' do
      stub_request(:post, described_class::BASE_URI +
                   "/repositories/#{owner}/#{name}")
      .with(body: remote_options.to_json)
      .to_return(body: 'something wrong', status: 401)
      expect { repo.create }
      .to raise_error(GitDuplicator::RepositoryCreationError, /something wrong/)
    end
  end
end
