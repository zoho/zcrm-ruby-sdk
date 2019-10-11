# frozen_string_literal: true

require_relative 'utility'
require_relative 'response'
module ZCRMSDK
  module Request
    # THIS CLASS IS USED TO AUTHENTICATE AND CONSTRUCT API REQUEST
    class APIRequest
      def initialize(api_handler_ins)
        construct_api_url
        @url += api_handler_ins.request_url_path
        @url = 'https://' + @url unless @url.start_with?('http')
        @request_body = api_handler_ins.request_body
        @request_headers = api_handler_ins.request_headers
        @request_params = api_handler_ins.request_params
        @request_method = api_handler_ins.request_method
        @request_api_key = api_handler_ins.request_api_key
      end

      def self.get_instance(api_handler_ins)
        APIRequest.new(api_handler_ins)
      end

      def construct_api_url
        hit_sandbox = ZCRMSDK::Utility::ZCRMConfigUtil.get_config_value(ZCRMSDK::Utility::APIConstants::SANDBOX)
        url = ZCRMSDK::Utility::ZCRMConfigUtil.get_api_base_url
        if hit_sandbox == 'true'
          url = url.sub('www.', 'sandbox.')
        end
        @url = url + '/crm/' + ZCRMSDK::Utility::ZCRMConfigUtil.get_api_version + '/'
      end

      def authenticate_request
        access_token = ZCRMSDK::Utility::ZCRMConfigUtil.get_instance.get_access_token
        if @request_headers.nil?
          @request_headers = { ZCRMSDK::Utility::APIConstants::AUTHORIZATION => ZCRMSDK::Utility::APIConstants::OAUTH_HEADER_PREFIX.dup + access_token }
        else
          @request_headers[ZCRMSDK::Utility::APIConstants::AUTHORIZATION] = ZCRMSDK::Utility::APIConstants::OAUTH_HEADER_PREFIX.dup + access_token
        end
        @request_headers['User-Agent'] = 'ZohoCRM Ruby SDK'
      end

      def get_api_response
        authenticate_request
        connector = ZCRMSDK::Utility::ZohoHTTPConnector.get_instance(@url, @request_params, @request_headers, @request_body.to_json, @request_method, @request_api_key, false)
        response = connector.trigger_request
        Response::APIResponse.get_instance(response, response.code.to_i, @url, @request_api_key)
      end

      def get_bulk_api_response
        authenticate_request
        connector = ZCRMSDK::Utility::ZohoHTTPConnector.get_instance(@url, @request_params, @request_headers, @request_body.to_json, @request_method, @request_api_key, true)
        response = connector.trigger_request
        Response::BulkAPIResponse.get_instance(response, response.code.to_i, @url, @request_api_key)
      end

      def upload_file(file_path)
        authenticate_request
        form_data = [['file', File.open(file_path)]]
        connector = ZCRMSDK::Utility::ZohoHTTPConnector.get_instance(@url, @request_params, @request_headers, @request_body, @request_method, @request_api_key, false, form_data)
        response = connector.trigger_request
        Response::APIResponse.get_instance(response, response.code.to_i, @url, @request_api_key)
      end

      def upload_link_as_attachment(link_url)
        authenticate_request
        form_data = [['attachmentUrl', link_url]]
        connector = ZCRMSDK::Utility::ZohoHTTPConnector.get_instance(@url, @request_params, @request_headers, @request_body, @request_method, @request_api_key, false, form_data)
        response = connector.trigger_request
        Response::APIResponse.get_instance(response, response.code.to_i, @url, @request_api_key)
      end

      def download_file
        authenticate_request
        connector = ZCRMSDK::Utility::ZohoHTTPConnector.get_instance(@url, @request_params, @request_headers, @request_body, @request_method, @request_api_key, false)
        response = connector.trigger_request
        file_response = Response::FileAPIResponse.get_instance(response, response.code.to_i, @url)
        file_response.set_file_content
        file_response
      end
    end
  end
end
