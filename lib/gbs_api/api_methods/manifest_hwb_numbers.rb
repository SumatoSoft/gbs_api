require_relative 'base'

module GbsApi
  module ApiMethods
    class ManifestHwbNumbers < Base
      class << self
        def call(params)
          new(:manifest_hwb_numbers, params).call
        end
      end

      def status
        result&.dig('Status')
      end

      private

      def requires_authorization?
        true
      end

      def validate_response
        super
        errors.add(:status, 'invalid') if status != 'OK'
      end
    end
  end
end
