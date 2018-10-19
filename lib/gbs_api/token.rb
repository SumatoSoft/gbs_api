module GbsApi
  class Token
    TTL = 3600

    def initialize(token)
      @token = token
      @expiration_time = Time.now + TTL
    end

    def valid?
      Time.now < @expiration_time
    end

    def to_s
      @token.to_s
    end

    class << self
      def get_token
        params = {
          username: GbsApi.config.username,
          password: GbsApi.config.password
        }
        token = GbsApi.get_token(params).result['token']
        new(token)
      end
    end
  end
end
