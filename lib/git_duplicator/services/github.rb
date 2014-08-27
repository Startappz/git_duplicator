require 'http'
require_relative '../helpers/authorization_header'

module GitDuplicator
  module Services
    class GithubRepository < ServiceRepository
      BASE_URI = 'https://api.github.com'

      attr_accessor :credentials, :options

      # Initializer
      # @param [String] name name of the repository
      # @param [String] owner owner of the repository
      # @param [Hash] credentials
      # @option credentials [Symbol] :oauth2_token used in oAuth2 authentication
      # @option credentials [Symbol] :username used in basic authentication
      # @option credentials [Symbol] :password used in basic authentication
      # @param [Hash] options options for creation
      # @see https://developer.github.com/v3/repos/#create
      def initialize(name, owner, credentials = {}, options = {})
        super(name, owner)
        self.credentials = credentials
        self.options = options
      end

      # URL of the repositroy
      def url
        "git@github.com:#{owner}/#{name}.git"
      end

      # Create the repository
      # @see https://developer.github.com/v3/repos/#create
      def create
        request_url = BASE_URI + '/user/repos'
        response = HTTP.with(headers(:post, request_url))
        .post(request_url, json: options.merge(name: name))
        code, body = response.code.to_i, response.body
        fail(RepositoryCreationError, body) unless 201 == code
      end

      # Delete the repositroy
      # @see https://developer.github.com/v3/repos/#delete-a-repository
      def delete
        request_url = BASE_URI + "/repos/#{owner}/#{name}"
        response = HTTP.with(headers(:delete, request_url)).delete(request_url)
        code, body = response.code.to_i, response.body
        fail(RepositoryDeletionError, body) unless [204, 404].include?(code)
      end

      private

      def headers(method, url)
        {
          'Accept' => 'application/vnd.github.v3+json',
          'Authorization' =>
          Helpers::AuthorizationHeader.new(
            credentials, method: method, url: url
          ).generate
        }
      end
    end
  end
end
