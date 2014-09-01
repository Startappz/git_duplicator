require_relative '../../helper'

describe GitDuplicator::UpdateDuplicator do
  let(:path) { '/somepath' }
  let(:from) do
    double(name: 'somename', mirror_clone: nil, set_mirrored_remote: nil,
           update_mirrored: nil, url: 'somewhere1')
  end
  let(:options) { { clone_path: path, force_create_destination: true } }
  let(:to) { double(delete: nil, create: nil, url: 'somewhere2') }
  let(:duplicator) { described_class.new(from, to, options) }

  describe '#clone_source' do
    it 'bare clones the source repo' do
      expect(from).to receive(:mirror_clone).with(path)
      duplicator.perform
    end
  end

  describe '#mirror' do
    it 'sets the remote for push' do
      expect(from).to receive(:set_mirrored_remote).with(to.url)
      duplicator.perform
    end

    it 'mirrors from mirror clone to destination' do
      expect(from).to receive(:update_mirrored)
      duplicator.perform
    end
  end

  describe '#clean_up' do
    it 'mirrors from bare clone to destination' do
      expect(duplicator.perform).to be_nil
    end
  end
end
