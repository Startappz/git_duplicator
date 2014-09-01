require_relative '../../helper'

describe GitDuplicator::Duplicator do
  let(:path) { '/somepath' }
  let(:from) do
    double(name: 'somename', bare_clone: nil, mirror: nil, url: 'somewhere1')
  end
  let(:to) { double(delete: nil, create: nil, url: 'somewhere2') }
  let(:duplicator) { described_class.new(from, to, options) }

  describe '#perform_mirror' do
    let(:options) { {} }
    it 'raises an exception in case of not defined' do
      expect { duplicator.perform_mirror }
      .to raise_error(NotImplementedError)
    end
  end

  describe '#perform_clone_source' do
    let(:options) { {} }
    it 'raises an exception in case of not defined' do
      expect { duplicator.perform_clone_source }
      .to raise_error(NotImplementedError)
    end
  end

  describe '#perform_clean_up' do
    let(:options) { {} }
    it 'raises an exception in case of not defined' do
      expect { duplicator.perform_clean_up }
      .to raise_error(NotImplementedError)
    end
  end

  describe '#perform' do
    before do
      allow(duplicator).to receive(:perform_clone_source)
      allow(duplicator).to receive(:perform_mirror)
      allow(duplicator).to receive(:perform_clean_up)
    end
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

      it 'clones the source repo' do
        expect(duplicator).to receive(:clone_source)
        duplicator.perform
      end

      it 'mirrors to destination' do
        expect(duplicator).to receive(:mirror)
        duplicator.perform
      end

      it 'cleans up' do
        expect(duplicator).to receive(:clean_up)
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

      it 'clones the source repo' do
        expect(duplicator).to receive(:clone_source)
        duplicator.perform
      end

      it 'mirrors to destination' do
        expect(duplicator).to receive(:mirror)
        duplicator.perform
      end

      it 'cleans up' do
        expect(duplicator).to receive(:clean_up)
        duplicator.perform
      end

      it 'logs 3 times' do
        expect(duplicator.logger).to receive(:info).exactly(3).times
        duplicator.perform
      end
    end
  end
end
