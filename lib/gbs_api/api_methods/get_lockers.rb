require_relative 'base'

module GbsApi
  module ApiMethods
    class GetLockers < Base
      class << self
        def call(params)
          new(:'LOC.GetLockers', params).call
        end
      end
    end
  end
end
