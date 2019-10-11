# frozen_string_literal: true

require_relative 'oauth_utility'
require_relative 'oauth_client'
module ZCRMSDK
  module Persistence
    # THIS CLASS IS USED TO STORE, RETRIEVE, DELETE TOKENS IN DEFAULT DB
    class ZohoOAuthPersistenceHandler
      def initialize; end

      def self.get_instance
        ZohoOAuthPersistenceHandler.new
      end

      def save_oauth_tokens(oauth_tokens)
        delete_oauth_tokens(oauth_tokens.user_identifier)
        con = Mysql2::Client.new(host: $OAUTH_CONFIG_PROPERTIES['db_address'], username: $OAUTH_CONFIG_PROPERTIES['db_username'], password: $OAUTH_CONFIG_PROPERTIES['db_password'], database: 'zohooauth', port: $OAUTH_CONFIG_PROPERTIES['db_port'])
        con.query("insert into oauthtokens(useridentifier,accesstoken,refreshtoken,expirytime) values('#{oauth_tokens.user_identifier}','#{oauth_tokens.access_token}','#{oauth_tokens.refresh_token}',#{oauth_tokens.expiry_time})")
        con.close
      rescue Mysql2::Error => e
        Utility::SDKLogger.add_log(e.error, OAuthUtility::ZohoOAuthConstants::ERROR, e)
      ensure
        con.close
      end

      def get_oauth_tokens(user_identifier)
        con = Mysql2::Client.new(host: $OAUTH_CONFIG_PROPERTIES['db_address'], username: $OAUTH_CONFIG_PROPERTIES['db_username'], password: $OAUTH_CONFIG_PROPERTIES['db_password'], database: 'zohooauth', port: $OAUTH_CONFIG_PROPERTIES['db_port'])
        query = "select * from oauthtokens where useridentifier='#{user_identifier}'"
        rs = con.query(query)
        oauth_tokens = nil
        rs.each do |row|
          oauth_tokens = OAuthClient::ZohoOAuthTokens.get_instance(row['refreshtoken'], row['accesstoken'], row['expirytime'], user_identifier)
          con.close
          return oauth_tokens
        end
        raise OAuthUtility::ZohoOAuthException.get_instance('get_oauth_tokens', 'no such email id - ' + user_identifier + ' present in the DB', 'Exception occured while fetching accesstoken from Grant Token', OAuthUtility::ZohoOAuthConstants::ERROR)
      rescue Mysql2::Error => e
        Utility::SDKLogger.add_log(e.error, OAuthUtility::ZohoOAuthConstants::ERROR, e)
      ensure
        con.close
      end

      def delete_oauth_tokens(user_identifier)
        con = Mysql2::Client.new(host: $OAUTH_CONFIG_PROPERTIES['db_address'], username: $OAUTH_CONFIG_PROPERTIES['db_username'], password: $OAUTH_CONFIG_PROPERTIES['db_password'], database: 'zohooauth', port: $OAUTH_CONFIG_PROPERTIES['db_port'])
        delete_query = "delete from oauthtokens where useridentifier='#{user_identifier}'"
        con.query(delete_query)
        con.close
      rescue Mysql2::Error => e
        Utility::SDKLogger.add_log(e.error, OAuthUtility::ZohoOAuthConstants::ERROR, e)
      ensure
        con.close
      end
    end
    # THIS CLASS IS USED TO STORE, RETRIEVE, DELETE TOKENS IN FILE
    class ZohoOAuthFilePersistenceHandler
      def initialize; end

      def self.get_instance
        ZohoOAuthFilePersistenceHandler.new
      end

      def save_oauth_tokens(oauth_tokens)
        unless File.exist?($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].dup + '/zcrm_oauthtokens.txt')
          file_obj = File.new($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].dup + '/zcrm_oauthtokens.txt', 'w')
          file_obj.close
        end
        delete_oauth_tokens(oauth_tokens.user_identifier)
        arr = []
        path = $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].dup + '/zcrm_oauthtokens.txt'
        file_obj = File.open(path, 'r')
        serialized = file_obj.read
        file_obj.close
        arr = Marshal.load(serialized) unless serialized.nil? || serialized.empty?
        arr.push(oauth_tokens)
        file_obj = File.open(path, 'w+')
        file_obj.write(Marshal.dump(arr))
        file_obj.close
      end

      def get_oauth_tokens(user_identifier)
        if !File.exist?($OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].dup + '/zcrm_oauthtokens.txt')
          raise OAuthUtility::ZohoOAuthException.get_instance('get_oauth_tokens', 'file does not exist!generate the access token!', 'Error occured while getting access token', OAuthUtility::ZohoOAuthConstants::ERROR)
        end

        path = $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].dup + '/zcrm_oauthtokens.txt'
        file_obj = File.open(path, 'r')
        serialized = file_obj.read
        file_obj.close
        if serialized.empty? || serialized.nil?
          raise OAuthUtility::ZohoOAuthException.get_instance('get_oauth_tokens', 'no tokens found!generate the access token!', 'Error occured while getting access token', OAuthUtility::ZohoOAuthConstants::ERROR)
        end

        deserialized = Marshal.load(serialized)
        deserialized.each do |token|
          return token if token.user_identifier == user_identifier
        end
        raise OAuthUtility::ZohoOAuthException.get_instance('get_oauth_tokens', 'no such' + user_identifier.to_s + 'present in the File', 'Exception occured while fetching accesstoken from Grant Token', OAuthUtility::ZohoOAuthConstants::ERROR)
      end

      def delete_oauth_tokens(user_identifier)
        path = $OAUTH_CONFIG_PROPERTIES[OAuthUtility::ZohoOAuthConstants::TOKEN_PERSISTENCE_PATH].dup + '/zcrm_oauthtokens.txt'
        file_obj = File.open(path, 'r')
        serialized = file_obj.read
        file_obj.close

        return if serialized.empty? || serialized.nil?

        found = false
        i = 0
        deserialized = Marshal.load(serialized)
        deserialized.each do |token|
          if token.user_identifier == user_identifier
            found = true
            break
          end
          i += 1
        end
        if found
          deserialized.delete_at(i)
          file_obj = File.open(path, 'w+')
          file_obj.write(Marshal.dump(deserialized))
          file_obj.close
        end
      end
    end
  end
end
