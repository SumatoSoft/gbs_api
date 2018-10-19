require_relative 'base'

module GbsApi
  module ApiMethods
    class GetToken < Base
      class << self
        def call(params)
          new(:get_token, params).call
        end
      end
    end
  end
end
