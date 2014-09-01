require 'http'
module GitDuplicator
  module Services
    class GithubRepository < ServiceRepository
      BASE_URI = 'https://api.github.com'

      attr_accessor :credentials, :remote_options, :working_directory

      # Initializer
      # @param [Hash] options
      #   * :credentials (Hash) credentials for remote service
      #     * :oauth2_token (Symbol) used in oAuth2 authentication
      #     * :username (Symbol) used in basic authentication
      #     * :password (Symbol) used in basic authentication
      #   * :remote_options (Hash) creation options for remote service
      #    @see @see https://developer.github.com/v3/repos/#create
      #   * :working_directory (String) assing a working directory
      def initialize(name, owner, options = {})
        self.credentials = options.fetch(:credentials) { {} }
        self.remote_options = options.fetch(:remote_options) { {} }
        self.working_directory = options.fetch(:working_directory) { nil }
        super(name, owner, working_directory)
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
        .post(request_url, json: remote_options.merge(name: name))
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
