# frozen_string_literal: true

require 'logger'
require 'net/http'
require_relative 'utility'
module ZCRMSDK
  module OAuthUtility
    # THIS CLASS IS USED TO DECLARE CONSTANTS THAT ARE USED FREQUENTLY
    class ZohoOAuthConstants
      IAM_URL = 'accounts_url'
      SCOPES = 'scope'
      STATE = 'state'
      STATE_OBTAINING_GRANT_TOKEN = 'OBTAIN_GRANT_TOKEN'
      RESPONSE_TYPE = 'response_type'
      RESPONSE_TYPE_CODE = 'code'
      CLIENT_ID = 'client_id'
      CLIENT_SECRET = 'client_secret'
      REDIRECT_URL = 'redirect_uri'
      ACCESS_TYPE = 'access_type'
      ACCESS_TYPE_OFFLINE = 'offline'
      ACCESS_TYPE_ONLINE = 'online'
      PROMPT = 'prompt'
      PROMPT_CONSENT = 'consent'
      GRANT_TYPE = 'grant_type'
      GRANT_TYPE_AUTH_CODE = 'authorization_code'
      TOKEN_PERSISTENCE_PATH = 'token_persistence_path'
      DATABASE_PORT = 'db_port'
      DATABASE_USERNAME = 'db_username'
      DATABASE_PASSWORD = 'db_password'
      GRANT_TYPE_REFRESH = 'refresh_token'
      CODE = 'code'
      GRANT_TOKEN = 'grant_token'
      ACCESS_TOKEN = 'access_token'
      REFRESH_TOKEN = 'refresh_token'
      EXPIRES_IN = 'expires_in'
      EXPIRIY_TIME = 'expiry_time'
      PERSISTENCE_HANDLER_CLASS_PATH = 'persistence_handler_class_path'
      PERSISTENCE_HANDLER_CLASS = 'persistence_handler_class'
      TOKEN = 'token'
      DISPATCH_TO = 'dispatchTo'
      OAUTH_TOKENS_PARAM = 'oauth_tokens'
      SANDBOX = 'sandbox'
      OAUTH_HEADER_PREFIX = 'Zoho-oauthtoken '
      AUTHORIZATION = 'Authorization'
      REQUEST_METHOD_GET = 'GET'
      REQUEST_METHOD_POST = 'POST'
      CURRENT_USER_EMAIL = 'current_user_email'
      RESPONSECODE_OK = 200
      EMAIL = 'Email'
      ERROR = 'error'
      INFO = 'info'
      WARNING = 'warning'
    end
    # THIS CLASS IS USED TO HANDLE CUSTOM OAUTH EXCEPTIONS
    class ZohoOAuthException < StandardError
      attr_accessor :url, :err_message, :error, :level
      def initialize(url, err_message, error, level)
        @err_message = err_message
        @error = error
        @level = level
        @url = url
        Utility::SDKLogger.add_log(err_message, level, self)
      end

      def self.get_instance(url, err_message, error, level)
        ZohoOAuthException.new(url, err_message, error, level)
      end
    end
    # THIS CLASS IS USED TO STORE OAuthParams
    class ZohoOAuthParams
      attr_accessor :client_id, :client_secret, :redirect_uri
      def initialize(client_id, client_secret, redirect_uri)
        @client_id = client_id
        @client_secret = client_secret
        @redirect_uri = redirect_uri
      end

      def self.get_instance(client_id, client_secret, redirect_uri)
        ZohoOAuthParams.new(client_id, client_secret, redirect_uri)
      end
    end
    # THIS CLASS IS USED TO FIRE OAUTH RELATED REQUESTS
    class ZohoOAuthHTTPConnector
      attr_accessor :url, :req_headers, :req_method, :req_params, :req_body
      def self.get_instance(url, params = nil, headers = nil, body = nil, method = nil)
        ZohoOAuthHTTPConnector.new(url, params, headers, body, method)
      end

      def initialize(url, params = nil, headers = nil, body = nil, method = nil)
        @url = url
        @req_headers = headers
        @req_method = method
        @req_params = params
        @req_body = body
      end

      def trigger_request
        query_string = @req_params.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join('&')
        if !query_string.nil? && (query_string.strip != '')
          @url += '?' + query_string
        end
        url = URI(@url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        if @req_method == OAuthUtility::ZohoOAuthConstants::REQUEST_METHOD_GET
          req = Net::HTTP::Get.new(url.request_uri)
        elsif @req_method == OAuthUtility::ZohoOAuthConstants::REQUEST_METHOD_POST
          req = Net::HTTP::Post.new(url.request_uri)
        end
        unless @req_headers.nil?
          @req_headers.each do |key, value|
            req.add_field(key, value)
          end
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
        @req_params[key] = value
      end

      def get_http_request_params
        @req_params
      end
    end
  end
end
