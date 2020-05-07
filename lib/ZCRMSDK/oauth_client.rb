# frozen_string_literal: true

require 'json'
require_relative 'oauth_utility'
require_relative 'persistence'
module ZCRMSDK
  module OAuthClient
    # THIS CLASS IS USED TO STORE OAUTH RELATED CREDENTIALS
    class ZohoOAuth
      $OAUTH_CONFIG_PROPERTIES = {}
      def self.get_instance(config_details)
        ZohoOAuth.new(config_details)
      end

      def initialize(config_details)
        $OAUTH_CONFIG_PROPERTIES = {}
        $OAUTH_CONFIG_PROPERTIES = config_details
        mandatory_keys = [OAuthUtility::ZohoOAuthConstants::CLIENT_ID, OAuthUtility::ZohoOAuthConstants::CLIENT_SECRET, OAuthUtility::ZohoOAuthConstants::REDIRECT_URL]
        mandatory_keys.each do |item|
          if $OAUTH_CONFIG_PROPERTIES[item].nil?
            raise OAuthUtility::ZohoOAuthException.get_instance('initialize(config_details)', item + ' is mandatory!', 'Exception occured while reading oauth configurations', OAuthUtility::ZohoOAuthConstants::ERROR)
          end
        end
        if $OAUTH_CONFIG_PROPERTIES.key? OAuthUtility::ZohoOAuthConstants::CURRENT_USER_EMAIL
          unless $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::CURRENT_USER_EMAIL].nil?
            ZCRMSDK::RestClient::ZCRMRestClient.current_user_email = $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::CURRENT_USER_EMAIL]
          end
        end
        if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::ACCESS_TYPE].nil?
          $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::ACCESS_TYPE] = 'offline'
        end
        if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS_PATH].nil?
          $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS_PATH] = nil
        end
        if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS].nil?
          $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS] = nil
        end
        if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::IAM_URL].nil?
          $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::IAM_URL] = 'https://accounts.zoho.com'
        end
        if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].nil?
          $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH] = nil
          if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::DATABASE_PORT].nil?
            $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::DATABASE_PORT] = '3306'
          end
          if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::DATABASE_USERNAME].nil?
            $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::DATABASE_USERNAME] = 'root'
          end
          if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::DATABASE_PASSWORD].nil?
            $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::DATABASE_PASSWORD] = ''
          end
        end
        if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::SANDBOX].nil?
          $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::SANDBOX] = 'false'
        end
        oauth_params = OAuthUtility::ZohoOAuthParams.get_instance($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::CLIENT_ID].dup, $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::CLIENT_SECRET].dup, $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::REDIRECT_URL].dup)
        ZohoOAuthClient.get_instance(oauth_params)
      end

      def self.get_grant_url
        ($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::IAM_URL].dup + '/oauth/v2/auth')
      end

      def self.get_token_url
        ($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::IAM_URL].dup + '/oauth/v2/token')
      end

      def self.get_refresh_token_url
        ($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::IAM_URL].dup + '/oauth/v2/token')
      end

      def self.get_revoke_token_url
        ($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::IAM_URL].dup + '/oauth/v2/token/revoke')
      end

      def self.get_user_info_url
        ($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::IAM_URL].dup + '/oauth/user/info')
      end

      def self.get_client_instance
        oauth_client_ins = ZohoOAuthClient.get_instance
        if oauth_client_ins.nil?
          raise OAuthUtility::ZohoOAuthException.get_instance('get_client_instance', 'ZCRMSDK::RestClient::ZCRMRestClient.init(config_details) must be called before this', 'Error occured while getting client instance', OAuthUtility::ZohoOAuthConstants::ERROR)
        end

        oauth_client_ins
      end

      def self.get_persistence_instance
        if !$OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS_PATH].nil?
          if !File.exist?($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS_PATH])
            raise OAuthUtility::ZohoOAuthException.get_instance('get_persistence_instance', 'file does not exist!', 'Error occured while getting persistence instance', OAuthUtility::ZohoOAuthConstants::ERROR)
          end

          require $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS_PATH]
          if $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS].nil?
            raise OAuthUtility::ZohoOAuthException.get_instance('get_persistence_instance', 'class name not given', 'Exception occured while getting persistence instance', OAuthUtility::ZohoOAuthConstants::ERROR)
          end

          class_name = $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::PERSISTENCE_HANDLER_CLASS].dup
          begin
            persistence_instance = Object.const_get(class_name).new
          rescue NameError
            raise OAuthUtility::ZohoOAuthException.get_instance('get_persistence_instance', 'Please check the handler class details', 'Error occured while getting persistence instance', OAuthUtility::ZohoOAuthConstants::ERROR)
          end
          persistence_instance
        elsif !$OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].nil?
          Persistence::ZohoOAuthFilePersistenceHandler.get_instance
        else
          require 'mysql2'
          Persistence::ZohoOAuthPersistenceHandler.get_instance
        end
      end
    end
    # THIS CLASS IS USED TO GENERATED TOKENS
    class ZohoOAuthClient
      @@oauth_params = nil
      @@oauth_client_instance = nil
      def initialize(oauth_params)
        @@oauth_params = oauth_params
      end

      def self.get_oauth_params
        @@oauth_params
      end

      def self.get_instance(param = nil)
        if !param.nil?
          @@oauth_client_instance = ZohoOAuthClient.new(param)
        end
        @@oauth_client_instance
      end

      def get_access_token(user_email)
        handler = ZohoOAuth.get_persistence_instance
        oauth_tokens = handler.get_oauth_tokens(user_email)
        begin
          return oauth_tokens.get_access_token
        rescue ZCRMSDK::OAuthUtility::ZohoOAuthException
          oauth_tokens = refresh_access_token(oauth_tokens.refresh_token, user_email)
          return oauth_tokens.access_token
        end
      end

      def generate_access_token_from_refresh_token(refresh_token,user_email)
        refresh_access_token(refresh_token, user_email)
      end

      def refresh_access_token(refresh_token, user_email)
        if refresh_token.nil?
          raise OAuthUtility::ZohoOAuthException.get_instance('refresh_access_token(refresh_token, user_email)', 'Refresh token not provided!', 'Exception occured while refreshing oauthtoken', OAuthUtility::ZohoOAuthConstants::ERROR)
        end

        begin
          connector = get_connector(ZohoOAuth.get_refresh_token_url)
          connector.add_http_request_params(OAuthUtility::ZohoOAuthConstants::GRANT_TYPE, OAuthUtility::ZohoOAuthConstants::GRANT_TYPE_REFRESH)
          connector.add_http_request_params(OAuthUtility::ZohoOAuthConstants::REFRESH_TOKEN, refresh_token)
          connector.set_http_request_method(OAuthUtility::ZohoOAuthConstants::REQUEST_METHOD_POST)
          response = connector.trigger_request
          response_json = JSON.parse(response.body)
          if response_json[OAuthUtility::ZohoOAuthConstants::ACCESS_TOKEN].nil?
            raise OAuthUtility::ZohoOAuthException.get_instance('refresh_access_token(refresh_token, user_email)', 'Response is' + response_json.to_s, 'Exception occured while refreshing oauthtoken', OAuthUtility::ZohoOAuthConstants::ERROR)
          else
            oauth_tokens = get_tokens_from_json(response_json)
            oauth_tokens.user_identifier = user_email
            oauth_tokens.refresh_token = refresh_token
            ZohoOAuth.get_persistence_instance.save_oauth_tokens(oauth_tokens)
            return oauth_tokens
          end
        end
      end

      def generate_access_token(grant_token)
        if grant_token.nil?
          raise OAuthUtility::ZohoOAuthException.get_instance('generate_access_token(grant_token)', 'Grant token not provided!', 'Exception occured while fetching accesstoken from Grant Token', OAuthUtility::ZohoOAuthConstants::ERROR)
        end

        connector = get_connector(ZohoOAuth.get_token_url)
        connector.add_http_request_params(OAuthUtility::ZohoOAuthConstants::GRANT_TYPE, OAuthUtility::ZohoOAuthConstants::GRANT_TYPE_AUTH_CODE)
        connector.add_http_request_params(OAuthUtility::ZohoOAuthConstants::CODE, grant_token)
        connector.set_http_request_method(OAuthUtility::ZohoOAuthConstants::REQUEST_METHOD_POST)
        response = connector.trigger_request
        response_json = JSON.parse(response.body)
        if !response_json[OAuthUtility::ZohoOAuthConstants::ACCESS_TOKEN].nil?
          oauth_tokens = get_tokens_from_json(response_json)
          oauth_tokens.user_identifier = get_user_email_from_iam(oauth_tokens.access_token)
          ZohoOAuth.get_persistence_instance.save_oauth_tokens(oauth_tokens)
          return oauth_tokens
        else
          raise OAuthUtility::ZohoOAuthException.get_instance('generate_access_token(grant_token)', 'Response is' + response_json.to_s, 'Exception occured while fetching accesstoken from Grant Token', OAuthUtility::ZohoOAuthConstants::ERROR)
        end
      end

      def get_tokens_from_json(response_json)
        expires_in = response_json[OAuthUtility::ZohoOAuthConstants::EXPIRES_IN]
        unless response_json.has_key?(OAuthUtility::ZohoOAuthConstants::EXPIRES_IN_SEC)
          expires_in = expires_in * 1000
        end
        expires_in += ZCRMSDK::OAuthClient::ZohoOAuthTokens.get_current_time_in_millis
        access_token = response_json[OAuthUtility::ZohoOAuthConstants::ACCESS_TOKEN]
        refresh_token = nil
        unless response_json[OAuthUtility::ZohoOAuthConstants::REFRESH_TOKEN].nil?
          refresh_token = response_json[OAuthUtility::ZohoOAuthConstants::REFRESH_TOKEN]
        end
        oauth_tokens = ZohoOAuthTokens.get_instance(refresh_token, access_token, expires_in)
        oauth_tokens
      end

      def get_connector(url)
        connector = OAuthUtility::ZohoOAuthHTTPConnector.get_instance(url, {})
        connector.add_http_request_params(OAuthUtility::ZohoOAuthConstants::CLIENT_ID, OAuthClient::ZohoOAuthClient.get_oauth_params.client_id)
        connector.add_http_request_params(OAuthUtility::ZohoOAuthConstants::CLIENT_SECRET, OAuthClient::ZohoOAuthClient.get_oauth_params.client_secret)
        connector.add_http_request_params(OAuthUtility::ZohoOAuthConstants::REDIRECT_URL, OAuthClient::ZohoOAuthClient.get_oauth_params.redirect_uri)
        connector
      end

      def get_user_email_from_iam(access_token)
        begin
          header = {}
          header[OAuthUtility::ZohoOAuthConstants::AUTHORIZATION] = OAuthUtility::ZohoOAuthConstants::OAUTH_HEADER_PREFIX + access_token
          connector = OAuthUtility::ZohoOAuthHTTPConnector.get_instance(ZohoOAuth.get_user_info_url, nil, header, nil, OAuthUtility::ZohoOAuthConstants::REQUEST_METHOD_GET)
          response = connector.trigger_request
          JSON.parse(response.body)[OAuthUtility::ZohoOAuthConstants::EMAIL]
        rescue StandardError => e
          raise OAuthUtility::ZohoOAuthException.get_instance('generate_access_token(grant_token)', 'Exception occured while fetching User Id from access Token,Make sure AAAserver.profile.Read scope is included while generating the Grant token', 'Exception occured while fetching User Id from access Token', OAuthUtility::ZohoOAuthConstants::ERROR)
        end
      end
    end
    # THIS CLASS IS USED TO STORE THE TOKEN AS A INSTANCE AND CHECK THE VALIDITY OF THE TOKEN
    class ZohoOAuthTokens
      attr_accessor :refresh_token, :access_token, :expiry_time, :user_email, :user_identifier
      @user_email = nil
      def self.get_instance(refresh_token, access_token, expiry_time, user_identifier = nil)
        ZohoOAuthTokens.new(refresh_token, access_token, expiry_time, user_identifier)
      end

      def initialize(refresh_token, access_token, expiry_time, user_identifier = nil)
        @refresh_token = refresh_token
        @access_token = access_token
        @expiry_time = expiry_time
        @user_identifier = user_identifier
      end

      def get_access_token
        if (@expiry_time - ZCRMSDK::OAuthClient::ZohoOAuthTokens.get_current_time_in_millis) > 15_000
          @access_token
        else
          raise OAuthUtility::ZohoOAuthException.get_instance('get_access_token', 'Access token got expired!', 'Access token expired hence refreshing', OAuthUtility::ZohoOAuthConstants::INFO)
        end
      end

      def self.get_current_time_in_millis
        (Time.now.to_f * 1000).to_i
      end
    end
  end
end
