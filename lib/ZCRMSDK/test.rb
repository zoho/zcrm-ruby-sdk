# require './oauth_utility'
# require './operations'
# require './handler'
# require './oauth_client'
# require './operations'
# require './org'
# require './persistence'
# require './request'
# require './response'
# require './utility'
# require './restclient'
# require './version'
require 'ZCRMSDK'
# THIS CLASS SHOWS THE EXAMPLES
class Tester
  def initialize
  
    config_details = { 'client_id' => 'client_id', 'client_secret' => 'client_secret', 'redirect_uri' => 'redirect_uri', 'api_base_url' => 'http://www.zohoapis.com', 'api_version' => 'v2', 'current_user_email' => 'current_user_email' ,'log_in_console' => 'true' }  
    ZCRMSDK::RestClient::ZCRMRestClient.init(config_details)
  end

  def get_organization_details
    rest = ZCRMSDK::RestClient::ZCRMRestClient.get_instance
    api_res = rest.get_organization_details
    org_ins = api_res.data
    print org_ins.company_name
    print "\n"
    print org_ins.org_id
    print "\n"
    print org_ins.alias_aka
    print "\n"
    print org_ins.primary_zuid
    print "\n"
    print org_ins.zgid
    print "\n"
    print org_ins.primary_email
    print "\n"
    print org_ins.website
    print "\n"
    print org_ins.mobile
    print "\n"
    print org_ins.phone
    print "\n"
    print org_ins.employee_count
    print "\n"
    print org_ins.description
    print "\n"
    print org_ins.time_zone
    print "\n"
    print org_ins.iso_code
    print "\n"
    print org_ins.currency_locale
    print "\n"
    print org_ins.currency_symbol
    print "\n"
    print org_ins.street
    print "\n"
    print org_ins.state
    print "\n"
    print org_ins.city
    print "\n"
    print org_ins.country
    print "\n"
    print org_ins.zip_code
    print "\n"
    print org_ins.country_code
    print "\n"
    print org_ins.fax
    print "\n"
    print org_ins.mc_status
    print "\n"
    print org_ins.is_gapps_enabled
    print "\n"
    print org_ins.paid_expiry
    print "\n"
    print org_ins.trial_type
    print "\n"
    print org_ins.trial_expiry
    print "\n"
    print org_ins.is_paid_account
    print "\n"
    print org_ins.paid_type
    print "\n"
    print org_ins.currency
    print "\n"
    print org_ins.zia_portal_id
    print "\n"
    print org_ins.privacy_settings
    print "\n"
    print org_ins.photo_id
    print "\n"
    print org_ins.users_license_purchased
  end

  def get_all_modules
    rest = ZCRMSDK::RestClient::ZCRMRestClient.get_instance
    api_res = rest.get_all_modules
    module_ins_arr = api_res.data
    module_ins_arr.each do |module_ins|
      print module_ins.api_name
      print "\n"
      print module_ins.is_convertable
      print "\n"
      print module_ins.is_creatable
      print "\n"
      print module_ins.is_editable
      print "\n"
      print module_ins.is_deletable
      print "\n"
      print module_ins.web_link
      print "\n"
      print module_ins.singular_label
      print "\n"
      print module_ins.plural_label
      print "\n"
      modified_by = module_ins.modified_by
      unless modified_by.nil?
        print modified_by.id
        print "\n"
        print modified_by.name
        print "\n"
      end
      print module_ins.modified_time
      print "\n"
      print module_ins.is_viewable
      print "\n"
      print module_ins.is_api_supported
      print "\n"
      print module_ins.is_custom_module
      print "\n"
      print module_ins.is_scoring_supported
      print "\n"
      print module_ins.id
      print "\n"
      print module_ins.module_name
      print "\n"
      print module_ins.business_card_field_limit
      print "\n"
      profiles = module_ins.profiles
      profiles.each do |profile|
        print profile.id
        print "\n"
        print profile.name
      end
      print "\n"
      print module_ins.is_global_search_supported
      print "\n"
      print module_ins.sequence_number
      print "\n"
      print module_ins.is_filter_status
      print "\n"
      print module_ins.is_presence_sub_menu
      print "\n"
      print module_ins.arguments
      print "\n"
      print module_ins.generated_type
      print "\n"
      print module_ins.is_quick_create
      print "\n"
      print module_ins.is_kanban_view_supported
      print "\n"
      print module_ins.is_filter_supported
      print "\n"
      parent_module = module_ins.parent_module
      unless parent_module.nil?
        print parent_module.id
        print "\n"
        print parent_module.api_name
        print "\n"
      end
      print module_ins.is_feeds_required
      print "\n"
      print module_ins.is_email_template_support
      print "\n"
      print module_ins.is_webform_supported
      print "\n"
      print module_ins.visibility
    end
  rescue ZCRMSDK::Utility::ZCRMException => e
    print e.status_code
    print e.error_message
    print e.exception_code
    print e.error_details
    print e.error_content
  end

  def get_module
    rest = ZCRMSDK::RestClient::ZCRMRestClient.get_instance
    module_api_name = 'Leads'
    api_res = rest.get_module(module_api_name)
    module_ins = api_res.data
    print module_ins.api_name
    print "\n"
    print module_ins.is_convertable
    print "\n"
    print module_ins.is_creatable
    print "\n"
    print module_ins.is_editable
    print "\n"
    print module_ins.is_deletable
    print "\n"
    print module_ins.web_link
    print "\n"
    print module_ins.singular_label
    print "\n"
    print module_ins.plural_label
    print "\n"
    modified_by = module_ins.modified_by
    unless modified_by.nil?
      print modified_by.id
      print "\n"
      print modified_by.name
      print "\n"
    end
    print module_ins.modified_time
    print "\n"
    print module_ins.is_viewable
    print "\n"
    print module_ins.is_api_supported
    print "\n"
    print module_ins.is_custom_module
    print "\n"
    print module_ins.is_scoring_supported
    print "\n"
    print module_ins.id
    print "\n"
    print module_ins.module_name
    print "\n"
    print module_ins.business_card_field_limit
    print "\n"
    print module_ins.business_card_fields
    print "\n"
    profiles = module_ins.profiles
    profiles.each do |profile|
      print profile.id
      print "\n"
      print profile.name
    end
    print "\n"
    print module_ins.display_field_name
    print "\n "
    print module_ins.related_lists
    print "\n "
    rel_list_prop = module_ins.related_list_properties
    print rel_list_prop.sort_by
    print "\n"
    print rel_list_prop.sort_order
    print "\n"
    print rel_list_prop.fields
    print "\n"
    print module_ins.properties
    print "\n"
    print module_ins.per_page
    print "\n"
    print module_ins.search_layout_fields
    print "\n"
    print module_ins.default_territory_name
    print "\n"
    print module_ins.default_territory_id
    print "\n"
    print module_ins.default_custom_view_id
    print "\n"
    cv_ins = module_ins.default_custom_view
    print cv_ins.id
    print "\n"
    print cv_ins.module_api_name
    print "\n"
    print cv_ins.display_value
    print "\n"
    print cv_ins.is_default
    print "\n"
    print cv_ins.name
    print "\n"
    print cv_ins.system_name
    print "\n"
    print cv_ins.is_system_defined
    print "\n"
    print cv_ins.shared_details
    print "\n"
    print cv_ins.sort_by
    print "\n"
    print cv_ins.category
    print "\n"
    print cv_ins.fields
    print "\n"
    print cv_ins.favorite
    print "\n "
    print cv_ins.sort_order
    print "\n"
    print cv_ins.criteria_condition
    print "\n"
    cv_criteria = cv_ins.criteria
    print "\n "
    print cv_criteria.comparator
    print "\n"
    print cv_criteria.field
    print "\n"
    print cv_criteria.value
    print "\n"
    print cv_criteria.group # may contain more objects
    print "\n"
    print cv_criteria.group_operator
    print "\n"
    print cv_criteria.pattern
    print "\n"
    print cv_criteria.index
    print "\n"
    print cv_criteria.criteria
    print "\n"
    print cv_ins.categories
    print "\n"
    print cv_ins.is_off_line
    print "\n"
    print module_ins.is_global_search_supported
    print "\n"
    print module_ins.sequence_number
    print "\n"
    print module_ins.is_kanban_view
    print "\n"
    print module_ins.is_filter_status
    print "\n"
    print module_ins.is_presence_sub_menu
    print "\n"
    print module_ins.arguments
    print "\n"
    print module_ins.generated_type
    print "\n"
    print module_ins.is_quick_create
    print "\n"
    print module_ins.is_kanban_view_supported
    print "\n"
    print module_ins.is_filter_supported
    print "\n"
    parent_module = module_ins.parent_module
    unless parent_module.nil?
      print parent_module.id
      print "\n"
      print parent_module.api_name
      print "\n"
    end
    print module_ins.is_feeds_required
    print "\n"
    print module_ins.is_email_template_support
    print "\n"
    print module_ins.is_webform_supported
    print "\n"
    print module_ins.visibility
  rescue ZCRMSDK::Utility::ZCRMException => e
    print e.status_code
    print e.error_message
    print e.exception_code
    print e.error_details
    print e.error_content
  end

  def get_current_user
    rest = ZCRMSDK::RestClient::ZCRMRestClient.get_instance
    api_res = rest.get_current_user
    user_instances = api_res.data
    user_instance = user_instances[0]
    print user_instance.id
    print "\n"
    print user_instance.is_microsoft
    print "\n"
    print user_instance.signature
    print "\n"
    print user_instance.country
    print "\n"
    role = user_instance.role
    print "\n"
    print role.id
    print "\n"
    print role.name
    print "\n"
    customize_info = user_instance.customize_info
    print customize_info
    unless customize_info.nil?
      print customize_info.notes_desc
      print "\n"
      print customize_info.is_to_show_right_panel
      print "\n"
      print customize_info.is_bc_view
      print "\n"
      print customize_info.is_to_show_home
      print "\n"
      print customize_info.is_to_show_detail_view
      print "\n"
      print customize_info.unpin_recent_item
    end
    print "\n"
    print user_instance.city
    print "\n"
    print user_instance.name_format
    print "\n"
    print user_instance.language
    print "\n"
    print user_instance.locale
    print "\n"
    print user_instance.is_personal_account
    print "\n"
    print user_instance.default_tab_group
    print "\n"
    print user_instance.street
    print "\n"
    print user_instance.alias_aka
    print "\n"
    theme = user_instance.theme
    unless theme.nil?
      print theme.normal_tab_font_color
      print "\n"
      print theme.normal_tab_background
      print "\n"
      print theme.selected_tab_font_color
      print "\n"
      print theme.selected_tab_background
      print "\n"
      print theme.new_background
      print "\n"
      print theme.background
      print "\n"
      print theme.screen
      print "\n"
      print theme.type
    end
    print "\n"
    print user_instance.state
    print "\n"
    print user_instance.country_locale
    print "\n"
    print user_instance.fax
    print "\n"
    print user_instance.first_name
    print "\n"
    print user_instance.email
    print "\n"
    print user_instance.zip
    print "\n"
    print user_instance.decimal_separator
    print "\n"
    print user_instance.website
    print "\n"
    print user_instance.time_format
    print "\n"
    profile = user_instance.profile
    print "\n"
    print profile.id
    print "\n"
    print profile.name
    print "\n"
    print user_instance.mobile
    print "\n"
    print user_instance.last_name
    print "\n"
    print user_instance.time_zone
    print "\n"
    print user_instance.zuid
    print "\n"
    print user_instance.is_confirm
    print "\n"
    print user_instance.full_name
    print "\n"
    print user_instance.phone
    print "\n"
    print user_instance.dob
    print "\n"
    print user_instance.date_format
    print "\n"
    print user_instance.status
    print "\n"
    creator = user_instance.created_by
    print "\n"
    print creator.id
    print "\n"
    print creator.name
    print "\n"
    modifier = user_instance.modified_by
    print "\n"
    print modifier.id
    print "\n"
    print modifier.name
    print "\n"
    print user_instance.territories
    print "\n"
    reporting_to = user_instance.reporting_to
    print "\n"
    unless reporting_to.nil?
      print reporting_to.id
      print "\n"
      print reporting_to.name
      print "\n"
    end
    print user_instance.is_online
    print "\n"
    print user_instance.currency
    print "\n"
    print user_instance.created_time
    print "\n"
    print user_instance.modified_time
    print "\n"
  end

  def get_all_roles
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_roles
    roles = api_res.data
    roles.each do |role_instance|
      print role_instance.name
      print "\n"
      print role_instance.id
      print "\n"
      reporting_to = role_instance.reporting_to
      unless reporting_to.nil?
        print reporting_to.name
        print "\n"
        print reporting_to.id
        print "\n"
      end
      print "\n"
      print role_instance.display_label
      print "\n"
      print role_instance.is_admin
      print "\n"
      forecast_manager = role_instance.forecast_manager
      unless forecast_manager.nil?
        print forecast_manager.name
        print "\n"
        print forecast_manager.id
        print "\n"
      end
      print "\n"
      print role_instance.is_share_with_peers
      print "\n"
      print role_instance.description
      print "\n"
    end
  rescue ZCRMSDK::Utility::ZCRMException => e
    print e.status_code
    print e.error_message
    print e.exception_code
    print e.error_details
    print e.error_content
  end

  def get_role
    role_id = "role_id"
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_role(role_id)
    role_instance = api_res.data
    print role_instance.name
    print "\n"
    print role_instance.id
    print "\n"
    reporting_to = role_instance.reporting_to
    unless reporting_to.nil?
      print reporting_to.name
      print "\n"
      print reporting_to.id
      print "\n"
    end
    print "\n"
    print role_instance.display_label
    print "\n"
    print role_instance.is_admin
    print "\n"
    forecast_manager = role_instance.forecast_manager
    unless forecast_manager.nil?
      print forecast_manager.name
      print "\n"
      print forecast_manager.id
      print "\n"
    end
    print "\n"
    print role_instance.is_share_with_peers
    print "\n"
    print role_instance.description
    print "\n"
  rescue ZCRMSDK::Utility::ZCRMException => e
    print e.status_code
    print e.error_message
    print e.exception_code
    print e.error_details
    print e.error_content
  end

  def get_all_profiles
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_profiles
    profiles = api_res.data
    profiles.each do |profile_instance|
      print profile_instance.name
      print "\n"
      print profile_instance.id
      print "\n"
      print profile_instance.is_default
      print "\n"
      print profile_instance.created_time
      print "\n"
      print profile_instance.modified_time
      print "\n"
      modified_by = profile_instance.modified_by
      unless modified_by.nil?
        modified_by.id
        modified_by.name
      end
      print "\n"
      print profile_instance.description
      print "\n"
      created_by = profile_instance.created_by
      unless created_by.nil?
        created_by.id
        created_by.name
      end
      print "\n"
      print profile_instance.category
    end
  end

  def get_profile
    profile_id = 'profile_id'
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_profile(profile_id)
    profile_instance = api_res.data
    print profile_instance.name
    print "\n"
    print profile_instance.id
    print "\n"
    print profile_instance.is_default
    print "\n"
    print profile_instance.created_time
    print "\n"
    print profile_instance.modified_time
    print "\n"
    modified_by = profile_instance.modified_by
    unless modified_by.nil?
      print modified_by.id
      print "\n"
      print modified_by.name
    end
    print "\n"
    print profile_instance.description
    print "\n"
    created_by = profile_instance.created_by
    unless created_by.nil?
      print created_by.id
      print "\n"
      print created_by.name
    end
    print "\n"
    print profile_instance.category
    permissions = profile_instance.permissions
    permissions.each do |permission|
      print "\n"
      print permission.id
      print "\n"
      print permission.name
      print "\n"
      print permission.display_label
      print "\n"
      print permission.module_api_name
      print "\n"
      print permission.is_enabled
    end
    sections = profile_instance.sections
    sections.each do |section|
      print "\n"
      print section.name
      categories = section.categories
      categories.each do |category|
        print "\n"
        print category.name
        print "\n"
        print category.display_label
        print "\n"
        print category.permission_ids
        print "\n"
        print category.module_api_name
      end
    end
  end

  def get_all_user
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    page=1
    per_page=4
    api_res = org.get_all_users(page,per_page)
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_active_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_active_users(1,2)
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_deactive_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_deactive_users
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_confirmed_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_confirmed_users
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_not_confirmed_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_not_confirmed_users
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_deleted_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_deleted_users
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_active_confirmed_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_active_confirmed_users
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_admin_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_admin_users
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_all_active_confirmed_admin_users
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_all_active_confirmed_admin_users
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_user
    user_id = 'user_id'
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_user(user_id)
    user_instance = api_res.data
    print user_instance.id
    print "\n"
    print user_instance.is_microsoft
    print "\n"
    print user_instance.signature
    print "\n"
    print user_instance.country
    print "\n"
    role = user_instance.role
    print "\n"
    print role.id
    print "\n"
    print role.name
    print "\n"
    customize_info = user_instance.customize_info
    print customize_info
    unless customize_info.nil?
      print customize_info.notes_desc
      print "\n"
      print customize_info.is_to_show_right_panel
      print "\n"
      print customize_info.is_bc_view
      print "\n"
      print customize_info.is_to_show_home
      print "\n"
      print customize_info.is_to_show_detail_view
      print "\n"
      print customize_info.unpin_recent_item
    end
    print "\n"
    print user_instance.city
    print "\n"
    print user_instance.name_format
    print "\n"
    print user_instance.language
    print "\n"
    print user_instance.locale
    print "\n"
    print user_instance.is_personal_account
    print "\n"
    print user_instance.default_tab_group
    print "\n"
    print user_instance.street
    print "\n"
    print user_instance.alias_aka
    print "\n"
    theme = user_instance.theme
    unless theme.nil?
      print theme.normal_tab_font_color
      print "\n"
      print theme.normal_tab_background
      print "\n"
      print theme.selected_tab_font_color
      print "\n"
      print theme.selected_tab_background
      print "\n"
      print theme.new_background
      print "\n"
      print theme.background
      print "\n"
      print theme.screen
      print "\n"
      print theme.type
    end
    print "\n"
    print user_instance.state
    print "\n"
    print user_instance.country_locale
    print "\n"
    print user_instance.fax
    print "\n"
    print user_instance.first_name
    print "\n"
    print user_instance.email
    print "\n"
    print user_instance.zip
    print "\n"
    print user_instance.decimal_separator
    print "\n"
    print user_instance.website
    print "\n"
    print user_instance.time_format
    print "\n"
    profile = user_instance.profile
    print "\n"
    print profile.id
    print "\n"
    print profile.name
    print "\n"
    print user_instance.mobile
    print "\n"
    print user_instance.last_name
    print "\n"
    print user_instance.time_zone
    print "\n"
    print user_instance.zuid
    print "\n"
    print user_instance.is_confirm
    print "\n"
    print user_instance.full_name
    print "\n"
    print user_instance.phone
    print "\n"
    print user_instance.dob
    print "\n"
    print user_instance.date_format
    print "\n"
    print user_instance.status
    print "\n"
    creator = user_instance.created_by
    print "\n"
    print creator.id
    print "\n"
    print creator.name
    print "\n"
    modifier = user_instance.modified_by
    print "\n"
    print modifier.id
    print "\n"
    print modifier.name
    print "\n"
    print user_instance.territories
    print "\n"
    reporting_to = user_instance.reporting_to
    print "\n"
    unless reporting_to.nil?
      print reporting_to.id
      print "\n"
      print reporting_to.name
      print "\n"
    end
    print user_instance.is_online
    print "\n"
    print user_instance.currency
    print "\n"
    print user_instance.created_time
    print "\n"
    print user_instance.modified_time
    print "\n"
  end

  def create_user
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    user_instance = ZCRMSDK::Operations::ZCRMUser.get_instance
    profile_id = 'profile_id'
    role_id = 'role_id'
    user_instance.profile = ZCRMSDK::Operations::ZCRMProfile.get_instance(profile_id)
    user_instance.role = ZCRMSDK::Operations::ZCRMRole.get_instance(role_id)
    user_instance.country = 'India'
    user_instance.name = 'asdsad'
    user_instance.city = 'chennai'
    user_instance.signature = 'asdsd'
    user_instance.name_format = 'Salutation,First Name,Last Name'
    user_instance.locale = 'hi_IN'
    user_instance.is_personal_account = false
    user_instance.default_tab_group = '0'
    user_instance.street = 'Asdd'
    user_instance.alias_aka = 'asdd'
    user_instance.state = 'Tamil Nadu'
    user_instance.fax = '42342'
    user_instance.first_name = 'dum'
    user_instance.email = 'prasde@afafaassdsdassdsdsdff.com'
    user_instance.zip = '600010'
    user_instance.decimal_separator = 'en_IN'
    user_instance.website = 'www.zoho.com'
    user_instance.time_format = 'hh:mm a'
    user_instance.mobile = '34234324'
    user_instance.last_name = 'dum_asdsaddum'
    user_instance.phone = '2343243242'
    user_instance.date_format = 'yyyy/MM/dd'
    user_instance.dob = '1997-12-29'
    resp = org.create_user(user_instance)
    print resp.code
    print resp.message
    print resp.details
  end

  def update_user
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    user_id = "user_id"
    user_name = "user_name"
    profile_id = 'profile_id'
    role_id = 'role_id'
    user_instance = ZCRMSDK::Operations::ZCRMUser.get_instance(user_id, user_name)
    user_instance.profile = ZCRMSDK::Operations::ZCRMProfile.get_instance(profile_id, nil)
    user_instance.role = ZCRMSDK::Operations::ZCRMRole.get_instance(role_id, nil)
    user_instance.country = 'India'
    user_instance.city = 'sd'
    user_instance.signature = 'sddsd'
    user_instance.name_format = 'Salutation,First Name,Last Name'
    user_instance.locale = 'hi_IN'
    user_instance.street = 'Asdd'
    user_instance.alias_aka = 'asdd'
    user_instance.state = 'Tamil Nadu'
    user_instance.fax = '42342'
    user_instance.first_name = 'dum'
    user_instance.zip = '60010'
    user_instance.website = 'www.zoho.com'
    user_instance.time_format = 'hh:mm a'
    user_instance.mobile = '34234324'
    user_instance.last_name = 'dum_dum'
    user_instance.phone = '2343243242'
    user_instance.date_format = 'yyyy/MM/dd'
    user_instance.dob = '1997-12-29'
    resp = org.update_user(user_instance)
    print resp.code
    print resp.message
    print resp.details
  end

  def delete_user
    user_id = "user_id"
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    resp = org.delete_user(user_id)
    print resp.code
    print resp.message
    print resp.details
  end

  def get_organization_taxes
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_organization_taxes
    org_taxes = api_res.data
    org_taxes.each do |org_tax_instance|
      print org_tax_instance.id
      print "\n"
      print org_tax_instance.name
      print "\n"
      print org_tax_instance.display_label
      print "\n"
      print org_tax_instance.value
      print "\n"
    end
  end

  def get_organization_tax
    org_tax_id = 'org_tax_id'
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_organization_tax(org_tax_id)
    org_tax_instance = api_res.data
    print org_tax_instance.id
    print "\n"
    print org_tax_instance.name
    print "\n"
    print org_tax_instance.display_label
    print "\n"
    print org_tax_instance.value
    print "\n"
  end

  def create_organization_taxes
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    orgtax_instances = []
    orgtax_instance = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
    orgtax_instance.display_label = 'assaadsadsddsddsdsad'
    orgtax_instance.name = 'aaasaasdssdsdds'
    orgtax_instance.value = 22
    orgtax_instance.sequence_number = 1
    orgtax_instances.push(orgtax_instance)
    api_res = org.create_organization_taxes(orgtax_instances).bulk_entity_response
    api_res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def update_organization_taxes
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    orgtax_instances = []
    orgtax_instance = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
    orgtax_instance.id = 'org_tax_id_1'
    orgtax_instance.name = 'ads'
    orgtax_instance.value = 22
    orgtax_instances.push(orgtax_instance)
    api_res = org.update_organization_taxes(orgtax_instances).bulk_entity_response
    api_res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def delete_organization_taxes
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    org_tax_ids = []
  
    org_tax_ids.push("org_tax_id_1")
    org_tax_ids.push("org_tax_id_2")
    org_tax_ids.push("org_tax_id_3")
    org_tax_ids.push("org_tax_id_4")
    org_tax_ids.push("org_tax_id_5")
    org_tax_ids.push("org_tax_id_6")
    api_res = org.delete_organization_taxes(org_tax_ids).bulk_entity_response
    api_res.each do |response|
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def delete_organization_tax
    org_tax_id = 'org_tax_id'
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    resp = org.delete_organization_tax(org_tax_id)
    print resp.code
    print resp.message
    print resp.details
  end

  def search_user_by_criteria
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    criteria = 'country:starts_with:I*'
    type = nil
    api_res = org.search_users_by_criteria(criteria, type)
    users = api_res.data
    users.each do |user_instance|
      print user_instance.id
      print "\n"
      print user_instance.is_microsoft
      print "\n"
      print user_instance.signature
      print "\n"
      print user_instance.country
      print "\n"
      role = user_instance.role
      print "\n"
      print role.id
      print "\n"
      print role.name
      print "\n"
      customize_info = user_instance.customize_info
      print customize_info
      unless customize_info.nil?
        print customize_info.notes_desc
        print "\n"
        print customize_info.is_to_show_right_panel
        print "\n"
        print customize_info.is_bc_view
        print "\n"
        print customize_info.is_to_show_home
        print "\n"
        print customize_info.is_to_show_detail_view
        print "\n"
        print customize_info.unpin_recent_item
      end
      print "\n"
      print user_instance.city
      print "\n"
      print user_instance.name_format
      print "\n"
      print user_instance.language
      print "\n"
      print user_instance.locale
      print "\n"
      print user_instance.is_personal_account
      print "\n"
      print user_instance.default_tab_group
      print "\n"
      print user_instance.street
      print "\n"
      print user_instance.alias_aka
      print "\n"
      theme = user_instance.theme
      unless theme.nil?
        print theme.normal_tab_font_color
        print "\n"
        print theme.normal_tab_background
        print "\n"
        print theme.selected_tab_font_color
        print "\n"
        print theme.selected_tab_background
        print "\n"
        print theme.new_background
        print "\n"
        print theme.background
        print "\n"
        print theme.screen
        print "\n"
        print theme.type
      end
      print "\n"
      print user_instance.state
      print "\n"
      print user_instance.country_locale
      print "\n"
      print user_instance.fax
      print "\n"
      print user_instance.first_name
      print "\n"
      print user_instance.email
      print "\n"
      print user_instance.zip
      print "\n"
      print user_instance.decimal_separator
      print "\n"
      print user_instance.website
      print "\n"
      print user_instance.time_format
      print "\n"
      profile = user_instance.profile
      print "\n"
      print profile.id
      print "\n"
      print profile.name
      print "\n"
      print user_instance.mobile
      print "\n"
      print user_instance.last_name
      print "\n"
      print user_instance.time_zone
      print "\n"
      print user_instance.zuid
      print "\n"
      print user_instance.is_confirm
      print "\n"
      print user_instance.full_name
      print "\n"
      print user_instance.phone
      print "\n"
      print user_instance.dob
      print "\n"
      print user_instance.date_format
      print "\n"
      print user_instance.status
      print "\n"
      creator = user_instance.created_by
      print "\n"
      print creator.id
      print "\n"
      print creator.name
      print "\n"
      modifier = user_instance.modified_by
      print "\n"
      print modifier.id
      print "\n"
      print modifier.name
      print "\n"
      print user_instance.territories
      print "\n"
      reporting_to = user_instance.reporting_to
      print "\n"
      unless reporting_to.nil?
        print reporting_to.id
        print "\n"
        print reporting_to.name
        print "\n"
      end
      print user_instance.is_online
      print "\n"
      print user_instance.currency
      print "\n"
      print user_instance.created_time
      print "\n"
      print user_instance.modified_time
      print "\n"
    end
  end

  def get_records_from_custom_view
    customviewid = 'customviewid'
    module_api_name = 'module_api_name'
    customview_ins = ZCRMSDK::Operations::ZCRMCustomView.get_instance(customviewid, module_api_name)
    sort_by = 'field_api_name'
    sort_order = 'asc/desc'
    page = 1
    per_page = 200
    headers = {'If-Modified-Since' => '2019-07-25T15:26:49+05:30'}
    api_res = customview_ins.get_records(sort_by, sort_order, page, per_page, headers) # sort_by, sort_order, page, per_page, headers are not mandatory
    records = api_res.data
    records.each do |record|
      print 'module_api_name '
      print record.module_api_name
      print "\n id "
      print record.entity_id
      line_items = record.line_items
      line_items.each do |line_item|
        print "\n id "
        print line_item.id
        product = line_item.product
        print "\n entity_id "
        print product.entity_id
        print "\n lookup_label "
        print product.lookup_label
        print "\n Product_Code "
        print product.field_data['Product_Code']
        print "\n list_price "
        print line_item.list_price
        print "\n quantity "
        print line_item.quantity
        print "\n  description "
        print line_item.description
        print "\n total "
        print line_item.total
        print "\n discount "
        print line_item.discount
        print "\n total_after_discount "
        print line_item.total_after_discount
        print "\n tax_amount "
        print line_item.tax_amount
        print "\n net_total "
        print line_item.net_total
        print "\n delete_flag "
        print line_item.delete_flag
        line_taxes = line_item.line_tax
        next if line_taxes.nil?

        line_taxes.each do |line_tax|
          print "\n name "
          print line_tax.name
          print "\n percentage "
          print line_tax.percentage
          print "\n  value "
          print line_tax.value
        end
      end
      owner = record.owner
      unless owner.nil?
        print "\n id "
        print owner.id
        print "\n name "
        print owner.name
      end
      created_by = record.created_by
      unless created_by.nil?
        print "\n id "
        print created_by.id
        print "\n name "
        print created_by.name
      end
      modified_by = record.modified_by
      unless owner.nil?
        print "\n  id "
        print modified_by.id
        print "\n name "
        print modified_by.name
      end
      print "\n created_time "
      print record.created_time
      print "\n modified_time "
      print record.modified_time
      print record.properties
      participants = record.participants
      participants.each do |participant|
        print "\n name "
        print participant.name
        print "\n email "
        print participant.email
        print  "\n is_invited "
        print  participant.is_invited
        print  "\n status "
        print  participant.status
        print  "\n type "
        print  participant.type
      end
      pricing_instances = record.price_details
      pricing_instances.each do |pricing_instance|
        print "\n id "
        print pricing_instance.id
        print "\n discount "
        print pricing_instance.discount
        print "\n to_range "
        print pricing_instance.to_range
        print "\n from_range "
        print pricing_instance.from_range
      end
      layout = record.layout
      unless layout.nil?
        print "\n id "
        print layout.id
        print "\n name "
        print layout.name
      end
      tax_list = record.tax_list
      tax_list.each do |tax|
        print "\n name "
        print tax.name
      end
      print record.last_activity_time
      tags = record.tags
      tags.each do |tag|
        print "\n id "
        print tag.id
        print "\n name "
        print tag.name
      end
      fields = record.field_data
      fields.each do |key, field_value|
        print "\n key "
        print key
        print "\t field_value "
        print field_value
      end
      print "\n "
    end
  end

  def get_all_fields
    module_api_name = 'module_api_name'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_all_fields
    fields = api_res.data
    fields.each do |field_instance|
      print field_instance.api_name
      print "\n"
      print field_instance.is_webhook
      print "\n"
      print field_instance.crypt
      print "\n  "
      unless field_instance.tooltip.nil?
        print field_instance.tooltip['name']
        print "\n"
        print field_instance.tooltip['value']
        print "\n  "
      end
      print field_instance.is_field_read_only
      print "\n"
      print field_instance.association_details
      print "\n"
      print field_instance.subform
      print "\n"
      print field_instance.is_mass_update
      print "\n"
      multiselectlookup = field_instance.multiselectlookup
      unless multiselectlookup.nil?
        print multiselectlookup.display_label
        print "\n"
        print multiselectlookup.linking_module
        print "\n"
        print multiselectlookup.connected_module
        print "\n"
        print multiselectlookup.api_name
        print "\n"
        print multiselectlookup.id
      end
      print field_instance.is_custom_field
      print "\n"
      print field_instance.lookup_field
      print "\n"
      print field_instance.convert_mapping
      print "\n"
      print field_instance.is_visible
      print "\n"
      print field_instance.field_label
      print "\n"
      print field_instance.length
      print "\n"
      print field_instance.created_source
      print "\n"
      print field_instance.default_value
      print "\n"
      print field_instance.is_mandatory
      print "\n"
      print field_instance.sequence_number
      print "\n"
      print field_instance.is_read_only
      print "\n"
      print field_instance.is_unique_field
      print "\n"
      print field_instance.is_case_sensitive
      print "\n"
      print field_instance.data_type
      print "\n"
      print field_instance.is_formula_field
      print "\n"
      print field_instance.is_currency_field
      print "\n"
      print field_instance.id
      print "\n"
      picklist_values = field_instance.picklist_values
      print "\n"
      picklist_values.each do |picklist_instance|
        print picklist_instance.display_value
        print "\n"
        print picklist_instance.sequence_number
        print "\n"
        print picklist_instance.actual_value
        print "\n"
        print picklist_instance.maps
      end
      print field_instance.is_auto_number
      print "\n"
      print field_instance.is_business_card_supported
      print "\n"
      print field_instance.field_layout_permissions
      print "\n"
      print field_instance.decimal_place
      print "\n"
      print field_instance.precision
      print "\n"
      print field_instance.rounding_option
      print "\n"
      print field_instance.formula_return_type
      print "\n"
      print field_instance.formula_expression
      print "\n"
      print field_instance.prefix
      print "\n"
      print field_instance.suffix
      print "\n"
      print field_instance.start_number
      print "\n"
      print field_instance.json_type
    end
  end

  def get_field
    module_api_name = 'module_api_name'
    field_id = 'field_id'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_field(field_id)
    field_instance = api_res.data
    print field_instance.api_name
    print "\n"
    print field_instance.is_webhook
    print "\n"
    print field_instance.crypt
    print "\n"
    print field_instance.tooltip
    print "\n"
    print field_instance.is_field_read_only
    print "\n"
    print field_instance.association_details
    print "\n"
    print field_instance.subform
    print "\n"
    print field_instance.is_mass_update
    print "\n"
    multiselectlookup = field_instance.multiselectlookup
    unless multiselectlookup.empty?
      print multiselectlookup.display_label
      print "\n"
      print multiselectlookup.linking_module
      print "\n"
      print multiselectlookup.connected_module
      print "\n"
      print multiselectlookup.api_name
      print "\n"
      print multiselectlookup.id
    end
    print field_instance.is_custom_field
    print "\n"
    print field_instance.lookup_field
    print "\n"
    print field_instance.convert_mapping
    print "\n"
    print field_instance.is_visible
    print "\n"
    print field_instance.field_label
    print "\n"
    print field_instance.length
    print "\n"
    print field_instance.created_source
    print "\n"
    print field_instance.default_value
    print "\n"
    print field_instance.is_mandatory
    print "\n"
    print field_instance.sequence_number
    print "\n"
    print field_instance.is_read_only
    print "\n"
    print field_instance.is_unique_field
    print "\n"
    print field_instance.is_case_sensitive
    print "\n"
    print field_instance.data_type
    print "\n"
    print field_instance.is_formula_field
    print "\n"
    print field_instance.is_currency_field
    print "\n"
    print field_instance.id
    print "\n"
    picklist_values = field_instance.picklist_values
    print "\n"
    picklist_values.each do |picklist_instance|
      print picklist_instance.display_value
      print "\n"
      print picklist_instance.sequence_number
      print "\n"
      print picklist_instance.actual_value
      print "\n"
      print picklist_instance.maps
    end
    print field_instance.is_auto_number
    print "\n"
    print field_instance.is_business_card_supported
    print "\n"
    print field_instance.field_layout_permissions
    print "\n"
    print field_instance.decimal_place
    print "\n"
    print field_instance.precision
    print "\n"
    print field_instance.rounding_option
    print "\n"
    print field_instance.formula_return_type
    print "\n"
    print field_instance.formula_expression
    print "\n"
    print field_instance.prefix
    print "\n"
    print field_instance.suffix
    print "\n"
    print field_instance.start_number
    print "\n"
    print field_instance.json_type
  end

  def get_all_layouts
    module_apiname = 'module_apiname'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_apiname)
    api_res = module_instance.get_all_layouts
    layouts = api_res.data
    layouts.each do |layout|
      print layout.id
      print "\n"
      print layout.name
      print "\n"
      print layout.created_time
      print "\n"
      print layout.modified_time
      print "\n"
      print layout.is_visible
      print "\n"
      unless layout.modified_by.nil?
        print layout.modified_by.id
        print "\n"
        print layout.modified_by.name
        print "\n"
      end
      unless layout.created_by.nil?
        print layout.created_by.id
        print "\n"
        print layout.created_by.name
        print "\n"
      end
      profiles = layout.accessible_profiles
      profiles.each do |profile|
        print profile.is_default
        print "\n"
        print profile.name
        print "\n"
        print profile.id
        print "\n"
      end
      sections = layout.sections
      sections.each do |section|
        print section.name
        print "\n"
        print section.display_label
        print "\n"
        print section.column_count
        print "\n"
        print section.sequence_number
        print "\n"
        fields = section.fields
        fields.each do |field_instance|
          print field_instance.api_name
          print "\n"
          print field_instance.is_webhook
          print "\n"
          print field_instance.crypt
          print "\n"
          print field_instance.tooltip
          print "\n"
          print field_instance.is_field_read_only
          print "\n"
          print field_instance.association_details
          print "\n"
          print field_instance.subform
          print "\n"
          print field_instance.is_mass_update
          print "\n"
          multiselectlookup = field_instance.multiselectlookup
          unless multiselectlookup.nil?
            print multiselectlookup.display_label
            print "\n"
            print multiselectlookup.linking_module
            print "\n"
            print multiselectlookup.connected_module
            print "\n"
            print multiselectlookup.api_name
            print "\n"
            print multiselectlookup.id
          end
          print field_instance.is_custom_field
          print "\n"
          print field_instance.lookup_field
          print "\n"
          print field_instance.convert_mapping
          print "\n"
          print field_instance.is_visible
          print "\n"
          print field_instance.field_label
          print "\n"
          print field_instance.length
          print "\n"
          print field_instance.created_source
          print "\n"
          print field_instance.default_value
          print "\n"
          print field_instance.is_mandatory
          print "\n"
          print field_instance.sequence_number
          print "\n"
          print field_instance.is_read_only
          print "\n"
          print field_instance.is_unique_field
          print "\n"
          print field_instance.is_case_sensitive
          print "\n"
          print field_instance.data_type
          print "\n"
          print field_instance.is_formula_field
          print "\n"
          print field_instance.is_currency_field
          print "\n"
          print field_instance.id
          print "\n"
          picklist_values = field_instance.picklist_values
          print "\n"
          picklist_values.each do |picklist_instance|
            print picklist_instance.display_value
            print "\n"
            print picklist_instance.sequence_number
            print "\n"
            print picklist_instance.actual_value
            print "\n"
            print picklist_instance.maps
          end
          print field_instance.is_auto_number
          print "\n"
          print field_instance.is_business_card_supported
          print "\n"
          print field_instance.field_layout_permissions
          print "\n"
          print field_instance.decimal_place
          print "\n"
          print field_instance.precision
          print "\n"
          print field_instance.rounding_option
          print "\n"
          print field_instance.formula_return_type
          print "\n"
          print field_instance.formula_expression
          print "\n"
          print field_instance.prefix
          print "\n"
          print field_instance.suffix
          print "\n"
          print field_instance.start_number
          print "\n"
          print field_instance.json_type
        end
        print section.is_subform_section
        print "\n"
        print section.tab_traversal
        print "\n"
        print section.api_name
        print "\n"
        properties = section.properties
        next if properties.nil?

        print "\n"
        print properties.reorder_rows
        print "\n"
        print properties.tooltip
        print "\n"
        print properties.maximum_rows
      end
      print 'asdadasds'
      print "\n"
      print layout.status
      print "\n"
      convert_mappings = layout.convert_mapping
      convert_mappings.each do |_key, convert_mapping|
        print convert_mapping.name
        print "\n"
        print convert_mapping.id
        print "\n"
        convert_mapping_fields = convert_mapping.fields
        next if convert_mapping_fields.nil?

        convert_mapping_fields.each do |convert_mapping_field|
          print "\n"
          print convert_mapping_field.id
          print "\n"
          print convert_mapping_field.api_name
          print "\n"
          print convert_mapping_field.field_label
          print "\n"
          print convert_mapping_field.is_required
        end
      end
    end
  end

  def get_layout
    module_apiname = 'module_apiname'
    layout_id = 'layout_id'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_apiname)
    api_res = module_instance.get_layout(layout_id)
    layout = api_res.data
    print layout.id
    print "\n"
    print layout.name
    print "\n"
    print layout.created_time
    print "\n"
    print layout.modified_time
    print "\n"
    print layout.is_visible
    print "\n"
    unless layout.modified_by.nil?
      print layout.modified_by.id
      print "\n"
      print layout.modified_by.name
      print "\n"
    end
    unless layout.created_by.nil?
      print layout.created_by.id
      print "\n"
      print layout.created_by.name
      print "\n"
    end
    profiles = layout.accessible_profiles
    profiles.each do |profile|
      print profile.is_default
      print "\n"
      print profile.name
      print "\n"
      print profile.id
      print "\n"
    end
    sections = layout.sections
    sections.each do |section|
      print section.name
      print "\n"
      print section.display_label
      print "\n"
      print section.column_count
      print "\n"
      print section.sequence_number
      print "\n"
      fields = section.fields
      fields.each do |field_instance|
        print field_instance.api_name
        print "\n"
        print field_instance.is_webhook
        print "\n"
        print field_instance.crypt
        print "\n"
        print field_instance.tooltip
        print "\n"
        print field_instance.is_field_read_only
        print "\n"
        print field_instance.association_details
        print "\n"
        print field_instance.subform
        print "\n"
        print field_instance.is_mass_update
        print "\n"
        multiselectlookup = field_instance.multiselectlookup
        unless multiselectlookup.nil?
          print multiselectlookup.display_label
          print "\n"
          print multiselectlookup.linking_module
          print "\n"
          print multiselectlookup.connected_module
          print "\n"
          print multiselectlookup.api_name
          print "\n"
          print multiselectlookup.id
        end
        print field_instance.is_custom_field
        print "\n"
        print field_instance.lookup_field
        print "\n"
        print field_instance.convert_mapping
        print "\n"
        print field_instance.is_visible
        print "\n"
        print field_instance.field_label
        print "\n"
        print field_instance.length
        print "\n"
        print field_instance.created_source
        print "\n"
        print field_instance.default_value
        print "\n"
        print field_instance.is_mandatory
        print "\n"
        print field_instance.sequence_number
        print "\n"
        print field_instance.is_read_only
        print "\n"
        print field_instance.is_unique_field
        print "\n"
        print field_instance.is_case_sensitive
        print "\n"
        print field_instance.data_type
        print "\n"
        print field_instance.is_formula_field
        print "\n"
        print field_instance.is_currency_field
        print "\n"
        print field_instance.id
        print "\n"
        picklist_values = field_instance.picklist_values
        print "\n"
        picklist_values.each do |picklist_instance|
          print picklist_instance.display_value
          print "\n"
          print picklist_instance.sequence_number
          print "\n"
          print picklist_instance.actual_value
          print "\n"
          print picklist_instance.maps
        end
        print field_instance.is_auto_number
        print "\n"
        print field_instance.is_business_card_supported
        print "\n"
        print field_instance.field_layout_permissions
        print "\n"
        print field_instance.decimal_place
        print "\n"
        print field_instance.precision
        print "\n"
        print field_instance.rounding_option
        print "\n"
        print field_instance.formula_return_type
        print "\n"
        print field_instance.formula_expression
        print "\n"
        print field_instance.prefix
        print "\n"
        print field_instance.suffix
        print "\n"
        print field_instance.start_number
        print "\n"
        print field_instance.json_type
      end
      print section.is_subform_section
      print "\n"
      print section.tab_traversal
      print "\n"
      print section.api_name
      print "\n"
      properties = section.properties
      next if properties.nil?

      print "\n"
      print properties.reorder_rows
      print "\n"
      print properties.tooltip
      print "\n"
      print properties.maximum_rows
    end
    print "\n"
    print layout.status
    print "\n"
    convert_mappings = layout.convert_mapping
    convert_mappings.each do |_key, convert_mapping|
      print convert_mapping.name
      print "\n"
      print convert_mapping.id
      print "\n"
      convert_mapping_fields = convert_mapping.fields
      next if convert_mapping_fields.nil?

      convert_mapping_fields.each do |convert_mapping_field|
        print "\n"
        print convert_mapping_field.id
        print "\n"
        print convert_mapping_field.api_name
        print "\n"
        print convert_mapping_field.field_label
        print "\n"
        print convert_mapping_field.is_required
      end
    end
  end

  def get_all_customviews
    module_apiname = 'module_apiname'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_apiname)
    api_res = module_instance.get_all_customviews
    customviews = api_res.data
    customviews.each do |cv_ins|
      print cv_ins.id
      print "\n"
      print cv_ins.display_value
      print "\n"
      print cv_ins.is_default
      print "\n"
      print cv_ins.name
      print "\n"
      print cv_ins.system_name
      print "\n"
      print cv_ins.is_system_defined
      print "\n"
      print cv_ins.category
      print "\n"
      print cv_ins.is_off_line
      print "\n"
    end
  end

  def get_customview
    module_apiname = 'module_apiname'
    customview_id = 'customview_id'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_apiname)
    api_res = module_instance.get_customview(customview_id)
    cv_ins = api_res.data
    print cv_ins.id
    print "\n"
    print cv_ins.module_api_name
    print "\n"
    print cv_ins.display_value
    print "\n"
    print cv_ins.is_default
    print "\n"
    print cv_ins.name
    print "\n"
    print cv_ins.system_name
    print "\n"
    print cv_ins.is_system_defined
    print "\n"
    print cv_ins.shared_details
    print "\n"
    print cv_ins.sort_by
    print "\n"
    print cv_ins.category
    print "\n"
    print cv_ins.fields
    print "\n"
    print cv_ins.favorite
    print "\n "
    print cv_ins.sort_order
    print "\n"
    print cv_ins.criteria_condition
    print "\n"
    cv_criteria = cv_ins.criteria
    print "\n "
    print cv_criteria.comparator # if single condition
    print "\n"
    print cv_criteria.field # if single condition
    print "\n"
    print cv_criteria.value # if single condition
    print "\n"
    print cv_criteria.group # may contain more objects(more than one condition
    print "\n"
    print cv_criteria.group_operator
    print "\n"
    print cv_criteria.pattern
    print "\n"
    print cv_criteria.index
    print "\n"
    print cv_criteria.criteria
    print "\n"
    print cv_ins.categories
    print "\n"
    print cv_ins.is_off_line
    print "\n"
  end

  def update_custom_view
    module_api_name = 'module_api_name'
    customview_id = 'customview_id'
    field_api_name = 'field_api_name'
    field_id = 'field_id'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    customview_instance = ZCRMSDK::Operations::ZCRMCustomView.get_instance(customview_id)
    customview_instance.sort_by = ZCRMSDK::Operations::ZCRMField.get_instance(field_api_name, field_id)
    customview_instance.sort_order = 'desc'
    print customview_instance.inspect
    res = module_instance.update_customview(customview_instance)
    print res.inspect
  end

  def get_all_relatedlists
    module_api_name = 'module_api_name'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_all_relatedlists
    relatedlists = api_res.data
    relatedlists.each do |relatedlist_ins|
      print "\n"
      print relatedlist_ins.api_name
      print "\n"
      print relatedlist_ins.id
      print "\n"
      print relatedlist_ins.module_apiname
      print "\n"
      print relatedlist_ins.display_label
      print "\n"
      print relatedlist_ins.name
      print "\n"
      print relatedlist_ins.type
      print "\n"
      print relatedlist_ins.href
      print "\n"
      print relatedlist_ins.is_visible
      print "\n"
      print relatedlist_ins.action
      print "\n"
      print relatedlist_ins.sequence_number
    end
  end

  def get_relatedlist
    module_api_name = 'module_api_name'
    related_list_id = 'related_list_id'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_relatedlist(related_list_id)
    relatedlist_ins = api_res.data
    print "\n"
    print relatedlist_ins.api_name
    print "\n"
    print relatedlist_ins.id
    print "\n"
    print relatedlist_ins.module_apiname
    print "\n"
    print relatedlist_ins.display_label
    print "\n"
    print relatedlist_ins.name
    print "\n"
    print relatedlist_ins.type
    print "\n"
    print relatedlist_ins.href
    print "\n"
    print relatedlist_ins.is_visible
    print "\n "
    print relatedlist_ins.action
    print "\n "
    print relatedlist_ins.sequence_number
  end

  def get_records
    customviewid = 'customviewid'
    module_api_name = 'module_api_name'
    sort_by_field = 'field_api_name'
    sort_order = 'asc/desc'
    page = 1
    per_page = 200
    headers = {'If-Modified-Since' => '2019-07-25T15:26:49+05:30'}
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_records(customviewid, sort_by_field, sort_order, page, per_page, headers) # customviewid ,sort_by, sort_order, page, per_page, headers are not mandatory
    records = api_res.data
    records.each do |record|
      print 'module_api_name '
      print record.module_api_name
      print "\n id "
      print record.entity_id
       line_items = record.line_items
       line_items.each do |line_item|
         print "\n id "
         print line_item.id
         product = line_item.product
         print "\n entity_id "
         print product.entity_id
         print "\n lookup_label "
         print product.lookup_label
         print "\n Product_Code "
         print product.field_data['Product_Code']
         print "\n list_price "
         print line_item.list_price
         print "\n quantity "
         print line_item.quantity
         print "\n  description "
         print line_item.description
         print "\n total "
         print line_item.total
         print "\n discount "
         print line_item.discount
         print "\n total_after_discount "
         print line_item.total_after_discount
         print "\n tax_amount "
         print line_item.tax_amount
         print "\n net_total "
         print line_item.net_total
         print "\n delete_flag "
         print line_item.delete_flag
         line_taxes = line_item.line_tax
         next if line_taxes.nil?

         line_taxes.each do |line_tax|
           print "\n name "
           print line_tax.name
           print "\n percentage "
           print line_tax.percentage
           print "\n  value "
           print line_tax.value
         end
       end
       owner = record.owner
       unless owner.nil?
         print "\n id "
         print owner.id
         print "\n name "
         print owner.name
       end
       created_by = record.created_by
       unless created_by.nil?
         print "\n id "
         print created_by.id
         print "\n name "
         print created_by.name
       end
       modified_by = record.modified_by
       unless owner.nil?
         print "\n  id "
         print modified_by.id
         print "\n name "
         print modified_by.name
       end
       print "\n created_time "
       print record.created_time
       print "\n modified_time "
       print record.modified_time
       print record.properties
       participants = record.participants
       participants.each do |participant|
         print "\n name "
         print participant.name
         print "\n email "
         print participant.email
         print  "\n is_invited "
         print  participant.is_invited
         print  "\n status "
         print  participant.status
         print  "\n type "
         print  participant.type
       end
       pricing_instances = record.price_details
       pricing_instances.each do |pricing_instance|
         print "\n id "
         print pricing_instance.id
         print "\n discount "
         print pricing_instance.discount
         print "\n to_range "
         print pricing_instance.to_range
         print "\n from_range "
         print pricing_instance.from_range
       end
       layout = record.layout
       unless layout.nil?
         print "\n id "
         print layout.id
         print "\n name "
         print layout.name
       end
       tax_list = record.tax_list
       tax_list.each do |tax|
         print "\n name "
         print tax.name
       end
       print record.last_activity_time
       tags = record.tags
       tags.each do |tag|
         print "\n id "
         print tag.id
         print "\n name "
         print tag.name
       end
       fields = record.field_data
       fields.each do |key, field_value|
         print "\n key "
         print key
         print "\t field_value "
         print field_value
       end
       print "\n "
    end
  end

  def get_record
    module_api_name = 'Accounts'
    entity_id = '3524033000003350015'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_record(entity_id)
    record = api_res.data
    print 'module_api_name '
    print record.module_api_name
    print "\n id "
    print record.entity_id
    line_items = record.line_items
    line_items.each do |line_item|
      print "\n id "
      print line_item.id
      product = line_item.product
      print "\n entity_id "
      print product.entity_id
      print "\n lookup_label "
      print product.lookup_label
      print "\n Product_Code "
      print product.field_data['Product_Code']
      print "\n list_price "
      print line_item.list_price
      print "\n quantity "
      print line_item.quantity
      print "\n  description "
      print line_item.description
      print "\n total "
      print line_item.total
      print "\n discount "
      print line_item.discount
      print "\n total_after_discount "
      print line_item.total_after_discount
      print "\n tax_amount "
      print line_item.tax_amount
      print "\n net_total "
      print line_item.net_total
      print "\n delete_flag "
      print line_item.delete_flag
      line_taxes = line_item.line_tax
      next if line_taxes.nil?

      line_taxes.each do |line_tax|
        print "\n name "
        print line_tax.name
        print "\n percentage "
        print line_tax.percentage
        print "\n  value "
        print line_tax.value
      end
    end
    owner = record.owner
    unless owner.nil?
      print "\n id "
      print owner.id
      print "\n name "
      print owner.name
    end
    created_by = record.created_by
    unless created_by.nil?
      print "\n id "
      print created_by.id
      print "\n name "
      print created_by.name
    end
    modified_by = record.modified_by
    unless owner.nil?
      print "\n  id "
      print modified_by.id
      print "\n name "
      print modified_by.name
    end
    print "\n created_time "
    print record.created_time
    print "\n modified_time "
    print record.modified_time
    print record.properties
    participants = record.participants
    participants.each do |participant|
      print "\n name "
      print participant.name
      print "\n email "
      print participant.email
      print  "\n is_invited "
      print  participant.is_invited
      print  "\n status "
      print  participant.status
      print  "\n type "
      print  participant.type
    end
    pricing_instances = record.price_details
    pricing_instances.each do |pricing_instance|
      print "\n id "
      print pricing_instance.id
      print "\n discount "
      print pricing_instance.discount
      print "\n to_range "
      print pricing_instance.to_range
      print "\n from_range "
      print pricing_instance.from_range
    end
    layout = record.layout
    unless layout.nil?
      print "\n id "
      print layout.id
      print "\n name "
      print layout.name
    end
    tax_list = record.tax_list
    tax_list.each do |tax|
      print "\n name "
      print tax.name
    end
    print record.last_activity_time
    tags = record.tags
    tags.each do |tag|
      print "\n id "
      print tag.id
      print "\n name "
      print tag.name
    end
    fields = record.field_data
    fields.each do |key, field_value|
      print "\n key "
      print key
      print "\t field_value "
      print field_value
    end
    print "\n "
  end

  def get_all_deleted_records
    module_api_name = 'module_api_name'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_all_deleted_records
    trash_records = api_res.data
    trash_records.each do |trash_record|
      print "\n "
      print trash_record.id
      print "\n "
      print trash_record.type
      print "\n "
      print trash_record.display_name
      print "\n "
      print trash_record.deleted_time
      print "\n "
      created_by = trash_record.created_by
      unless created_by.nil?
        print "\n "
        print created_by.id
        print "\n "
        print created_by.name
      end
      deleted_by = trash_record.deleted_by
      next if created_by.nil?

      print "\n "
      print deleted_by.id
      print "\n "
      print deleted_by.name
    end
  end

  def get_recyclebin_records
    module_api_name = 'module_api_name'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_recyclebin_records
    trash_records = api_res.data
    trash_records.each do |trash_record|
      print "\n "
      print trash_record.id
      print "\n "
      print trash_record.type
      print "\n "
      print trash_record.display_name
      print "\n "
      print trash_record.deleted_time
      print "\n "
      created_by = trash_record.created_by
      unless created_by.nil?
        print "\n "
        print created_by.id
        print "\n "
        print created_by.name
      end
      deleted_by = trash_record.deleted_by
      next if created_by.nil?

      print "\n "
      print deleted_by.id
      print "\n "
      print deleted_by.name
    end
  end

  def get_permanently_deleted_records
    module_api_name = 'module_api_name'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_permanently_deleted_records
    trash_records = api_res.data
    trash_records.each do |trash_record|
      print "\n "
      print trash_record.id
      print "\n "
      print trash_record.type
      print "\n "
      print trash_record.display_name
      print "\n "
      print trash_record.deleted_time
      print "\n "
      created_by = trash_record.created_by
      unless created_by.nil?
        print "\n "
        print created_by.id
        print "\n "
        print created_by.name
      end
      deleted_by = trash_record.deleted_by
      next if created_by.nil?

      print "\n "
      print deleted_by.id
      print "\n "
      print deleted_by.name
    end
  end

  def get_tags
    module_api_name = 'module_api_name'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_tags
    tags = api_res.data
    tags.each do |tag_ins|
      print "\n"
      print tag_ins.id
      tag_ins.module_apiname = module_api_name
      print "\n"
      print tag_ins.name
      unless tag_ins.created_by.nil?
        print "\n"
        print tag_ins.created_by.name
        print "\n"
        print tag_ins.created_by.id
      end
      unless tag_ins.modified_by.nil?
        print "\n"
        print tag_ins.modified_by.name
        print "\n"
        print tag_ins.modified_by.id
      end
      print "\n"
      print tag_ins.created_time
      print "\n"
      print tag_ins.modified_time
    end
  end

  def get_tag_count
    module_api_name = 'module_api_name'
    tag_id = 'tag_id'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.get_tag_count(tag_id)
    tag_ins = api_res.data
    print "\n"
    print tag_ins.id
    print "\n"
    print tag_ins.count
  end

  def search_records
    module_api_name = 'module_api_name'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.search_records('first')
    records = api_res.data
    records.each do |record|
      print 'module_api_name '
      print record.module_api_name
      print "\n id "
      print record.entity_id
      line_items = record.line_items
      line_items.each do |line_item|
        print "\n id "
        print line_item.id
        product = line_item.product
        print "\n entity_id "
        print product.entity_id
        print "\n lookup_label "
        print product.lookup_label
        print "\n Product_Code "
        print product.field_data['Product_Code']
        print "\n list_price "
        print line_item.list_price
        print "\n quantity "
        print line_item.quantity
        print "\n  description "
        print line_item.description
        print "\n total "
        print line_item.total
        print "\n discount "
        print line_item.discount
        print "\n total_after_discount "
        print line_item.total_after_discount
        print "\n tax_amount "
        print line_item.tax_amount
        print "\n net_total "
        print line_item.net_total
        print "\n delete_flag "
        print line_item.delete_flag
        line_taxes = line_item.line_tax
        next if line_taxes.nil?

        line_taxes.each do |line_tax|
          print "\n name "
          print line_tax.name
          print "\n percentage "
          print line_tax.percentage
          print "\n  value "
          print line_tax.value
        end
      end
      owner = record.owner
      unless owner.nil?
        print "\n id "
        print owner.id
        print "\n name "
        print owner.name
      end
      created_by = record.created_by
      unless created_by.nil?
        print "\n id "
        print created_by.id
        print "\n name "
        print created_by.name
      end
      modified_by = record.modified_by
      unless owner.nil?
        print "\n  id "
        print modified_by.id
        print "\n name "
        print modified_by.name
      end
      print "\n created_time "
      print record.created_time
      print "\n modified_time "
      print record.modified_time
      print record.properties
      participants = record.participants
      participants.each do |participant|
        print "\n name "
        print participant.name
        print "\n email "
        print participant.email
        print  "\n is_invited "
        print  participant.is_invited
        print  "\n status "
        print  participant.status
        print  "\n type "
        print  participant.type
      end
      pricing_instances = record.price_details
      pricing_instances.each do |pricing_instance|
        print "\n id "
        print pricing_instance.id
        print "\n discount "
        print pricing_instance.discount
        print "\n to_range "
        print pricing_instance.to_range
        print "\n from_range "
        print pricing_instance.from_range
      end
      layout = record.layout
      unless layout.nil?
        print "\n id "
        print layout.id
        print "\n name "
        print layout.name
      end
      tax_list = record.tax_list
      tax_list.each do |tax|
        print "\n name "
        print tax.name
      end
      print record.last_activity_time
      tags = record.tags
      tags.each do |tag|
        print "\n id "
        print tag.id
        print "\n name "
        print tag.name
      end
      fields = record.field_data
      fields.each do |key, field_value|
        print "\n key "
        print key
        print "\t field_value "
        print field_value
      end
      print "\n "
    end
  end

  def search_records_by_phone
    module_api_name = 'module_api_name'
    phone = 'phone'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.search_records_by_phone(phone)
    records = api_res.data
    records.each do |record|
      print 'module_api_name '
      print record.module_api_name
      print "\n id "
      print record.entity_id
      line_items = record.line_items
      line_items.each do |line_item|
        print "\n id "
        print line_item.id
        product = line_item.product
        print "\n entity_id "
        print product.entity_id
        print "\n lookup_label "
        print product.lookup_label
        print "\n Product_Code "
        print product.field_data['Product_Code']
        print "\n list_price "
        print line_item.list_price
        print "\n quantity "
        print line_item.quantity
        print "\n  description "
        print line_item.description
        print "\n total "
        print line_item.total
        print "\n discount "
        print line_item.discount
        print "\n total_after_discount "
        print line_item.total_after_discount
        print "\n tax_amount "
        print line_item.tax_amount
        print "\n net_total "
        print line_item.net_total
        print "\n delete_flag "
        print line_item.delete_flag
        line_taxes = line_item.line_tax
        next if line_taxes.nil?

        line_taxes.each do |line_tax|
          print "\n name "
          print line_tax.name
          print "\n percentage "
          print line_tax.percentage
          print "\n  value "
          print line_tax.value
        end
      end
      owner = record.owner
      unless owner.nil?
        print "\n id "
        print owner.id
        print "\n name "
        print owner.name
      end
      created_by = record.created_by
      unless created_by.nil?
        print "\n id "
        print created_by.id
        print "\n name "
        print created_by.name
      end
      modified_by = record.modified_by
      unless owner.nil?
        print "\n  id "
        print modified_by.id
        print "\n name "
        print modified_by.name
      end
      print "\n created_time "
      print record.created_time
      print "\n modified_time "
      print record.modified_time
      print record.properties
      participants = record.participants
      participants.each do |participant|
        print "\n name "
        print participant.name
        print "\n email "
        print participant.email
        print  "\n is_invited "
        print  participant.is_invited
        print  "\n status "
        print  participant.status
        print  "\n type "
        print  participant.type
      end
      pricing_instances = record.price_details
      pricing_instances.each do |pricing_instance|
        print "\n id "
        print pricing_instance.id
        print "\n discount "
        print pricing_instance.discount
        print "\n to_range "
        print pricing_instance.to_range
        print "\n from_range "
        print pricing_instance.from_range
      end
      layout = record.layout
      unless layout.nil?
        print "\n id "
        print layout.id
        print "\n name "
        print layout.name
      end
      tax_list = record.tax_list
      tax_list.each do |tax|
        print "\n name "
        print tax.name
      end
      print record.last_activity_time
      tags = record.tags
      tags.each do |tag|
        print "\n id "
        print tag.id
        print "\n name "
        print tag.name
      end
      fields = record.field_data
      fields.each do |key, field_value|
        print "\n key "
        print key
        print "\t field_value "
        print field_value
      end
      print "\n "
    end
  end

  def search_records_by_email
    module_api_name = 'module_api_name'
    email = 'email'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.search_records_by_email(email)
    records = api_res.data
    records.each do |record|
      print 'module_api_name '
      print record.module_api_name
      print "\n id "
      print record.entity_id
      line_items = record.line_items
      line_items.each do |line_item|
        print "\n id "
        print line_item.id
        product = line_item.product
        print "\n entity_id "
        print product.entity_id
        print "\n lookup_label "
        print product.lookup_label
        print "\n Product_Code "
        print product.field_data['Product_Code']
        print "\n list_price "
        print line_item.list_price
        print "\n quantity "
        print line_item.quantity
        print "\n  description "
        print line_item.description
        print "\n total "
        print line_item.total
        print "\n discount "
        print line_item.discount
        print "\n total_after_discount "
        print line_item.total_after_discount
        print "\n tax_amount "
        print line_item.tax_amount
        print "\n net_total "
        print line_item.net_total
        print "\n delete_flag "
        print line_item.delete_flag
        line_taxes = line_item.line_tax
        next if line_taxes.nil?

        line_taxes.each do |line_tax|
          print "\n name "
          print line_tax.name
          print "\n percentage "
          print line_tax.percentage
          print "\n  value "
          print line_tax.value
        end
      end
      owner = record.owner
      unless owner.nil?
        print "\n id "
        print owner.id
        print "\n name "
        print owner.name
      end
      created_by = record.created_by
      unless created_by.nil?
        print "\n id "
        print created_by.id
        print "\n name "
        print created_by.name
      end
      modified_by = record.modified_by
      unless owner.nil?
        print "\n  id "
        print modified_by.id
        print "\n name "
        print modified_by.name
      end
      print "\n created_time "
      print record.created_time
      print "\n modified_time "
      print record.modified_time
      print record.properties
      participants = record.participants
      participants.each do |participant|
        print "\n name "
        print participant.name
        print "\n email "
        print participant.email
        print  "\n is_invited "
        print  participant.is_invited
        print  "\n status "
        print  participant.status
        print  "\n type "
        print  participant.type
      end
      pricing_instances = record.price_details
      pricing_instances.each do |pricing_instance|
        print "\n id "
        print pricing_instance.id
        print "\n discount "
        print pricing_instance.discount
        print "\n to_range "
        print pricing_instance.to_range
        print "\n from_range "
        print pricing_instance.from_range
      end
      layout = record.layout
      unless layout.nil?
        print "\n id "
        print layout.id
        print "\n name "
        print layout.name
      end
      tax_list = record.tax_list
      tax_list.each do |tax|
        print "\n name "
        print tax.name
      end
      print record.last_activity_time
      tags = record.tags
      tags.each do |tag|
        print "\n id "
        print tag.id
        print "\n name "
        print tag.name
      end
      fields = record.field_data
      fields.each do |key, field_value|
        print "\n key "
        print key
        print "\t field_value "
        print field_value
      end
      print "\n "
    end
  end

  def search_records_by_criteria
    module_api_name = 'module_api_name'
    criteria = 'criteria'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    api_res = module_instance.search_records_by_criteria(criteria)
    records = api_res.data
    records.each do |record|
      print 'module_api_name '
      print record.module_api_name
      print "\n id "
      print record.entity_id
      line_items = record.line_items
      line_items.each do |line_item|
        print "\n id "
        print line_item.id
        product = line_item.product
        print "\n entity_id "
        print product.entity_id
        print "\n lookup_label "
        print product.lookup_label
        print "\n Product_Code "
        print product.field_data['Product_Code']
        print "\n list_price "
        print line_item.list_price
        print "\n quantity "
        print line_item.quantity
        print "\n  description "
        print line_item.description
        print "\n total "
        print line_item.total
        print "\n discount "
        print line_item.discount
        print "\n total_after_discount "
        print line_item.total_after_discount
        print "\n tax_amount "
        print line_item.tax_amount
        print "\n net_total "
        print line_item.net_total
        print "\n delete_flag "
        print line_item.delete_flag
        line_taxes = line_item.line_tax
        next if line_taxes.nil?

        line_taxes.each do |line_tax|
          print "\n name "
          print line_tax.name
          print "\n percentage "
          print line_tax.percentage
          print "\n  value "
          print line_tax.value
        end
      end
      owner = record.owner
      unless owner.nil?
        print "\n id "
        print owner.id
        print "\n name "
        print owner.name
      end
      created_by = record.created_by
      unless created_by.nil?
        print "\n id "
        print created_by.id
        print "\n name "
        print created_by.name
      end
      modified_by = record.modified_by
      unless owner.nil?
        print "\n  id "
        print modified_by.id
        print "\n name "
        print modified_by.name
      end
      print "\n created_time "
      print record.created_time
      print "\n modified_time "
      print record.modified_time
      print record.properties
      participants = record.participants
      participants.each do |participant|
        print "\n name "
        print participant.name
        print "\n email "
        print participant.email
        print  "\n is_invited "
        print  participant.is_invited
        print  "\n status "
        print  participant.status
        print  "\n type "
        print  participant.type
      end
      pricing_instances = record.price_details
      pricing_instances.each do |pricing_instance|
        print "\n id "
        print pricing_instance.id
        print "\n discount "
        print pricing_instance.discount
        print "\n to_range "
        print pricing_instance.to_range
        print "\n from_range "
        print pricing_instance.from_range
      end
      layout = record.layout
      unless layout.nil?
        print "\n id "
        print layout.id
        print "\n name "
        print layout.name
      end
      tax_list = record.tax_list
      tax_list.each do |tax|
        print "\n name "
        print tax.name
      end
      print record.last_activity_time
      tags = record.tags
      tags.each do |tag|
        print "\n id "
        print tag.id
        print "\n name "
        print tag.name
      end
      fields = record.field_data
      fields.each do |key, field_value|
        print "\n key "
        print key
        print "\t field_value "
        print field_value
      end
      print "\n "
    end
  end

  def create_records
    module_api_name = 'module_api_name'
    records = []
    rec1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, nil)
    rec1.field_data = Array('Last_Name' => 'ruby_lead1')
    records.push(rec1)
    rec2 = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, nil)
    rec2.field_data = Array('Last_Name' => 'ruby_lead2', 'City' => 'City')
    records.push(rec2)
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).create_records(records, 3_524_033_000_001_149_001).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def update_records
    module_api_name = 'module_api_name'
    records = []
    record_id_1 = 'record_id_1'
    record_id_2 = 'record_id_2'
    rec1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id_1)# record_id is mandatory
    rec1.field_data = Array('Last_Name' => 'ruby_asdlead1')
    records.push(rec1)
    rec2 = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id_2)# record_id is mandatory
    rec2.field_data = Array('Last_Name' => 'ruby_lasdead2')
    records.push(rec2)
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).update_records(records).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def upsert_records
    module_api_name = 'module_api_name'
    records = []
    record_id_1 = 'record_id_1'
    record_id_2 = 'record_id_2'
    duplicate_check_fields = []
    duplicate_check_fields.push('Company')
    rec1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id_1)# record_id is not mandatory
    rec1.field_data = Array('Last_Name' => 'ruby_asdlead1', 'Company' => 'adsasagrgrgrgsdasddd', 'Email' => 'xyc@random.com')
    records.push(rec1)
    rec2 = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id_2)# record_id is not mandatory
    rec2.field_data = Array('Last_Name' => 'ruby_lasdead2', 'Company' => 'adasasasdrgrgrgsddddsd', 'Email' => 'xyc@random.com')
    records.push(rec2)
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).upsert_records(records, duplicate_check_fields, nil).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def delete_records
    module_api_name = 'module_api_name'
    record_ids = []
    record_ids.push('record_id_1')
    record_ids.push('record_id_2')
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).delete_records(record_ids).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def mass_update_records
    module_api_name = 'module_api_name'
    record_ids = []
    record_ids.push('record_id_1')
    record_ids.push('record_id_2')
    field_api_name = 'phone'
    value = '24242'
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).mass_update_records(record_ids, field_api_name, value).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def create_tags
    module_api_name = 'module_api_name'
    tags = []
    tag1 = ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'tag_name_1')
    tags.push(tag1)
    tag2 = ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'tag_name_1')
    tags.push(tag2)
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).create_tags(tags).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def update_tags
    module_api_name = 'module_api_name'
    tags = []
    tag_id_1 = 'tag_id_1'
    tag_id_2 = 'tag_id_2'
    tag1 = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_id_1, 'updated_tag_name_1')# tag id is not mandatory
    tags.push(tag1)
    tag2 = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_id_2, 'updated_tag_name_2')# tag id is not mandatory
    tags.push(tag2)
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).update_tags(tags).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def add_tags_to_multiple_records
    module_api_name = 'module_api_name'
    tag_names = []
    tag_names.push('tag_name_1')
    tag_names.push('tag_name_2')
    records_ids = []
    records_ids.push('record_id_1')
    records_ids.push('record_id_2')
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).add_tags_to_multiple_records(tag_names, records_ids).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def remove_tags_from_multiple_records
    module_api_name = 'module_api_name'
    tag_names = []
    tag_names.push('tag_name_1')
    records_ids = []
    records_ids.push('record_id_1')
    records_ids.push('record_id_2')
    res = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).remove_tags_from_multiple_records(tag_names, records_ids).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def get_record
    module_api_name = 'module_api_name'
    entity_id = 'entity_id'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, entity_id)
    api_res = record_instance.get
    record = api_res.data
    print 'module_api_name '
    print record.module_api_name
    print "\n id "
    print record.entity_id
    line_items = record.line_items
    line_items.each do |line_item|
      print "\n id "
      print line_item.id
      product = line_item.product
      print "\n entity_id "
      print product.entity_id
      print "\n lookup_label "
      print product.lookup_label
      print "\n Product_Code "
      print product.field_data['Product_Code']
      print "\n list_price "
      print line_item.list_price
      print "\n quantity "
      print line_item.quantity
      print "\n  description "
      print line_item.description
      print "\n total "
      print line_item.total
      print "\n discount "
      print line_item.discount
      print "\n total_after_discount "
      print line_item.total_after_discount
      print "\n tax_amount "
      print line_item.tax_amount
      print "\n net_total "
      print line_item.net_total
      print "\n delete_flag "
      print line_item.delete_flag
      line_taxes = line_item.line_tax
      next if line_taxes.nil?

      line_taxes.each do |line_tax|
        print "\n name "
        print line_tax.name
        print "\n percentage "
        print line_tax.percentage
        print "\n  value "
        print line_tax.value
      end
    end
    owner = record.owner
    unless owner.nil?
      print "\n id "
      print owner.id
      print "\n name "
      print owner.name
    end
    created_by = record.created_by
    unless created_by.nil?
      print "\n id "
      print created_by.id
      print "\n name "
      print created_by.name
    end
    modified_by = record.modified_by
    unless owner.nil?
      print "\n  id "
      print modified_by.id
      print "\n name "
      print modified_by.name
    end
    print "\n created_time "
    print record.created_time
    print "\n modified_time "
    print record.modified_time
    print record.properties
    participants = record.participants
    participants.each do |participant|
      print "\n name "
      print participant.name
      print "\n email "
      print participant.email
      print  "\n is_invited "
      print  participant.is_invited
      print  "\n status "
      print  participant.status
      print  "\n type "
      print  participant.type
    end
    pricing_instances = record.price_details
    pricing_instances.each do |pricing_instance|
      print "\n id "
      print pricing_instance.id
      print "\n discount "
      print pricing_instance.discount
      print "\n to_range "
      print pricing_instance.to_range
      print "\n from_range "
      print pricing_instance.from_range
    end
    layout = record.layout
    unless layout.nil?
      print "\n id "
      print layout.id
      print "\n name "
      print layout.name
    end
    tax_list = record.tax_list
    tax_list.each do |tax|
      print "\n name "
      print tax.name
    end
    print record.last_activity_time
    tags = record.tags
    tags.each do |tag|
      print "\n id "
      print tag.id
      print "\n name "
      print tag.name
    end
    fields = record.field_data
    fields.each do |key, field_value|
      print "\n key "
      print key
      print "\t field_value "
      print field_value
    end
    print "\n "
  end

  def create_record
    module_api_name = 'module_api_name'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, nil)
    record_instance.field_data = Array('Last_Name' => 'ruby_lead1')
    response = record_instance.create
    rescue ZCRMSDK::Utility::ZCRMException => e
       print e.status_code
        print e.error_message
        print e.exception_code
        print e.error_details
        print e.error_content
     print "\n"
     print response.code
     print "\n"
     print response.message
     print "\n"
     print response.details
  end

  def update_record
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    record_instance.field_data = Array('Last_Name' => 'ruby_lead1')
    response = record_instance.update
    print "\n"
    print response.code
    print "\n"
    print response.message
    print "\n"
    print response.details
  end

  def delete_record
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    response = record_instance.delete
    print "\n"
    print response.code
    print "\n"
    print response.message
    print "\n"
    print response.details
  end

  def convert_record
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    deal = ZCRMSDK::Operations::ZCRMRecord.get_instance('deals', nil)
    deal.field_data = { 'Deal_Name' => 'test3', 'stage' => 'Qualification', 'Closing_Date' => '2016-03-30' }
    details = {'overwrite' => TRUE, 'notify_new_entity_owner' => TRUE}
    response = record_instance.convert(nil, details)
    response.each do |key, value|
      print "\n" + key + "\t" + value.to_s
    end
  rescue ZCRMSDK::Utility::ZCRMException => e
    print e.status_code
    print "\n"
    print e.error_message
    print "\n"
    print e.exception_code
    print "\n"
    print e.error_details
    print "\n"
    print e.error_content
  end

  def get_relatedlist_records
    module_api_name = 'module_api_name'
    related_list_api_name = 'related_list_api_name'
    record_id = 'record_id'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    api_res = record_instance.get_relatedlist_records(related_list_api_name)
    records = api_res.data
    records.each do |record|
      print 'module_api_name '
      print record.module_api_name
      print "\n id "
      print record.entity_id
      line_items = record.line_items
      line_items.each do |line_item|
        print "\n id "
        print line_item.id
        product = line_item.product
        print "\n entity_id "
        print product.entity_id
        print "\n lookup_label "
        print product.lookup_label
        print "\n Product_Code "
        print product.field_data['Product_Code']
        print "\n list_price "
        print line_item.list_price
        print "\n quantity "
        print line_item.quantity
        print "\n  description "
        print line_item.description
        print "\n total "
        print line_item.total
        print "\n discount "
        print line_item.discount
        print "\n total_after_discount "
        print line_item.total_after_discount
        print "\n tax_amount "
        print line_item.tax_amount
        print "\n net_total "
        print line_item.net_total
        print "\n delete_flag "
        print line_item.delete_flag
        line_taxes = line_item.line_tax
        next if line_taxes.nil?

        line_taxes.each do |line_tax|
          print "\n name "
          print line_tax.name
          print "\n percentage "
          print line_tax.percentage
          print "\n  value "
          print line_tax.value
        end
      end
      owner = record.owner
      unless owner.nil?
        print "\n id "
        print owner.id
        print "\n name "
        print owner.name
      end
      created_by = record.created_by
      unless created_by.nil?
        print "\n id "
        print created_by.id
        print "\n name "
        print created_by.name
      end
      modified_by = record.modified_by
      unless owner.nil?
        print "\n  id "
        print modified_by.id
        print "\n name "
        print modified_by.name
      end
      print "\n created_time "
      print record.created_time
      print "\n modified_time "
      print record.modified_time
      print record.properties
      participants = record.participants
      participants.each do |participant|
        print "\n name "
        print participant.name
        print "\n email "
        print participant.email
        print  "\n is_invited "
        print  participant.is_invited
        print  "\n status "
        print  participant.status
        print  "\n type "
        print  participant.type
      end
      pricing_instances = record.price_details
      pricing_instances.each do |pricing_instance|
        print "\n id "
        print pricing_instance.id
        print "\n discount "
        print pricing_instance.discount
        print "\n to_range "
        print pricing_instance.to_range
        print "\n from_range "
        print pricing_instance.from_range
      end
      layout = record.layout
      unless layout.nil?
        print "\n id "
        print layout.id
        print "\n name "
        print layout.name
      end
      tax_list = record.tax_list
      tax_list.each do |tax|
        print "\n name "
        print tax.name
      end
      print record.last_activity_time
      tags = record.tags
      tags.each do |tag|
        print "\n id "
        print tag.id
        print "\n name "
        print tag.name
      end
      fields = record.field_data
      fields.each do |key, field_value|
        print "\n key "
        print key
        print "\t field_value "
        print field_value
      end
      print "\n "
    end
  end
  

  def add_tags
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    tagnames = []
    tagnames.push('asdsdad')
    tagnames.push('asdsasdddad')
    res = record_instance.add_tags(tagnames)
    print "\n"
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def remove_tags
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record_instance = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    tagnames = []
    tagnames.push('asdsdad')
    tagnames.push('asdsasdddad')
    res = record_instance.remove_tags(tagnames)
    print "\n"
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def delete_tag
    tag_id = 'tag_id'
    tag_instance = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_id)
    res = tag_instance.delete
    print "\n"
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def merge_tag
    tag_id = 'tag_id'
    tag_id_to_merge = 'tag_id_to_merge'
    tag_instance = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_id)
    tag_to_merge = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_id_to_merge)
    res = tag_instance.merge(tag_to_merge)
    print "\n"
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def update_tag
    tag_id = 'tag_id'
    tag_instance = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_id, 'asdadsad')
    tag_instance.module_apiname = 'Leads'
    res = tag_instance.update
    print "\n"
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def upload_attachment
    filepath = 'filepath'
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    res = record.upload_attachment(filepath)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def upload_link_as_attachment
    attachment_url = 'attachment_url'
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    res = record.upload_link_as_attachment(attachment_url)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def download_attachment
    attachment_id = 'attachment_id'
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    res = record.download_attachment(attachment_id)
    print res.inspect
    filepath = 'filepath/' + res.filename
    File.write(filepath, res.response)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end
  
  def delete_attachment
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    res = record.delete_attachment(attachment_id)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def upload_photo
    filepath = 'filepath'
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    res = record.upload_photo(filepath)
    print res.inspect
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end
  

  def download_photo
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    res = record.download_photo
    filepath = '/Users/path/asd/' + res.filename
    File.write(filepath, res.response)
  end

  def delete_photo
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    res = record.delete_photo
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def add_relation
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    related_record_module_api_name = 'related_record_module_api_name'
    related_record_id = 'related_record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    junction_record = ZCRMSDK::Operations::ZCRMJunctionRecord.get_instance(related_record_module_api_name, related_record_id)
    res = record.add_relation(junction_record)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def remove_relation
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    related_record_module_api_name = 'related_record_module_api_name'
    related_record_id = 'related_record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    junction_record = ZCRMSDK::Operations::ZCRMJunctionRecord.get_instance(related_record_module_api_name, related_record_id)
    res = record.remove_relation(junction_record)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def add_notes
    module_api_name = 'Accounts'
    record_id = '3524033000003350015'
    notes=[]
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record, nil)
    note.title = 'Adssadasdasd'
    note.content = 'Adssadasdasd'
    notes.push(note)
    note1 = ZCRMSDK::Operations::ZCRMNote.get_instance(record, nil)
    note1.title = 'Adssadasdasd'
    note1.content = 'Adssadasdasd'
    notes.push(note1)
    res = record.add_notes(notes).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def update_note
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    note_id = 'note_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record, note_id)
    note.title = 'Adssadasdasd'
    note.content = 'Adssadasdasd'
    res = record.update_note(note)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def delete_note
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    note_id = 'note_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record, note_id)
    res = record.delete_note(note)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end

  def get_notes_from_record
    module_api_name = 'accounts'
    record_id = '3524033000003350015'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    page=1
    per_page=3
    sort_by='Note_Content'
    sort_order='asc'
    res = record.get_notes(sort_by, sort_order, page, per_page)
    notes = res.data
    notes.each do |zcrmnote_ins|
      print zcrmnote_ins.id
      print "\n"
      print zcrmnote_ins.title
      print "\n"
      print zcrmnote_ins.content
      owner = zcrmnote_ins.owner
      unless owner.nil?
        print "\n"
        print owner.id
        print "\n"
        print owner.name
      end
      created_by = zcrmnote_ins.created_by
      unless created_by.nil?
        print "\n"
        print created_by.id
        print "\n"
        print created_by.name
      end
      modified_by = zcrmnote_ins.modified_by
      unless modified_by.nil?
        print "\n"
        print modified_by.id
        print "\n"
        print modified_by.name
      end
      print "\n"
      print zcrmnote_ins.created_time
      print "\n"
      print zcrmnote_ins.modified_time
      print "\n"
      print zcrmnote_ins.is_voice_note
      print "\n"
      print zcrmnote_ins.parent_module
      print "\n"
      print zcrmnote_ins.parent_id
      print "\n"
      print zcrmnote_ins.parent_name
      print "\n"
      print zcrmnote_ins.size
      print "\n"
      print zcrmnote_ins.is_editable
      print "\n"
      attachments = zcrmnote_ins.attachments
      next if attachments.nil?

      attachments.each do |zcrmattachment_ins|
        print zcrmattachment_ins.id
        print "\n"
        print zcrmattachment_ins.file_name
        print "\n"
        print zcrmattachment_ins.type
        owner = zcrmattachment_ins.owner
        unless owner.nil?
          print "\n"
          print owner.id
          print "\n"
          print owner.name
        end
        created_by = zcrmattachment_ins.created_by
        unless created_by.nil?
          print "\n"
          print created_by.id
          print "\n"
          print created_by.name
        end
        modified_by = zcrmattachment_ins.modified_by
        unless modified_by.nil?
          print "\n"
          print modified_by.id
          print "\n"
          print modified_by.name
        end
        print "\n"
        print zcrmattachment_ins.created_time
        print "\n"
        print zcrmattachment_ins.file_id
        print "\n"
        print zcrmattachment_ins.modified_time
        print "\n"
        print zcrmattachment_ins.attachment_type
        print "\n"
        print zcrmattachment_ins.parent_module
        print "\n"
        print zcrmattachment_ins.parent_id
        print "\n"
        print zcrmattachment_ins.parent_name
        print "\n"
        print zcrmattachment_ins.size
        print "\n"
        print zcrmattachment_ins.is_editable
        print "\n"
        print zcrmattachment_ins.link_url
        print "\n"
      end
    end
  end

  def get_attachments
    module_api_name = 'module_api_name'
    record_id = 'record_id'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    page = 1
    per_page = 20
    res = record.get_attachments(page, per_page)# page, per_page is not mandatory
    attachment = res.data
    attachment.each do |zcrmattachment_ins|
      print zcrmattachment_ins.id
      print "\n"
      print zcrmattachment_ins.file_name
      print "\n"
      print zcrmattachment_ins.type
      owner = zcrmattachment_ins.owner
      unless owner.nil?
        print "\n"
        print owner.id
        print "\n"
        print owner.name
      end
      created_by = zcrmattachment_ins.created_by
      unless created_by.nil?
        print "\n"
        print created_by.id
        print "\n"
        print created_by.name
      end
      modified_by = zcrmattachment_ins.modified_by
      unless modified_by.nil?
        print "\n"
        print modified_by.id
        print "\n"
        print modified_by.name
      end
      print "\n"
      print zcrmattachment_ins.created_time
      print "\n"
      print zcrmattachment_ins.file_id
      print "\n"
      print zcrmattachment_ins.modified_time
      print "\n"
      print zcrmattachment_ins.attachment_type
      print "\n"
      print zcrmattachment_ins.parent_module
      print "\n"
      print zcrmattachment_ins.parent_id
      print "\n"
      print zcrmattachment_ins.parent_name
      print "\n"
      print zcrmattachment_ins.size
      print "\n"
      print zcrmattachment_ins.is_editable
      print "\n"
      print zcrmattachment_ins.link_url
      print "\n"
    end
  end

  def upload_attachment_to_note
    module_api_name = 'module_api_name'
    entity_id = 'entity_id'
    note_id = 'note_id'
    file_path = 'file_path'
    record_ins = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, entity_id)
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record_ins, note_id) #note_id - is not mandatory
    note_upload_attachment_res = note.upload_attachment(file_path)
  end
 
  def download_attachment_from_note
    note_id = 'note_id'
    note_attachment_id = 'note_attachment_id'
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record_ins, note_id) #record_ins - is not mandatory
    note_upload_attachment_res = note.download_attachment(note_attachment_id)
    print note_upload_attachment_res.inspect
    filepath = 'filepath/' + res.filename
    File.write(filepath, res.response)
    print res.code
    print "\n"
    print res.message
    print "\n"
    print res.details
  end
 
  def get_attachments_from_note
    note_id = 'note_id'
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record_ins, note_id) #record_ins - is not mandatory
    note_get_attachment = note.get_attachments.data
    note_get_attachment.each do |zcrmattachment_ins|
      print zcrmattachment_ins.id
      print "\n"
      print zcrmattachment_ins.file_name
      print "\n"
      print zcrmattachment_ins.type
      owner = zcrmattachment_ins.owner
      unless owner.nil?
        print "\n"
        print owner.id
        print "\n"
        print owner.name
      end
      created_by = zcrmattachment_ins.created_by
      unless created_by.nil?
        print "\n"
        print created_by.id
        print "\n"
        print created_by.name
      end
      modified_by = zcrmattachment_ins.modified_by
      unless modified_by.nil?
        print "\n"
        print modified_by.id
        print "\n"
        print modified_by.name
      end
      print "\n"
      print zcrmattachment_ins.created_time
      print "\n"
      print zcrmattachment_ins.file_id
      print "\n"
      print zcrmattachment_ins.modified_time
      print "\n"
      print zcrmattachment_ins.attachment_type
      print "\n"
      print zcrmattachment_ins.parent_module
      print "\n"
      print zcrmattachment_ins.parent_id
      print "\n"
      print zcrmattachment_ins.parent_name
      print "\n"
      print zcrmattachment_ins.size
      print "\n"
      print zcrmattachment_ins.is_editable
      print "\n"
    end
  end
 
  def delete_attachment_of_note
    note_id = 'note_id'
    note_attachment_id = 'note_attachment_id'
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record_ins, note_id) #record_ins - is not mandatory
    note_delete_attachment_res = note.download_attachment(note_attachment_id) 
  end
  def get_notes
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    page=1
    per_page=2
    sort_by='Note_Content'
    sort_order='asc'
    api_res = org.get_notes(sort_by,sort_order,page,per_page)
    notes = api_res.data
    notes.each do |zcrmnote_ins|
      print zcrmnote_ins.id
      print "\n"
      print zcrmnote_ins.title
      print "\n"
      print zcrmnote_ins.content
      owner = zcrmnote_ins.owner
      unless owner.nil?
        print "\n"
        print owner.id
        print "\n"
        print owner.name
      end
      created_by = zcrmnote_ins.created_by
      unless created_by.nil?
        print "\n"
        print created_by.id
        print "\n"
        print created_by.name
      end
      modified_by = zcrmnote_ins.modified_by
      unless modified_by.nil?
        print "\n"
        print modified_by.id
        print "\n"
        print modified_by.name
      end
      print "\n"
      print zcrmnote_ins.created_time
      print "\n"
      print zcrmnote_ins.modified_time
      print "\n"
      print zcrmnote_ins.is_voice_note
      print "\n"
      print zcrmnote_ins.parent_module
      print "\n"
      print zcrmnote_ins.parent_id
      print "\n"
      print zcrmnote_ins.parent_name
      print "\n"
      print zcrmnote_ins.size
      print "\n"
      print zcrmnote_ins.is_editable
      print "\n"
      attachments = zcrmnote_ins.attachments
      next if attachments.nil?

      attachments.each do |zcrmattachment_ins|
        print zcrmattachment_ins.id
        print "\n"
        print zcrmattachment_ins.file_name
        print "\n"
        print zcrmattachment_ins.type
        owner = zcrmattachment_ins.owner
        unless owner.nil?
          print "\n"
          print owner.id
          print "\n"
          print owner.name
        end
        created_by = zcrmattachment_ins.created_by
        unless created_by.nil?
          print "\n"
          print created_by.id
          print "\n"
          print created_by.name
        end
        modified_by = zcrmattachment_ins.modified_by
        unless modified_by.nil?
          print "\n"
          print modified_by.id
          print "\n"
          print modified_by.name
        end
        print "\n"
        print zcrmattachment_ins.created_time
        print "\n"
        print zcrmattachment_ins.file_id
        print "\n"
        print zcrmattachment_ins.modified_time
        print "\n"
        print zcrmattachment_ins.attachment_type
        print "\n"
        print zcrmattachment_ins.parent_module
        print "\n"
        print zcrmattachment_ins.parent_id
        print "\n"
        print zcrmattachment_ins.parent_name
        print "\n"
        print zcrmattachment_ins.size
        print "\n"
        print zcrmattachment_ins.is_editable
        print "\n"
        print zcrmattachment_ins.link_url
        print "\n"
      end
    end
  end
  def create_notes
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    notes=[]
    module_api_name = 'Accounts'
    record_id = '3524033000003350015'
    record = ZCRMSDK::Operations::ZCRMRecord.get_instance(module_api_name, record_id)
    note = ZCRMSDK::Operations::ZCRMNote.get_instance(record, nil)
    note.title = 'Adssadasdasd'
    note.content = 'Adssadasdasd'
    notes.push(note)
    note1 = ZCRMSDK::Operations::ZCRMNote.get_instance(record, nil)
    note1.title = 'Adssadasdasd'
    note1.content = 'Adssadasdasd'
    notes.push(note1)
    res = org.create_notes(notes).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end
  def delete_notes
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    note_ids=['3524033000003454001','3524033000003454001']
    res = org.delete_notes(note_ids).bulk_entity_response
    res.each do |response|
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end

  def get_variable
    variable_id='3524033000003052001'
    variable = ZCRMSDK::Operations::ZCRMVariable.get_instance(nil,variable_id)
    group_id = '3524033000000231001'
    variable_ins = variable.get(group_id).data
    print variable_ins.id
    print "\n"
    print variable_ins.api_name
    print "\n"
    print variable_ins.name
    print "\n"
    print variable_ins.description
    print "\n"
    print variable_ins.value
    print "\n"
    print variable_ins.type
    print "\n"
    print variable_ins.variable_group.id
    print "\n"
    print variable_ins.variable_group.api_name
  end

  def update_variable
    variable_id='3524033000003209002'
    variable_api_name='updated'
    variable = ZCRMSDK::Operations::ZCRMVariable.get_instance(variable_api_name,variable_id)
    variable.name="updated"
    variable.description="updated"
    variable.value=4
    response = variable.update
    print "\n"
    print response.code
    print "\n"
    print response.message
    print "\n"
    print response.details
  end

  def delete_variable
    variable_id='3524033000003076001'
    variable = ZCRMSDK::Operations::ZCRMVariable.get_instance(nil,variable_id)
    response = variable.delete
    print "\n"
    print response.code
    print "\n"
    print response.message
    print "\n"
    print response.details
  end

  def get_variable_group
    variable_group_id='3524033000000231001'
    variable_group = ZCRMSDK::Operations::ZCRMVariableGroup.get_instance(nil,variable_group_id)
    variable_group_ins = variable_group.get.data
    print variable_group_ins.id
    print "\n"
    print variable_group_ins.api_name
    print "\n"
    print variable_group_ins.name
    print "\n"
    print variable_group_ins.description
    print "\n"
    print variable_group_ins.display_label
  end

  def get_variable_groups
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_variable_groups
    variable_groups = api_res.data
    variable_groups.each do |variable_group_ins|
      print variable_group_ins.id
      print "\n"
      print variable_group_ins.api_name
      print "\n"
      print variable_group_ins.name
      print "\n"
      print variable_group_ins.description
      print "\n"
      print variable_group_ins.display_label
    end
  end

  def get_variables
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    api_res = org.get_variables
    variables = api_res.data
    variables.each do |variable_ins|
      print "\n"
      print variable_ins.id
      print "\n"
      print variable_ins.api_name
      print "\n"
      print variable_ins.name
      print "\n"
      print variable_ins.description
      print "\n"
      print variable_ins.value
      print "\n"
      print variable_ins.type
      print "\n"
      print variable_ins.variable_group.id
      print "\n"
      print variable_ins.variable_group.api_name
    end
  end

  def create_variables
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    variables=[]
    variable_ins1=ZCRMSDK::Operations::ZCRMVariable.get_instance("variable_api_name1",nil)
    variable_ins1.name="variable_api_name1"
    variable_ins1.description="variable_api_name1"
    variable_ins1.type="integer"
    variable_ins1.variable_group=ZCRMSDK::Operations::ZCRMVariableGroup.get_instance("General","3524033000000231001")
    variable_ins1.value=23
    variables.push(variable_ins1)
    variable_ins2=ZCRMSDK::Operations::ZCRMVariable.get_instance("variable_api_name2",nil)
    variable_ins2.name="variable_api_name2"
    variable_ins2.description="variable_api_name2"
    variable_ins2.type="integer"
    variable_ins2.variable_group=ZCRMSDK::Operations::ZCRMVariableGroup.get_instance("General","3524033000000231001")
    variable_ins2.value=32
    variables.push(variable_ins2)
    res = org.create_variables(variables).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end
  
  def update_variables
    org = ZCRMSDK::Org::ZCRMOrganization.get_instance
    variables=[]
    variable_ins1=ZCRMSDK::Operations::ZCRMVariable.get_instance("variable_api_name1","3524033000003461001")
    variable_ins1.name="variableasd_api_name1"
    variable_ins1.description="variabasde_api_name1"
    variable_ins1.type="integer"
    variable_ins1.variable_group=ZCRMSDK::Operations::ZCRMVariableGroup.get_instance("General","3524033000000231001")
    variable_ins1.value=23
    variables.push(variable_ins1)
    variable_ins2=ZCRMSDK::Operations::ZCRMVariable.get_instance("variable_api_name2","3524033000003461002")
    variable_ins2.name="variable_apiasd_name2"
    variable_ins2.description="variableasd_api_name2"
    variable_ins2.type="integer"
    variable_ins2.variable_group=ZCRMSDK::Operations::ZCRMVariableGroup.get_instance("General","3524033000000231001")
    variable_ins2.value=32
    variables.push(variable_ins2)
    res = org.update_variables(variables).bulk_entity_response
    res.each do |response|
      print "\n"
      print response.code
      print "\n"
      print response.message
      print "\n"
      print response.details
    end
  end
