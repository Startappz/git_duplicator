require_relative '../helper'

describe GitDuplicator do
  let(:clone_path) { '/tmp' }
  let(:credentials) do
    { consumer_key: ENV['BITBUCKET_CONSUMER_KEY'],
      consumer_secret: ENV['BITBUCKET_CONSUMER_SECRET'],
      token: ENV['BITBUCKET_TOKEN'],
      token_secret: ENV['BITBUCKET_TOKEN_SECRET'] }
  end
  let(:options) { { clone_path: clone_path } }
  let(:from) { GitDuplicator::Repository }
  let(:to) { GitDuplicator::Repository }
  let(:result) { double(perform: nil) }
  describe '#perform' do
    it 'delegates to MirrorDuplicator' do
      expect(GitDuplicator::MirrorDuplicator)
      .to receive(:new).with(from, to, options).and_return(result)
      expect(result).to receive(:perform)
      GitDuplicator.perform(from, to, options)
    end
  end

  describe '#perform_for_update' do
    it 'delegates to UpdateDuplicator' do
      expect(GitDuplicator::UpdateDuplicator)
      .to receive(:new).with(from, to, options).and_return(result)
      expect(result).to receive(:perform)
      GitDuplicator.perform_for_update(from, to, options)
    end
  end
end
