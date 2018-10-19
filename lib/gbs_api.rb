require 'gbs_api/version'
require 'gbs_api/config'
require 'gbs_api/api_methods/get_token'
require 'gbs_api/api_methods/get_lockers'
require 'gbs_api/api_methods/waybills_json_upload'
require 'gbs_api/api_methods/manifest_hwb_numbers'

module GbsApi
  class << self
    def get_token(params)
      ApiMethods::GetToken.call(params)
    end

    def get_lockers(params)
      ApiMethods::GetLockers.call(params)
    end

    def waybills_json_upload(params)
      ApiMethods::WaybillsJsonUpload.call(params)
    end

    def manifest_hwb_numbers(params)
      ApiMethods::ManifestHwbNumbers.call(params)
    end
  end
end

