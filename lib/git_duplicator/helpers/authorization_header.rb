require 'base64'
require 'simple_oauth'

module GitDuplicator
  module Helpers
    # Generates authentication header
    class AuthorizationHeader
      OAUTH2_KEYS = [:oauth2_token]
      OAUTH_KEYS = [:consumer_key, :consumer_secret, :token, :token_secret]
      BASIC_KEYS = [:username, :password]

      # @param [Hash] credentials
      # @option credentials [Symbol] :oauth2_token used in oAuth2 authentication
      # @option credentials [Symbol] :consumer_key used in oAuth authentication
      # @option credentials [Symbol] :consumer_secret used in oAuth authentication
      # @option credentials [Symbol] :token used in oAuth authentication
      # @option credentials [Symbol] :token_secret used in oAuth authentication
      # @option credentials [Symbol] :username used in basic authentication
      # @option credentials [Symbol] :password used in basic authentication
      # @param [Hash] request used in generating oauth headers
      # @option request [Symbol] :method
      # @option request [String] :url
      # @option request [Array] :params
      def initialize(credentials, request)
        self.credentials = credentials
        self.request_method = request.fetch(:method)
        self.request_url = request.fetch(:url)
        self.request_params = request.fetch(:params) { [] }
      end

      # Generate the header
      def generate
        if exists?(self.class::OAUTH2_KEYS)
          oauth2_header
        elsif exists?(self.class::OAUTH_KEYS)
          oauth_header
        elsif exists?(self.class::BASIC_KEYS)
          basic_authenticaion_header
        else
          fail ArgumentError, 'Proper authentication keys are missing'
        end
      end

      private

      attr_accessor :credentials, :request_method, :request_url, :request_params

      def exists?(list)
        list.all? { |value| credentials.keys.include?(value) }
      end

      def oauth2_header
        "token #{credentials[:oauth2_token]}"
      end

      def basic_authenticaion_header
        "Basic #{base64_username_password}"
      end

      def oauth_header
        SimpleOAuth::Header.new(request_method, request_url,
                                request_params, credentials).to_s
      end

      def base64_username_password
        Base64.encode64("#{credentials[:username]}" \
                        ":#{credentials[:password]}")
      end
    end
  end
end
