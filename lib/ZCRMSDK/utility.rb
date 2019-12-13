# frozen_string_literal: true

require_relative 'oauth_utility'
require_relative 'oauth_client'
require_relative 'restclient'
require 'uri'
require 'json'
require 'logger'
require 'net/http'
require 'cgi'
module ZCRMSDK
  module Utility
    # THIS CLASS IS USED TO SET PERSISTENCE HANDLER AND CREDENTIALS RELATED DETAILS
    class ZCRMConfigUtil
      def self.get_instance
        ZCRMConfigUtil.new
      end

      def self.init(is_to_initialize_oauth, config_details)
        $CONFIG_PROP_HASH = {}
        $CONFIG_PROP_HASH = config_details
        if $CONFIG_PROP_HASH[APIConstants::API_BASEURL].nil?
          $CONFIG_PROP_HASH[APIConstants::API_BASEURL] = 'https://www.zohoapis.com'
        end
        if $CONFIG_PROP_HASH[APIConstants::API_VERSION].nil?
          $CONFIG_PROP_HASH[APIConstants::API_VERSION] = 'v2'
        end
        if $CONFIG_PROP_HASH[APIConstants::SANDBOX].nil?
          $CONFIG_PROP_HASH[APIConstants::SANDBOX] = 'false'
        end
        if $CONFIG_PROP_HASH[APIConstants::CONSOLE].nil? || $CONFIG_PROP_HASH[APIConstants::CONSOLE] != 'true'
          $CONFIG_PROP_HASH[APIConstants::CONSOLE] = 'false'
        end
        if $CONFIG_PROP_HASH[APIConstants::LOGPATH].nil?
          $CONFIG_PROP_HASH[APIConstants::LOGPATH] = nil
        end
        if is_to_initialize_oauth
          ZCRMSDK::OAuthClient::ZohoOAuth.get_instance(config_details)
        end
      end

      def self.get_config_value(key_value)
        if $CONFIG_PROP_HASH.has_key?(key_value) && !$CONFIG_PROP_HASH[key_value].nil?
          $CONFIG_PROP_HASH[key_value].dup
        else
          return ' '
        end
      end

      def self.get_api_base_url
        get_config_value(APIConstants::API_BASEURL)
      end

      def self.get_api_version
        get_config_value(APIConstants::API_VERSION)
      end

      def get_access_token
        user_email = RestClient::ZCRMRestClient.current_user_email
        if user_email.nil?
          raise ZCRMException.new('current_user_email', APIConstants::RESPONSECODE_BAD_REQUEST, 'Current user should either be set in ZCRMRestClient or in configuration array', 'CURRENT USER NOT SET')
        end

        client_ins = OAuthClient::ZohoOAuth.get_client_instance
        client_ins.get_access_token(user_email)
      end
    end
    # THIS CLASS IS USED TO CONSTUCT API SUPPORTED JSON
    class CommonUtil
      def self.create_api_supported_input_json(input_json, api_key)
        input_json = {} if input_json.nil?
        input_json_arr = []
        input_json_arr.push(input_json)
        req_body_json = {}
        req_body_json[api_key] = input_json_arr
        req_body_json
      end
    end
    # THIS CLASS IS USED TO LOG THE SDK RELATED ACTIVITY
    class SDKLogger
      def self.add_log(message, level, exception = nil)
        if $CONFIG_PROP_HASH.empty?
          raise exception, 'Please Initialize the SDK before using it!'
        end

        unless $CONFIG_PROP_HASH[APIConstants::LOGPATH].nil?
          logger = Logger.new File.new($CONFIG_PROP_HASH[APIConstants::LOGPATH].dup, 'a')
          print_log(logger, message, level, exception)
        end

        if $CONFIG_PROP_HASH[APIConstants::CONSOLE] == 'true'
          logger = Logger.new STDOUT
          print_log(logger, message, level, exception)
        end
      end

      def self.print_log(logger, message, level, exception)
        unless exception.nil?
          message += "; Exception Class::#{exception.class}; exception occured in #{exception.url}"
        end

        case level
        when 'error'
          logger.error(message)
        when 'info'
          logger.info(message)
        when 'warning'
          logger.warning(message)
        when 'fatal'
          logger.fatal(message)
        end
      end
    end
    # THIS CLASS CONSISTS OF COMMON CONSTANTS FREQUENTLY USED
    class APIConstants
      ERROR = 'error'
      REQUEST_METHOD_GET = 'GET'
      REQUEST_METHOD_POST = 'POST'
      REQUEST_METHOD_PUT = 'PUT'
      REQUEST_METHOD_DELETE = 'DELETE'
      REQUEST_METHOD_PATCH = 'PATCH'
      OAUTH_HEADER_PREFIX = 'Zoho-oauthtoken '
      AUTHORIZATION = 'Authorization'
      API_NAME = 'api_name'
      INVALID_ID_MSG = 'The given id seems to be invalid.'
      API_MAX_RECORDS_MSG = 'Cannot process more than 100 records at a time.'
      INVALID_DATA = 'INVALID_DATA'
      CODE_SUCCESS = 'SUCCESS'
      STATUS_SUCCESS = 'success'
      STATUS_ERROR = 'error'
      LEADS = 'Leads'
      ACCOUNTS = 'Accounts'
      CONTACTS = 'Contacts'
      DEALS = 'Deals'
      QUOTES = 'Quotes'
      SALESORDERS = 'SalesOrders'
      INVOICES = 'Invoices'
      PURCHASEORDERS = 'PurchaseOrders'
      PER_PAGE = 'per_page'
      PAGE = 'page'
      COUNT = 'count'
      MORE_RECORDS = 'more_records'
      MESSAGE = 'message'
      CODE = 'code'
      STATUS = 'status'
      DETAILS = 'details'
      DATA = 'data'
      VARIABLE = 'variables'
      VARIABLE_GROUP = 'variable_groups'
      INFO = 'info'
      FIELDS = 'fields'
      LAYOUTS = 'layouts'
      TAG = 'tags'
      CUSTOM_VIEWS = 'custom_views'
      MODULES = 'modules'
      RELATED_LISTS = 'related_lists'
      ORG = 'org'
      ROLES = 'roles'
      PROFILES = 'profiles'
      USERS = 'users'
      TAXES = 'taxes'
      CONSOLE = 'log_in_console'
      LOGPATH = 'application_log_file_path'
      CUSTOM_FUNCTIONS = 'custom_functions'
      RESPONSECODE_OK = 200
      RESPONSECODE_CREATED = 201
      RESPONSECODE_ACCEPTED = 202
      RESPONSECODE_NO_CONTENT = 204
      RESPONSECODE_MOVED_PERMANENTLY = 301
      RESPONSECODE_MOVED_TEMPORARILY = 302
      RESPONSECODE_NOT_MODIFIED = 304
      RESPONSECODE_BAD_REQUEST = 400
      RESPONSECODE_AUTHORIZATION_ERROR = 401
      RESPONSECODE_FORBIDDEN = 403
      RESPONSECODE_NOT_FOUND = 404
      RESPONSECODE_METHOD_NOT_ALLOWED = 405
      RESPONSECODE_REQUEST_ENTITY_TOO_LARGE = 413
      RESPONSECODE_UNSUPPORTED_MEDIA_TYPE = 415
      RESPONSECODE_TOO_MANY_REQUEST = 429
      RESPONSECODE_INTERNAL_SERVER_ERROR = 500
      RESPONSECODE_INVALID_INPUT = 0
      SANDBOX = 'sandbox'
      API_BASEURL = 'api_base_url'
      API_VERSION = 'api_version'
      CURRENT_USER_EMAIL = 'current_user_email'
      ACTION = 'action'
      DUPLICATE_FIELD = 'duplicate_field'
      NO_CONTENT = 'No Content'
      FAULTY_RESPONSE_CODES = [RESPONSECODE_NO_CONTENT, RESPONSECODE_NOT_FOUND, RESPONSECODE_AUTHORIZATION_ERROR, RESPONSECODE_BAD_REQUEST, RESPONSECODE_FORBIDDEN, RESPONSECODE_INTERNAL_SERVER_ERROR, RESPONSECODE_METHOD_NOT_ALLOWED, RESPONSECODE_MOVED_PERMANENTLY, RESPONSECODE_MOVED_TEMPORARILY, RESPONSECODE_REQUEST_ENTITY_TOO_LARGE, RESPONSECODE_TOO_MANY_REQUEST, RESPONSECODE_UNSUPPORTED_MEDIA_TYPE].freeze
      ATTACHMENT_URL = 'attachmentUrl'
      ACCESS_TOKEN_EXPIRY = 'X-ACCESSTOKEN-RESET'
      CURR_WINDOW_API_LIMIT = 'X-RATELIMIT-LIMIT'
      CURR_WINDOW_REMAINING_API_COUNT = 'X-RATELIMIT-REMAINING'
      CURR_WINDOW_RESET = 'X-RATELIMIT-RESET'
      API_COUNT_REMAINING_FOR_THE_DAY = 'X-RATELIMIT-DAY-REMAINING'
      API_LIMIT_FOR_THE_DAY = 'X-RATELIMIT-DAY-LIMIT'
    end
    # THIS CLASS IS USED TO FIRE THE API REQUEST
    class ZohoHTTPConnector
      attr_accessor :url, :req_headers, :req_method, :req_params, :req_body, :api_key, :is_bulk_req, :form_data
      def self.get_instance(url, params = nil, headers = nil, body = nil, method = nil, api_key = 'data', is_bulk_req = false, form_data = nil)
        ZohoHTTPConnector.new(url, params, headers, body, method, api_key, is_bulk_req, form_data)
      end

      def initialize(url, params, headers, body, method, api_key, is_bulk_req, form_data = nil)
        @url = url
        @req_headers = headers
        @req_method = method
        @req_params = params
        @req_body = body
        @api_key = api_key
        @req_form_data = form_data
        @is_bulk_req = is_bulk_req
      end

      def trigger_request
        unless @req_params.nil?
          @req_params.each do |param_key, value|
            @req_params[param_key] = CGI.escape(value) if value.is_a? String
          end
        end
        query_string = @req_params.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join('&')
        if !query_string.nil? && (query_string.strip != '')
          @url += '?' + query_string
        end
        url = URI(@url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        if @req_method == APIConstants::REQUEST_METHOD_GET
          req = Net::HTTP::Get.new(url.request_uri)
        elsif @req_method == APIConstants::REQUEST_METHOD_POST
          req = Net::HTTP::Post.new(url.request_uri)
          req.body = @req_body.to_s
        elsif @req_method == APIConstants::REQUEST_METHOD_PUT
          req = Net::HTTP::Put.new(url.request_uri)
          req.body = @req_body.to_s
        elsif @req_method == APIConstants::REQUEST_METHOD_PATCH
          req = Net::HTTP::Patch.new(url.request_uri)
          req.body = @req_body.to_s
        elsif @req_method == APIConstants::REQUEST_METHOD_DELETE
          req = Net::HTTP::Delete.new(url.request_uri)
        end
        @req_headers.each { |key, value| req.add_field(key, value) }
        unless @req_form_data.nil?
          req.set_form @req_form_data, 'multipart/form-data'
        end
        response = http.request(req)
        response
      end

      def self.set_url(url)
        @url = url
      end

      def self.get_url
        @url
      end

      def add_http_header(key, value)
        @req_headers[key] = value
      end

      def get_http_headers
        req_headers
      end

      def set_http_request_method(method)
        @req_method = method
      end

      def get_http_request_method
        @req_method
      end

      def set_request_body(req_body)
        @req_body = req_body
      end

      def get_request_body
        @req_body
      end

      def add_http_request_params(key, value)
        @req_params.store(key, value)
      end

      def get_http_request_params
        @req_params
      end
    end
    # THIS CLASS IS USED TO HANDLE ZCRM EXCEPTION
    class ZCRMException < StandardError
      attr_accessor :url, :status_code, :error_message, :exception_code, :error_details, :error_content
      def initialize(url, status_code, err_message, exception_code = 'error', details = nil, content = nil)
        @url = url
        @status_code = status_code
        @error_message = err_message
        @exception_code = exception_code
        @error_details = details
        @error_content = content
        SDKLogger.add_log(error_message, 'error', self)
      end

      def self.get_instance(url, status_code, err_message, exception_code = 'error', details = nil, content = nil)
        ZCRMException.new(url, status_code, err_message, exception_code, details, content)
      end

      def to_s
        "#{self.class}\n#{exception.url}\n#{exception.status_code}"\
        "- #{exception.error_message}\n"\
        "#{exception.exception_code}\n#{error_details}\n#{error_content}"
      end

    end
  end
end
