require_relative '../../helper'

describe GitDuplicator::Repository do
  let(:path) { 'somepath' }
  let(:name) { 'something' }
  let(:url) { 'someurl' }
  let(:to_url) { 'someurl' }
  let(:repo) { described_class.new(name, url) }

  # describe '#working_directory=' do
  #   it 'assignes the attribute' do
  #     val = 'somepath'
  #     repo.working_directory = val
  #     expect(repo.working_directory).to eq(val)
  #   end

  #   it 'assignes the repo attribute' do
  #     val = 'somepath'
  #     repo.working_directory = val
  #     expect(repo.working_directory).to eq(val)
  #   end

  # end

  describe '#bare_clone' do
    it 'clones a repo' do
      expect(Git).to receive(:clone).with(url, name, path: path, bare: true)
      repo.bare_clone(path)
    end

    it 'raises an exception in case of failure' do
      expect { repo.bare_clone('') }
      .to raise_error(GitDuplicator::RepositoryCloningError)
    end
  end

  describe '#mirror_clone' do
    it 'clones a repo' do
      allow(Git).to receive(:bare)
      wd = File.join(path, repo.name)
      expect(repo).to receive(:command).with('clone', '--mirror', repo.url, wd)
      repo.mirror_clone(path)
    end

    it 'raises an exception in case of failure' do
      expect { repo.mirror_clone('') }
      .to raise_error(GitDuplicator::RepositoryCloningError)
    end
  end

  describe '#mirror' do
    it 'mirrors a repo' do
      repo.send(:repo=, Git::Base.new)
      expect(repo.send(:repo)).to receive(:push).with(to_url, '--mirror')
      repo.mirror(to_url)
    end

    it 'raises an exception in case of failure' do
      expect { repo.mirror('') }
      .to raise_error(GitDuplicator::RepositoryMirorringError)
    end
  end

  describe '#update_mirrored' do

    it 'fetchs and pushes data' do
      repo.send(:repo=, Git::Base.new)
      expect(repo).to receive(:command).with('fetch', '-p', 'origin')
      expect(repo).to receive(:command).with('push', '--mirror')
      repo.update_mirrored
    end

    it 'raises an exception in case of failure' do
      expect { repo.update_mirrored }
      .to raise_error(GitDuplicator::RepositoryMirorredUpdatingError)
    end
  end

  describe '#set_mirrored_remote' do
    it 'sets mirrored as remote' do
      repo.send(:repo=, Git::Base.new)
      expect(repo).to receive(:command)
      .with('remote', 'set-url', '--push', 'origin', to_url)
      repo.set_mirrored_remote(to_url)
    end

    it 'raises an exception in case of failure' do
      expect { repo.set_mirrored_remote('') }
      .to raise_error(GitDuplicator::RepositorySettingRemoteError)
    end
  end
end
