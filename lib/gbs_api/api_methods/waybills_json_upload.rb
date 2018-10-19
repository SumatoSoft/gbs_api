require_relative 'base'

module GbsApi
  module ApiMethods
    class WaybillsJsonUpload < Base
      class << self
        def call(params)
          new(:waybills_json_upload, params).call
        end
      end

      def tracking_number
        result&.dig('HWB', 0, 'HWBNumber')
      end

      def status
        result&.dig('HWB', 0, 'Status')
      end

      private

      def requires_authorization?
        true
      end

      def validate_response
        super
        errors.add(:status, 'invalid') if status != 'OK'
        errors.add(:tracking_number, 'blank') if tracking_number.blank?
      end
    end
  end
end
