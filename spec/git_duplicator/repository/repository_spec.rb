require_relative '../../helper'

describe GitDuplicator::Repository do
  let(:path) { 'somepath' }
  let(:name) { 'something' }
  let(:url) { 'someurl' }
  let(:to_url) { 'someurl' }
  let(:repo) { described_class.new(name, url) }

  describe '#repo=' do
    it 'assignes the attribute in case of Git::Base type' do
      val = Git::Base.new
      repo.repo = val
      expect(repo.repo).to eq(val)
    end

    it 'raise ArgumentError in case the attribute type is not Git::Base' do
      expect { repo.repo = 1 }.to raise_error(TypeError)
    end
  end

  describe '#bare_clone' do
    before(:each) { allow(repo).to receive(:repo=) }
    it 'clones a repo' do
      expect(Git).to receive(:clone).with(url, name, path: path, bare: true)
      repo.bare_clone(path)
    end

    it 'raises an exception in case of failure' do
      expect { repo.bare_clone('') }
      .to raise_error(GitDuplicator::RepositoryCloningError)
    end
  end

  describe '#mirror' do
    it 'mirrors a repo' do
      repo.repo = Git::Base.new
      expect(repo.repo).to receive(:push).with(to_url, '--mirror')
      repo.mirror(to_url)
    end

    it 'raises an exception in case of failure' do
      expect { repo.mirror('') }
      .to raise_error(GitDuplicator::RepositoryMirorringError)
    end
  end
end
