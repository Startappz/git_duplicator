require_relative '../helper'

describe GitDuplicator::Duplicator do
  let(:path) { '/somepath' }
  let(:from) do
    double(name: 'somename', bare_clone: nil, mirror: nil, url: 'somewhere1')
  end
  let(:to) { double(delete: nil, create: nil, url: 'somewhere2') }
  let(:duplicator) { GitDuplicator::Duplicator.new(from, to, options) }

  describe '#perform' do
    context 'force_create_destination is set' do
      let(:options) { { clone_path: path, force_create_destination: true } }

      it 'deletes existing destination repo' do
        expect(to).to receive(:delete)
        duplicator.perform
      end

      it 'creates the destination repo' do
        expect(to).to receive(:create)
        duplicator.perform
      end

      it 'bare clones the source repo' do
        expect(from).to receive(:bare_clone).with(path)
        duplicator.perform
      end

      it 'mirrors from bare clone to destination' do
        expect(from).to receive(:mirror).with(to.url)
        duplicator.perform
      end

      it 'cleans up' do
        expect(FileUtils).to receive(:rm_rf)
        .with("#{duplicator.clone_path}/#{from.name}")
        duplicator.perform
      end

      it 'logs 5 times' do
        expect(duplicator.logger).to receive(:info).exactly(5).times
        duplicator.perform
      end
    end

    context 'force_create_destination is false' do
      let(:options) { { clone_path: path } }

      it 'deletes existing destination repo' do
        expect(to).not_to receive(:delete)
        duplicator.perform
      end

      it 'creates the destination repo' do
        expect(to).not_to receive(:create)
        duplicator.perform
      end

      it 'bare clones the source repo' do
        expect(from).to receive(:bare_clone).with(path)
        duplicator.perform
      end

      it 'mirrors from bare clone to destination' do
        expect(from).to receive(:mirror).with(to.url)
        duplicator.perform
      end

      it 'cleans up' do
        expect(FileUtils).to receive(:rm_rf)
        .with("#{duplicator.clone_path}/#{from.name}")
        duplicator.perform
      end

      it 'logs 3 times' do
        expect(duplicator.logger).to receive(:info).exactly(3).times
        duplicator.perform
      end
    end
  end
end
