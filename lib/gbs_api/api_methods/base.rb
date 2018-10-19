require 'gbs_api/token'
require 'gbs_api/errors'

module GbsApi
  module ApiMethods
    class Base
      include HTTParty
      @@token = nil
      MAX_RETRIES = 1
      LOG_FORMAT = :curl

      class << self
        def call
          raise NotImplementedError
        end
      end

      def initialize(method_name, params, retries = 0)
        @method_name = method_name
        @params = params
        @retries = retries
      end

      def call
        perform(@method_name, @params)

        if errors[:token] && @retries < MAX_RETRIES
          refresh_token
          return self.class.new(@method_name, @params, @retries + 1).call
        end

        self
      end

      def response
        @response
      end

      def result
        @result
      end

      def success?
        !failure?
      end

      def failure?
        errors.any?
      end

      def errors
        @errors ||= GbsApi::Errors.new
      end

      private

      def base_uri
        GbsApi.config.api_url
      end

      def logger
        GbsApi.config.logger
      end

      def log_level
        GbsApi.config.log_level
      end

      def log_response?
        return false unless logger
        log_level == :debug || (errors.any? && log_level == :error)
      end

      def log_response
        log = ::HTTParty::Logger.build(
          logger,
          log_level,
          LOG_FORMAT
        )
        log.format(response.request, response.response)
      end

      def token
        return @@token if @@token && @@token.valid?
        refresh_token
      end

      def refresh_token
        @@token = GbsApi::Token.get_token
      end

      def perform(method_name, params)
        headers = request_headers
        body = request_body(method_name, params)

        @response = self.class.post(base_uri, headers: headers, body: body)
        @result = @response['result']

        validate_response
        log_response if log_response?
      end

      def validate_response
        errors.add(:response, 'invalid') if !response.success? || response['error']
        errors.add(:token, 'invalid') if response[/InvalidTokenError/]
        errors.add(:result, 'blank') if result.blank?
      end

      def default_headers
        { 'Content-Type' => 'application/json' }
      end

      def authorization_headers
        { 'Authorization' => "Bearer #{token}" }
      end

      def request_headers
        if requires_authorization?
          default_headers.merge(authorization_headers)
        else
          default_headers
        end
      end

      def requires_authorization?
        false
      end

      def request_body(method_name, params)
        {
          jsonrpc: '2.0',
          method: method_name,
          params: params,
          id: SecureRandom.uuid
        }.to_json
      end
    end
  end
end
