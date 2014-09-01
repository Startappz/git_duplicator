require 'http'
require_relative '../helpers/authorization_header'

module GitDuplicator
  module Services
    # Bitbucket based repository
    class BitbucketRepository < ServiceRepository
      BASE_URI = 'https://api.bitbucket.org/2.0'

      attr_accessor :credentials, :remote_options

      # Initializer
      # @param [String] name name of the repository
      # @param [String] owner owner of the repository
      # @param [Hash] options
      #   * :credentials (Hash) credentials for remote service
      #     * :consumer_key (Symbol) used in oAuth authentication
      #     * :consumer_secret (Symbol) used in oAuth authentication
      #     * :token (Symbol) used in oAuth authentication
      #     * :token_secret (Symbol) used in oAuth authentication
      #     * :username (Symbol) used in basic authentication
      #     * :password (Symbol) used in basic authentication
      #   * :remote_options (Hash) creation options for remote service
      #    @see https://confluence.atlassian.com/display/BITBUCKET/repository+Resource#repositoryResource-POSTanewrepository
      #   * :working_directory (String) assing a working directory
      def initialize(name, owner, options = {})
        self.credentials = options.fetch(:credentials) { {} }
        self.remote_options = options.fetch(:remote_options) { {} }
        self.working_directory = options.fetch(:working_directory) { nil }
        super(name, owner, working_directory)
      end

      # URL of the repositroy
      def url
        "git@bitbucket.org:#{owner}/#{name}.git"
      end

      # Create the repositroy
      # @see https://confluence.atlassian.com/display/BITBUCKET/repository+Resource#repositoryResource-POSTanewrepository
      def create
        request_url = BASE_URI + "/repositories/#{owner}/#{name}"
        response = HTTP.with(headers(:post, request_url))
        .post(request_url, json: remote_options)
        code, body = response.code.to_i, response.body
        fail(RepositoryCreationError, body) unless 200 == code
      end

      # Delete the repositroy
      # @see https://confluence.atlassian.com/display/BITBUCKET/repository+Resource#repositoryResource-DELETEarepository
      def delete
        request_url = BASE_URI + "/repositories/#{owner}/#{name}"
        response = HTTP.with(headers(:delete, request_url)).delete(request_url)
        code, body = response.code.to_i, response.body
        fail(RepositoryDeletionError, body) unless [204, 404].include?(code)
      end

      private

      def headers(method, url)
        {
          'Content-Type' => 'application/json',
          'Authorization' =>
          Helpers::AuthorizationHeader.new(
            credentials, method: method, url: url
          ).generate
        }
      end
    end
  end
end
