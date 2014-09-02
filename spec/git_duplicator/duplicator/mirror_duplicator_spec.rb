require_relative '../../helper'

module GitDuplicator
  describe MirrorDuplicator do
    let(:path) { '/somepath' }
    let(:from) do
      double(name: 'somename', bare_clone: nil, mirror: nil, url: 'somewhere1')
    end
    let(:options) { { clone_path: path, force_create_destination: true } }
    let(:to) { double(delete: nil, create: nil, url: 'somewhere2') }
    let(:duplicator) { described_class.new(from, to, options) }

    describe '#clone_source' do
      it 'bare clones the source repo' do
        expect(from).to receive(:bare_clone).with(path)
        duplicator.perform
      end
    end

    describe '#mirror' do
      it 'mirrors from bare clone to destination' do
        expect(from).to receive(:mirror).with(to.url)
        duplicator.perform
      end
    end

    describe '#clean_up' do
      it 'mirrors from bare clone to destination' do
        expect(FileUtils).to receive(:rm_rf)
        .with("#{duplicator.clone_path}/#{from.name}")
        duplicator.perform
      end
    end
  end
end
