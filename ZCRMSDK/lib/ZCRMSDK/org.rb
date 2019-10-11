# frozen_string_literal: true

require_relative 'handler'
require_relative 'utility'
require_relative 'operations'
module ZCRMSDK
  module Org
    # THIS CLASS IS USED TO STORE AND EXECUTE ORGANIZATION RELATED FUNCTIONALITIES
    class ZCRMOrganization
      attr_accessor :users_license_purchased, :photo_id, :privacy_settings, :zia_portal_id, :currency, :company_name, :org_id, :alias_aka, :primary_zuid, :zgid, :primary_email, :website, :mobile, :phone, :employee_count, :description, :time_zone, :iso_code, :currency_locale, :currency_symbol, :street, :state, :city, :country, :zip_code, :country_code, :fax, :mc_status, :is_gapps_enabled, :paid_expiry, :trial_type, :trial_expiry, :is_paid_account, :paid_type
      def initialize(org_name = nil, org_id = nil)
        @currency = nil
        @zia_portal_id = nil
        @privacy_settings = nil
        @photo_id = nil
        @company_name = org_name
        @org_id = org_id
        @alias_aka = nil
        @primary_zuid = nil
        @zgid = nil
        @primary_email = nil
        @website = nil
        @mobile = nil
        @phone = nil
        @employee_count = nil
        @description = nil
        @time_zone = nil
        @iso_code = nil
        @currency_locale = nil
        @currency_symbol = nil
        @street = nil
        @state = nil
        @city = nil
        @country = nil
        @zip_code = nil
        @country_code = nil
        @fax = nil
        @mc_status = nil
        @is_gapps_enabled = nil
        @paid_expiry = nil
        @trial_type = nil
        @trial_expiry = nil
        @is_paid_account = nil
        @paid_type = nil
        @users_license_purchased = nil
      end

      def self.get_instance(org_name = nil, org_id = nil)
        ZCRMOrganization.new(org_name, org_id)
      end

      def get_user(user_id)
        Handler::OrganizationAPIHandler.get_instance.get_user(user_id)
      end

      def get_current_user
        Handler::OrganizationAPIHandler.get_instance.get_current_user
      end

      def get_all_users
        Handler::OrganizationAPIHandler.get_instance.get_all_users
      end

      def get_all_active_users
        Handler::OrganizationAPIHandler.get_instance.get_all_active_users
      end

      def get_all_deactive_users
        Handler::OrganizationAPIHandler.get_instance.get_all_deactive_users
      end

      def get_all_confirmed_users
        Handler::OrganizationAPIHandler.get_instance.get_all_confirmed_users
      end

      def get_all_not_confirmed_users
        Handler::OrganizationAPIHandler.get_instance.get_all_not_confirmed_users
      end

      def get_all_deleted_users
        Handler::OrganizationAPIHandler.get_instance.get_all_deleted_users
      end

      def get_all_active_confirmed_users
        Handler::OrganizationAPIHandler.get_instance.get_all_active_confirmed_users
      end

      def get_all_admin_users
        Handler::OrganizationAPIHandler.get_instance.get_all_admin_users
      end

      def get_all_active_confirmed_admin_users
        Handler::OrganizationAPIHandler.get_instance.get_all_active_confirmed_admin_users
      end

      def get_all_profiles
        Handler::OrganizationAPIHandler.get_instance.get_all_profiles
      end

      def get_profile(profile_id)
        Handler::OrganizationAPIHandler.get_instance.get_profile(profile_id)
      end

      def get_all_roles
        Handler::OrganizationAPIHandler.get_instance.get_all_roles
      end

      def get_role(role_id)
        Handler::OrganizationAPIHandler.get_instance.get_role(role_id)
      end

      def create_user(user_instance)
        Handler::OrganizationAPIHandler.get_instance.create_user(user_instance)
      end

      def update_user(user_instance)
        Handler::OrganizationAPIHandler.get_instance.update_user(user_instance)
      end

      def delete_user(user_id)
        Handler::OrganizationAPIHandler.get_instance.delete_user(user_id)
      end

      def get_organization_taxes
        Handler::OrganizationAPIHandler.get_instance.get_organization_taxes
      end

      def get_organization_tax(org_tax_id)
        Handler::OrganizationAPIHandler.get_instance.get_organization_tax(org_tax_id)
      end

      def search_users_by_criteria(criteria, type = nil)
        Handler::OrganizationAPIHandler.get_instance.search_users_by_criteria(criteria, type)
      end

      def create_organization_taxes(orgtax_instances)
        Handler::OrganizationAPIHandler.get_instance.create_organization_taxes(orgtax_instances)
      end

      def update_organization_taxes(orgtax_instances)
        Handler::OrganizationAPIHandler.get_instance.update_organization_taxes(orgtax_instances)
      end

      def delete_organization_taxes(orgtax_ids)
        Handler::OrganizationAPIHandler.get_instance.delete_organization_taxes(orgtax_ids)
      end

      def delete_organization_tax(orgtax_id)
        Handler::OrganizationAPIHandler.get_instance.delete_organization_tax(orgtax_id)
      end
    end
  end
end