end

obj = Tester.new

# ZCRMRestClient samples

# obj.get_module
# obj.get_all_modules
# obj.get_organization_details
# obj.get_current_user

# ZCRMOrganization samples

# obj.get_all_roles
# obj.get_role
# obj.get_all_profiles
# obj.get_profile
# obj.get_all_user
# obj.get_user
# obj.get_all_active_users
# obj.get_all_deactive_users
# obj.get_all_confirmed_users
# obj.get_all_not_confirmed_users
# obj.get_all_deleted_users
# obj.get_all_active_confirmed_users
# obj.get_all_admin_users
# obj.get_all_active_confirmed_admin_users
# obj.create_user
# obj.update_user
# obj.delete_user
# obj.get_organization_taxes
# obj.get_organization_tax
# obj.create_organization_taxes
# obj.update_organization_taxes
# obj.delete_organization_taxes
# obj.delete_organization_tax
# obj.search_user_by_criteria
# obj.get_notes
# obj.create_notes
# obj.delete_notes 
# obj.get_variable_groups
# obj.get_variables
# obj.create_variables
# obj.update_variables

# ZCRMCustomView samples

# obj.get_records_from_custom_view

# ZCRMModule samples

# obj.get_record
# obj.get_records
# obj.get_all_deleted_records
# obj.get_recyclebin_records
# obj.get_permanently_deleted_records
# obj.get_all_fields
# obj.get_field
# obj.get_all_layouts
# obj.get_layout
# obj.get_all_customviews
# obj.get_customview
# obj.get_all_relatedlists
# obj.get_relatedlist
# obj.create_records
# obj.upsert_records
# obj.update_records
# obj.update_custom_view
# obj.mass_update_records
# obj.delete_records
# obj.search_records
# obj.search_records_by_phone
# obj.search_records_by_email
# obj.search_records_by_criteria
# obj.get_tag_count
# obj.get_tags
# obj.create_tags
# obj.update_tags
# obj.add_tags_to_multiple_records
# obj.remove_tags_from_multiple_records

