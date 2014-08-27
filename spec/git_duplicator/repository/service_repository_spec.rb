require_relative '../../helper'

describe GitDuplicator::ServiceRepository do
  let(:name) { 'something' }
  let(:owner) { 'someone' }
  let(:repo) { described_class.new(name, owner) }

  describe '#delete' do
    it 'raises an exception in case of not defined' do
      expect { repo.delete }.to raise_error(NotImplementedError)
    end
  end

  describe '#create' do
    it 'raises an exception in case of not defined' do
      expect { repo.create }.to raise_error(NotImplementedError)
    end
  end

  describe '#url' do
    it 'raises an exception in case of not defined' do
      expect { repo.url }.to raise_error(NotImplementedError)
    end
  end
end
