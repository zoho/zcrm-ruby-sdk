# frozen_string_literal: true

require_relative 'utility'
require_relative 'handler'
require_relative 'operations'
require_relative 'org'
module ZCRMSDK
  module RestClient
    # THIS CLASS IS PRIMARILY USED TO PASS THE CREDENTIALS TO THE SDK AND CALL FEW APIS
    class ZCRMRestClient
      @@current_user_email = nil
      def initialize; end

      def self.get_instance
        ZCRMRestClient.new
      end

      def self.current_user_email
        unless @@current_user_email.nil?
          @@current_user_email.dup
        end
      end

      def self.current_user_email=(current_user_email)
        @@current_user_email = current_user_email
      end

      def self.init(config_details)
        if config_details.nil?
          raise Utility::ZCRMException.new('init', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'configuration details must be given', 'CONFIG DETAILS IS NOT PROVIDED'), 'Configurations details has to be provided!'
        end

        Utility::ZCRMConfigUtil.init(true, config_details)
      end

      def get_all_modules
        Handler::MetaDataAPIHandler.get_instance.get_all_modules
      end

      def get_module(module_api_name)
        Handler::MetaDataAPIHandler.get_instance.get_module(module_api_name)
      end

      def get_organization_instance
        Org::ZCRMOrganization.get_instance
      end

      def get_module_instance(module_api_name)
        Operations::ZCRMModule.get_instance(module_api_name)
      end

      def get_record_instance(module_api_name = nil, entity_id = nil)
        Operations::ZCRMRecord.get_instance(module_api_name, entity_id)
      end

      def get_current_user
        Handler::OrganizationAPIHandler.get_instance.get_current_user
      end

      def get_organization_details
        Handler::OrganizationAPIHandler.get_instance.get_organization_details
      end
    end
  end
end