# ZCRMRecord samples

# obj.create_record
# obj.update_record
# obj.delete_record
# obj.convert_record
# obj.upload_attachment
# obj.upload_link_as_attachment
# obj.download_attachment
# obj.delete_attachment
# obj.upload_photo
# obj.download_photo
# obj.delete_photo
# obj.add_relation
# obj.remove_relation
# obj.add_notes
# obj.update_note
# obj.delete_note
# obj.get_notes_from_record
# obj.get_attachments
# obj.get_relatedlist_records
# obj.add_tags
# obj.remove_tags

# ZCRMTag samples

# obj.delete_tag
# obj.merge_tag
# obj.update_tag

# ZCRMNote samples

# obj.upload_attachment_to_note
# obj.download_attachment_from_note
# obj.get_attachments_from_note
# obj.delete_attachment_of_note

#ZCRMVariable samples

# obj.get_variable
# obj.delete_variable
# obj.update_variable

#ZCRMVariableGroup samples

# obj.get_variable_group

#OAuth token generation from grant token 

#client = ZCRMSDK::OAuthClient::ZohoOAuth.get_client_instance
#grant_token = 'grant_token'
#client.generate_access_token(grant_token)

#OAuth token generation from refresh token 

#client = ZCRMSDK::OAuthClient::ZohoOAuth.get_client_instance
#refresh_token = 'refresh_token'
#client.generate_access_token_from_refresh_token(refresh_token,useridentifier)


