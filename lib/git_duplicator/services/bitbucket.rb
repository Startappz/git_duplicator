require 'http'
require_relative '../helpers/authorization_header'

module GitDuplicator
  module Services
    # Bitbucket based repository
    class BitbucketRepository < ServiceRepository
      BASE_URI = 'https://api.bitbucket.org/2.0'

      attr_accessor :credentials, :options

      # Initializer
      # @param [String] name name of the repository
      # @param [String] owner owner of the repository
      # @param [Hash] credentials
      # @option credentials [Symbol] :consumer_key used in oAuth authentication
      # @option credentials [Symbol] :consumer_secret used in oAuth authentication
      # @option credentials [Symbol] :token used in oAuth authentication
      # @option credentials [Symbol] :token_secret used in oAuth authentication
      # @option credentials [Symbol] :username used in basic authentication
      # @option credentials [Symbol] :password used in basic authentication
      # @param [Hash] options options for creation
      # @see https://confluence.atlassian.com/display/BITBUCKET/repository+Resource#repositoryResource-POSTanewrepository
      def initialize(name, owner, credentials = {}, options = {})
        super(name, owner)
        self.credentials = credentials
        self.options = options
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
        .post(request_url, json: options)
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
