require_relative '../../helper'

describe GitDuplicator::Services::GithubRepository do
  let(:credentials) do
    { oauth2_token: ENV['GITHUB_ACCESS_TOKEN'] }
  end
  let(:name) { ENV['TESTING_REPO'] }
  let(:owner) { ENV['GITHUB_USER'] }
  let(:remote_options) do
    { has_issues: false, has_wiki: false }
  end
  let(:options) { { credentials: credentials, remote_options: remote_options } }
  let(:repo) { described_class.new(name, owner, options) }

  describe '#delete' do
    it 'deletes the repo in case it exists' do
      stub_request(:delete, described_class::BASE_URI +
                   "/repos/#{owner}/#{name}")
      .with(
        headers: { 'Authorization' => "token #{credentials[:oauth2_token]}" }
      )
      .to_return(body: '', status: 204)
      expect { repo.delete }.not_to raise_error
    end
    it 'raises an exception in case of unknow problem' do
      stub_request(:delete, described_class::BASE_URI +
                   "/repos/#{owner}/#{name}")
      .to_return(body: 'something wrong', status: 401)
      expect { repo.delete }
      .to raise_error(GitDuplicator::RepositoryDeletionError)
    end
  end

  describe '#create' do
    it 'creates the repository in case of not defined' do
      stub_request(:post, described_class::BASE_URI + '/user/repos')
      .with(
        body: remote_options.merge(name: name).to_json,
        headers: { 'Authorization' => "token #{credentials[:oauth2_token]}" }
      )
      .to_return(body: '', status: 201)
      expect { repo.create }.not_to raise_error
    end

    it 'raises an exception in case of errors' do
      stub_request(:post, described_class::BASE_URI + '/user/repos')
      .with(body: remote_options.merge(name: name).to_json)
      .to_return(body: 'something wrong', status: 401)
      expect { repo.create }
      .to raise_error(GitDuplicator::RepositoryCreationError)
    end
  end
end
