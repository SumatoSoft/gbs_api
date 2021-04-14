require_relative 'base'

module GbsApi
  module ApiMethods
    class GetLockers < Base
      class << self
        def call(params)
          new(:'LOC.GetLockers', params).call
        end
      end

      private

      def requires_authorization?
        true
      end
    end
  end
end
