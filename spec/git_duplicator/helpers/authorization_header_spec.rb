require_relative '../../helper'

describe GitDuplicator::Helpers::AuthorizationHeader do
  let(:credentials) { { username: 'user', password: 'password' } }
  let(:request) { { method: :post, url: 'onetwo' } }
  let(:header) { described_class.new(credentials, request) }
  
  describe '#basic_authenticaion_header' do
    it 'should have the right value' do
      result = header.send :basic_authenticaion_header
      encode64 = Base64.encode64("#{credentials[:username]}" \
                        ":#{credentials[:password]}")
      expect(result).to eq("Basic #{encode64}")
    end
  end

  describe '#basic_authenticaion_header' do
    it 'should have the right value' do
      result = header.send :base64_username_password
      encode64 = Base64.encode64("#{credentials[:username]}" \
                        ":#{credentials[:password]}")
      expect(result).to eq(encode64)
    end
  end
end
