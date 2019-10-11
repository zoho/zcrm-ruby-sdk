# frozen_string_literal: true

org_details = nil
profiles = nil
roles = nil
users = nil
profile_all = []
role_all = []
user_all = []
user_ids = []
deactive_users = []
active_users = []
confirmed_users = []
not_confirmed_users = []
deleted_users = []
active_confirmed_users = []
admin_users = []
active_confirmed_admins = []
current_user = nil
profile_admin_id = nil
role_admin_id = nil
user_types_all = {}
created_user_response = nil
created_user_id = nil
config_details = { 'client_id' => 'client_id', 'client_secret' => 'client_secret', 'redirect_uri' => 'www.zoho.com', 'api_base_url' => 'https://www.zohoapis.com', 'api_version' => 'v2', 'sandbox' => 'false','log_in_console'=>'true', 'application_log_file_path' => nil, 'current_user_email' => 'current_user_email', 'db_port' => '3306' }
ZCRMSDK::RestClient::ZCRMRestClient.init(config_details)
rest = ZCRMSDK::RestClient::ZCRMRestClient.get_instance
org_ins = rest.get_organization_instance
org_details = rest.get_organization_details.data
profiles = org_ins.get_all_profiles.data
profiles.each do |profile_instance|
  if profile_instance.name == 'Administrator'
    profile_admin_id = profile_instance.id
  end
  profile_all.push(org_ins.get_profile(profile_instance.id).data)
end
roles = org_ins.get_all_roles.data
roles.each do |role_instance|
  role_admin_id = role_instance.id if role_instance.is_admin
  role_all.push(org_ins.get_role(role_instance.id).data)
end
users = org_ins.get_all_users.data
users.each do |user_instance|
  user_all.push(org_ins.get_user(user_instance.id).data)
end
begin
  deactive_users = org_ins.get_all_deactive_users.data
rescue StandardError
end
begin
  active_users = org_ins.get_all_active_users.data
rescue StandardError
end
begin
  confirmed_users = org_ins.get_all_confirmed_users.data
rescue StandardError
end
begin
  not_confirmed_users = org_ins.get_all_not_confirmed_users.data
rescue StandardError
end
begin
  deleted_users = org_ins.get_all_deleted_users.data
rescue StandardError
end
begin
  active_confirmed_users = org_ins.get_all_active_confirmed_users.data
rescue StandardError
end
begin
  admin_users = org_ins.get_all_admin_users.data
rescue StandardError
end
begin
  active_confirmed_admins = org_ins.get_all_active_confirmed_admin_users.data
rescue StandardError
end
current_user = org_ins.get_current_user.data[0]
create_user = ZCRMSDK::Operations::ZCRMUser.get_instance
create_user.profile = ZCRMSDK::Operations::ZCRMProfile.get_instance(profile_admin_id, nil)
create_user.role = ZCRMSDK::Operations::ZCRMRole.get_instance(role_admin_id, nil)
create_user.country = 'India'
create_user.city = 'chennai'
create_user.signature = 'asdsd'
create_user.name_format = 'Salutation,First Name,Last Name'
create_user.locale = 'hi_IN'
create_user.street = 'Asdd'
create_user.alias_aka = 'asdd'
create_user.state = 'Tamil Nadu'
create_user.fax = '42342'
create_user.first_name = 'dum'
create_user.email = 'ruby_automation@sdk.com'
create_user.zip = '600010'
create_user.website = 'www.zoho.com'
create_user.time_format = 'hh:mm a'
create_user.mobile = '34234324'
create_user.last_name = 'dum_dum'
create_user.phone = '2343243242'
create_user.reporting_to = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user.id)
create_user.date_format = 'yyyy/MM/dd'
create_user.dob = '1997-12-29'
created_user_response = org_ins.create_user(create_user)
created_user_id = created_user_response.details['id']
created_user = org_ins.get_user(created_user_id).data
update_user = ZCRMSDK::Operations::ZCRMUser.get_instance
update_user.id = created_user_id
update_user.profile = ZCRMSDK::Operations::ZCRMProfile.get_instance(profile_admin_id, nil)
update_user.role = ZCRMSDK::Operations::ZCRMRole.get_instance(role_admin_id, nil)
update_user.country = 'India'
update_user.city = 'sd'
update_user.signature = 'sddsd'
update_user.name_format = 'Salutation,First Name,Last Name'
update_user.locale = 'hi_IN'
update_user.street = 'Asdd'
update_user.alias_aka = 'asdd'
update_user.state = 'Tamil Nadu'
update_user.fax = '42342'
update_user.first_name = 'dum'
update_user.zip = '60010'
update_user.website = 'www.zoho.com'
update_user.time_format = 'hh:mm a'
update_user.mobile = '34234324'
update_user.last_name = 'dum_dum'
update_user.phone = '2343243242'
update_user.date_format = 'yyyy/MM/dd'
update_user.dob = '1997-12-29'
updated_user_response = org_ins.update_user(update_user)
updated_user_id = updated_user_response.details['id']
updated_user = org_ins.get_user(updated_user_id).data
deleted_response = org_ins.delete_user(created_user_id)
deleted_user = org_ins.get_user(created_user_id).data
begin
organization_taxes = org_ins.get_organization_taxes.data
rescue => e
end
org_tax_all = []
organization_taxes.each do |org_tax|
  org_tax_all.push(org_ins.get_organization_tax(org_tax.id).data)
end
create_orgtaxes = []
created_orgtax_ids = []
created_orgtaxes = []
create_orgtax1 = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
create_orgtax1.name = '12'
create_orgtax1.value = 1
create_orgtax2 = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
create_orgtax2.name = '23'
create_orgtax2.value = 2
create_orgtax3 = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
create_orgtax3.name = '34'
create_orgtax3.value = 3
create_orgtaxes.push(create_orgtax1)
create_orgtaxes.push(create_orgtax2)
create_orgtaxes.push(create_orgtax3)
create_orgtaxes_responses = org_ins.create_organization_taxes(create_orgtaxes).bulk_entity_response
create_orgtaxes_responses.each do |create_orgtaxes_response|
  created_orgtax_ids.push(create_orgtaxes_response.details['id'])
  created_orgtaxes.push(org_ins.get_organization_tax(create_orgtaxes_response.details['id']).data)
end
update_orgtaxes = []
updated_orgtax_ids = []
updated_orgtaxes = []
update_orgtax1 = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
update_orgtax1.id = created_orgtax_ids[0]
update_orgtax1.name = '21'
update_orgtax1.value = 4
update_orgtax2 = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
update_orgtax2.id = created_orgtax_ids[1]
update_orgtax2.name = '32'
update_orgtax2.value = 5
update_orgtax3 = ZCRMSDK::Operations::ZCRMOrgTax.get_instance
update_orgtax3.id = created_orgtax_ids[2]
update_orgtax3.name = '43'
update_orgtax3.value = 6
update_orgtaxes.push(update_orgtax1)
update_orgtaxes.push(update_orgtax2)
update_orgtaxes.push(update_orgtax3)
update_orgtaxes_responses = org_ins.update_organization_taxes(update_orgtaxes).bulk_entity_response
update_orgtaxes_responses.each do |update_orgtaxes_response|
  print update_orgtaxes_response
  updated_orgtax_ids.push(update_orgtaxes_response.details['id'])
  updated_orgtaxes.push(org_ins.get_organization_tax(update_orgtaxes_response.details['id']).data)
end
delete_org_taxes_ids = []
deleted_org_taxes = []
delete_org_tax = nil
delete_org_taxes_ids.push(created_orgtax_ids[0])
delete_org_taxes_ids.push(created_orgtax_ids[1])
deleted_org_taxes = org_ins.delete_organization_taxes(delete_org_taxes_ids).bulk_entity_response
delete_org_tax = org_ins.delete_organization_tax(created_orgtax_ids[2])
search_users = org_ins.search_users_by_criteria('country:equals:India', 'AdminUsers').data
RSpec.describe 'Organization' do
  it 'get_organization_details' do
    expect(org_details).to be_an_instance_of(ZCRMSDK::Org::ZCRMOrganization)
    expect(org_details.company_name).to be_a_kind_of(String)
    expect(org_details.org_id).to be_a_kind_of(String)
    expect(org_details.alias_aka).to be_a_kind_of(String)
    expect(org_details.primary_zuid).to be_a_kind_of(String)
    expect(org_details.zgid).to be_a_kind_of(String)
    expect(org_details.primary_email).to be_a_kind_of(String)
    expect(org_details.website).to be_a_kind_of(String)
    expect(org_details.mobile).to be_a_kind_of(String)
    expect(org_details.phone).to be_a_kind_of(String)
    expect(org_details.employee_count).to be_a_kind_of(String)
    expect(org_details.description).to be_a_kind_of(String)
    expect(org_details.time_zone).to be_a_kind_of(String)
    expect(org_details.iso_code).to be_a_kind_of(String)
    expect(org_details.currency_locale).to be_a_kind_of(String)
    expect(org_details.currency_symbol).to be_a_kind_of(String)
    expect(org_details.street).to be_a_kind_of(String)
    expect(org_details.state).to be_a_kind_of(String)
    expect(org_details.city).to be_a_kind_of(String)
    expect(org_details.country).to be_a_kind_of(String)
    expect(org_details.zip_code).to be_a_kind_of(String)
    expect(org_details.country_code).to be_a_kind_of(String)
    expect(org_details.fax).to be_a_kind_of(String)
    expect(org_details.mc_status).to be(true).or be(false)
    expect(org_details.is_gapps_enabled).to be(true).or be(false)
    if org_details.is_paid_account
      expect(org_details.paid_expiry).to be_a_kind_of(String)
      expect(org_details.paid_type).to be_a_kind_of(String)
    else
      expect(org_ins.trial_type).to be_a_kind_of(String)
      expect(org_ins.trial_expiry).to be_a_kind_of(String)
    end
    expect(org_details.is_paid_account).to be(true).or be(false)
    expect(org_details.currency).to be_a_kind_of(String)
    expect(org_details.zia_portal_id).to be_a_kind_of(String)
    expect(org_details.privacy_settings).to be(true).or be(false)
    expect(org_details.photo_id).to be_a_kind_of(String)
    expect(org_details.users_license_purchased).to be_a_kind_of(Integer)
  end

  it 'get_all_profiles' do
    profiles.each do |profile_instance|
      expect(profile_instance).to be_a_kind_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile_instance.name).to be_a_kind_of(String)
      expect(profile_instance.id).to be_a_kind_of(String)
      expect(profile_instance.created_time).to be_a_kind_of(String).or be(nil)
      expect(profile_instance.modified_time).to be_a_kind_of(String).or be(nil)
      modified_by = profile_instance.modified_by
      unless modified_by.nil?
        expect(modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(modified_by.id).to be_a_kind_of(String)
        expect(modified_by.name).to be_a_kind_of(String)
      end
      expect(profile_instance.description).to be_a_kind_of(String)
      created_by = profile_instance.created_by
      if %w[Administrator Standard].include?(profile_instance.name)
        expect(created_by).to be(nil)
      else
        expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(created_by.id).to be_a_kind_of(String)
        expect(created_by.name).to be_a_kind_of(String)
      end
      expect(profile_instance.category).to be(true).or be(false)
    end
  end
  it 'get_profile' do
    profile_all.each do |profile_instance|
      expect(profile_instance).to be_a_kind_of(ZCRMSDK::Operations::ZCRMProfile)
      print profile_instance.id
      print "\n"
      expect(profile_instance.name).to be_a_kind_of(String)
      expect(profile_instance.id).to be_a_kind_of(String)
      expect(profile_instance.created_time).to be_a_kind_of(String).or be(nil)
      expect(profile_instance.modified_time).to be_a_kind_of(String).or be(nil)
      modified_by = profile_instance.modified_by
      unless modified_by.nil?
        expect(modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(modified_by.id).to be_a_kind_of(String)
        expect(modified_by.name).to be_a_kind_of(String)
      end
      expect(profile_instance.description)
      created_by = profile_instance.created_by
      if %w[Administrator Standard].include?(profile_instance.name)
        expect(created_by).to be(nil)
      else
        expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(created_by.id).to be_a_kind_of(String)
        expect(created_by.name).to be_a_kind_of(String)
      end
      expect(profile_instance.category)
      permissions = profile_instance.permissions
      permissions.each do |permission|
        expect(permission).to be_an_instance_of(ZCRMSDK::Operations::ZCRMPermission)
        expect(permission.id).to be_a_kind_of(String)
        expect(permission.name).to be_a_kind_of(String)
        expect(permission.display_label).to be_a_kind_of(String).or be(nil)
        expect(permission.module_api_name).to be_a_kind_of(String).or be(nil)
        expect(permission.is_enabled).to be(true).or be(false)
      end
      sections = profile_instance.sections
      sections.each do |section|
        expect(section).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfileSection)
        expect(section.name)
        categories = section.categories
        categories.each do |category|
          expect(category).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfileCategory)
          expect(category.name).to be_a_kind_of(String)
          expect(category.display_label).to be_a_kind_of(String)
          expect(category.permission_ids).to be_a_kind_of(Array)
          expect(category.module_api_name).to be_a_kind_of(String).or be(nil)
        end
      end
    end
  end
  it 'get_all_roles' do
    roles.each do |role_instance|
      expect(role_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role_instance.name).to be_a_kind_of(String)
      expect(role_instance.id).to be_a_kind_of(String)
      reporting_to = role_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.name).to be_a_kind_of(String)
        expect(reporting_to.id).to be_a_kind_of(String)
      end
      expect(role_instance.display_label).to be_a_kind_of(String)
      expect(role_instance.is_admin).to be(true).or be(false)
      forecast_manager = role_instance.forecast_manager
      unless forecast_manager.nil?
        expect(forecast_manager).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(forecast_manager.name).to be_a_kind_of(String)
        expect(forecast_manager.id).to be_a_kind_of(String)
      end
      expect(role_instance.is_share_with_peers).to be(true).or be(false)
      expect(role_instance.description).to be_a_kind_of(String)
    end
  end
  it 'get_role' do
    role_all.each do |role_instance|
      expect(role_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      print role_instance.id
      expect(role_instance.name).to be_a_kind_of(String)
      expect(role_instance.id).to be_a_kind_of(String)
      reporting_to = role_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.name).to be_a_kind_of(String)
        expect(reporting_to.id).to be_a_kind_of(String)
      end
      expect(role_instance.display_label).to be_a_kind_of(String)
      expect(role_instance.is_admin).to be(true).or be(false)
      forecast_manager = role_instance.forecast_manager
      unless forecast_manager.nil?
        expect(forecast_manager).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(forecast_manager.name).to be_a_kind_of(String)
        expect(forecast_manager.id).to be_a_kind_of(String)
      end
      expect(role_instance.is_share_with_peers).to be(true).or be(false)
      expect(role_instance.description).to be_a_kind_of(String)
    end
  end
  it 'get_users' do
    users.each do |user_instance|
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String).or be(nil)
      expect(user_instance.is_confirm).to be(true).or be(false)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to be_a_kind_of(String)
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'get_user' do
    user_all.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String).or be(nil)
      expect(user_instance.is_confirm).to be(true).or be(false)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to be_a_kind_of(String)
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'deactive_users' do
    deactive_users.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String).or be(nil)
      expect(user_instance.is_confirm).to be(true).or be(false)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to eql('disabled')
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'active_users' do
    active_users.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String)
      expect(user_instance.is_confirm).to be(true).or be(false)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to eql('active')
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'confirmed_users' do
    confirmed_users.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String).or be(nil)
      print user_instance.is_confirm
      print "\n"
      expect(user_instance.is_confirm).to be(true)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to be_a_kind_of(String)
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'not_confirmed_users' do
    not_confirmed_users.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String).or be(nil)
      expect(user_instance.is_confirm).to be(false)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to be_a_kind_of(String)
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'deleted_users' do
    deleted_users.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String).or be(nil)
      expect(user_instance.is_confirm).to be(true).or be(false)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to eql('deleted')
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'active_confirmed_users' do
    active_confirmed_users.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to be_a_kind_of(String)
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String)
      expect(user_instance.is_confirm).to be(true)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to eql('active')
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'admin_users' do
    admin_users.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to eql('Administrator')
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String).or be(nil)
      expect(user_instance.is_confirm).to be(true).or be(false)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to be_a_kind_of(String)
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'active_confirmed_admins' do
    active_confirmed_admins.each do |user_instance|
      print user_instance.id
      print "\n"
      expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(user_instance.id).to be_a_kind_of(String)
      expect(user_instance.is_microsoft).to be(true).or be(false)
      expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country).to be_a_kind_of(String).or be(nil)
      role = user_instance.role
      expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
      expect(role.id).to be_a_kind_of(String)
      expect(role.name).to be_a_kind_of(String)
      customize_info = user_instance.customize_info
      unless customize_info.nil?
        expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
        expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
        expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
        expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
        expect(customize_info.is_to_show_home).to be(true).or be(false)
        expect(customize_info.is_to_show_detail_view).to be(true).or be(false)
      end
      expect(user_instance.city).to be_a_kind_of(String).or be(nil)
      expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
      expect(user_instance.language).to be_a_kind_of(String)
      expect(user_instance.locale).to be_a_kind_of(String)
      expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
      expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
      expect(user_instance.street).to be_a_kind_of(String).or be(nil)
      expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
      theme = user_instance.theme
      unless theme.nil?
        expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
        expect(theme.normal_tab_font_color).to be_a_kind_of(String)
        expect(theme.normal_tab_background).to be_a_kind_of(String)
        expect(theme.selected_tab_font_color).to be_a_kind_of(String)
        expect(theme.selected_tab_background).to be_a_kind_of(String)
        expect(theme.new_background).to be_a_kind_of(String)
        expect(theme.background).to be_a_kind_of(String)
        expect(theme.screen).to be_a_kind_of(String)
        expect(theme.type).to be_a_kind_of(String)
      end
      expect(user_instance.state).to be_a_kind_of(String).or be(nil)
      expect(user_instance.country_locale).to be_a_kind_of(String)
      expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
      expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
      expect(user_instance.email).to be_a_kind_of(String)
      expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
      expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
      expect(user_instance.website).to be_a_kind_of(String).or be(nil)
      expect(user_instance.time_format).to be_a_kind_of(String)
      profile = user_instance.profile
      expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
      expect(profile.id).to be_a_kind_of(String)
      expect(profile.name).to eql('Administrator')
      expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
      expect(user_instance.last_name).to be_a_kind_of(String)
      expect(user_instance.time_zone).to be_a_kind_of(String)
      expect(user_instance.zuid).to be_a_kind_of(String)
      expect(user_instance.is_confirm).to be(true)
      expect(user_instance.full_name).to be_a_kind_of(String)
      expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
      expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
      expect(user_instance.date_format).to be_a_kind_of(String)
      expect(user_instance.status).to eql('active')
      creator = user_instance.created_by
      expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(creator.id).to be_a_kind_of(String)
      expect(creator.name).to be_a_kind_of(String)
      modifier = user_instance.modified_by
      expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(modifier.id).to be_a_kind_of(String)
      expect(modifier.name).to be_a_kind_of(String)
      expect(user_instance.territories).to be_a_kind_of(Array)
      reporting_to = user_instance.reporting_to
      unless reporting_to.nil?
        expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(reporting_to.id).to be_a_kind_of(String)
        expect(reporting_to.name).to be_a_kind_of(String)
      end
      expect(user_instance.is_online).to be(true).or be(false)
      expect(user_instance.created_time).to be_a_kind_of(String)
      expect(user_instance.modified_time).to be_a_kind_of(String)
    end
  end
  it 'current_user' do
    user_instance = current_user
    print user_instance.id
    print "\n"
    expect(user_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
    expect(user_instance.id).to be_a_kind_of(String)
    expect(user_instance.is_microsoft).to be(true).or be(false)
    expect(user_instance.signature).to be_a_kind_of(String).or be(nil)
    expect(user_instance.country).to be_a_kind_of(String).or be(nil)
    role = user_instance.role
    expect(role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
    expect(role.id).to be_a_kind_of(String)
    expect(role.name).to be_a_kind_of(String)
    customize_info = user_instance.customize_info

    expect(customize_info).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserCustomizeInfo)
    expect(customize_info.notes_desc).to be_a_kind_of(String).or be(nil)
    expect(customize_info.is_to_show_right_panel).to be(true).or be(false)
    expect(customize_info.is_bc_view).to be(true).or be(false).or be(nil)
    expect(customize_info.is_to_show_home).to be(true).or be(false)
    expect(customize_info.is_to_show_detail_view).to be(true).or be(false)

    expect(user_instance.city).to be_a_kind_of(String).or be(nil)
    expect(user_instance.name_format).to be_a_kind_of(String).or be(nil)
    expect(user_instance.language).to be_a_kind_of(String)
    expect(user_instance.locale).to be_a_kind_of(String)
    expect(user_instance.is_personal_account).to be(true).or be(false).or be(nil)
    expect(user_instance.default_tab_group).to be_a_kind_of(String).or be(nil)
    expect(user_instance.street).to be_a_kind_of(String).or be(nil)
    expect(user_instance.alias_aka).to be_a_kind_of(String).or be(nil)
    theme = user_instance.theme

    expect(theme).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUserTheme)
    expect(theme.normal_tab_font_color).to be_a_kind_of(String)
    expect(theme.normal_tab_background).to be_a_kind_of(String)
    expect(theme.selected_tab_font_color).to be_a_kind_of(String)
    expect(theme.selected_tab_background).to be_a_kind_of(String)
    expect(theme.new_background).to be_a_kind_of(String)
    expect(theme.background).to be_a_kind_of(String)
    expect(theme.screen).to be_a_kind_of(String)
    expect(theme.type).to be_a_kind_of(String)

    expect(user_instance.state).to be_a_kind_of(String).or be(nil)
    expect(user_instance.country_locale).to be_a_kind_of(String)
    expect(user_instance.fax).to be_a_kind_of(String).or be(nil)
    expect(user_instance.first_name).to be_a_kind_of(String).or be(nil)
    expect(user_instance.email).to be_a_kind_of(String)
    expect(user_instance.zip).to be_a_kind_of(String).or be(nil)
    expect(user_instance.decimal_separator).to be_a_kind_of(String).or be(nil)
    expect(user_instance.website).to be_a_kind_of(String).or be(nil)
    expect(user_instance.time_format).to be_a_kind_of(String)
    profile = user_instance.profile
    expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
    expect(profile.id).to be_a_kind_of(String)
    expect(profile.name).to be_a_kind_of(String)
    expect(user_instance.mobile).to be_a_kind_of(String).or be(nil)
    expect(user_instance.last_name).to be_a_kind_of(String)
    expect(user_instance.time_zone).to be_a_kind_of(String)
    expect(user_instance.zuid).to be_a_kind_of(String)
    expect(user_instance.is_confirm).to be(true).or be(false)
    expect(user_instance.full_name).to be_a_kind_of(String)
    expect(user_instance.phone).to be_a_kind_of(String).or be(nil)
    expect(user_instance.dob).to be_a_kind_of(String).or be(nil)
    expect(user_instance.date_format).to be_a_kind_of(String)
    expect(user_instance.status).to be_a_kind_of(String)
    creator = user_instance.created_by
    expect(creator).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
    expect(creator.id).to be_a_kind_of(String)
    expect(creator.name).to be_a_kind_of(String)
    modifier = user_instance.modified_by
    expect(modifier).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
    expect(modifier.id).to be_a_kind_of(String)
    expect(modifier.name).to be_a_kind_of(String)
    expect(user_instance.territories).to be_a_kind_of(Array)
    reporting_to = user_instance.reporting_to
    unless reporting_to.nil?
      expect(reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(reporting_to.id).to be_a_kind_of(String)
      expect(reporting_to.name).to be_a_kind_of(String)
    end
    expect(user_instance.is_online).to be(true).or be(false)
    expect(user_instance.created_time).to be_a_kind_of(String)
    expect(user_instance.modified_time).to be_a_kind_of(String)
  end
  it 'create_user' do
    expect(created_user.role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
    expect(created_user.role.id).to eql(role_admin_id)
    expect(created_user.role.name).to be_a_kind_of(String)
    expect(created_user.profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
    expect(created_user.profile.id).to eql(profile_admin_id)
    expect(created_user.profile.name).to eql('Administrator')
    expect(created_user.country).to eql('India')
    expect(created_user.city).to eql('chennai')
    expect(created_user.language).to eql('en_US')
    expect(created_user.locale).to eql('hi_IN')
    expect(created_user.is_microsoft).to be(false)
    expect(created_user.is_online).to be(false)
    expect(created_user.id).to be_a_kind_of(String)
    expect(created_user.created_time).to be_a_kind_of(String)
    expect(created_user.modified_time).to be_a_kind_of(String)
    expect(created_user.street).to eql('Asdd')
    expect(created_user.country_locale).to eql('US')
    expect(created_user.alias_aka).to eql('asdd')
    expect(created_user.state).to eql('Tamil Nadu')
    expect(created_user.fax).to eql('42342')
    expect(created_user.first_name).to eql('dum')
    expect(created_user.time_zone).to eql('Asia/Calcutta')
    expect(created_user.email).to eql('ruby_automation@sdk.com')
    expect(created_user.reporting_to).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
    expect(created_user.reporting_to.id).to eql(current_user.id)
    expect(created_user.reporting_to.name).to be_a_kind_of(String)
    expect(created_user.zip).to eql('600010')
    expect(created_user.zuid).to be(nil)
    expect(created_user.is_confirm).to be(false)
    expect(created_user.website).to eql('www.zoho.com')
    expect(created_user.full_name).to eql('dum dum_dum')
    expect(created_user.time_format).to eql('hh:mm a')
    expect(created_user.mobile).to eql('34234324')
    expect(created_user.last_name).to eql('dum_dum')
    expect(created_user.phone).to eql('2343243242')
    expect(created_user.date_format).to eql('MM/dd/yyyy')
  end
  it 'update_user' do
    expect(updated_user.role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
    expect(updated_user.role.id).to eql(role_admin_id)
    expect(updated_user.role.name).to be_a_kind_of(String)
    expect(updated_user.profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
    expect(updated_user.profile.id).to eql(profile_admin_id)
    expect(updated_user.profile.name).to eql('Administrator')
    expect(updated_user.country).to eql('India')
    expect(updated_user.city).to eql('sd')
    expect(updated_user.language).to eql('en_US')
    expect(updated_user.is_microsoft).to be(false)
    expect(updated_user.is_online).to be(false)
    expect(updated_user.id).to be_a_kind_of(String)
    expect(updated_user.created_time).to be_a_kind_of(String)
    expect(updated_user.modified_time).to be_a_kind_of(String)
    expect(updated_user.country_locale).to eql('US')
    expect(updated_user.locale).to eql('hi_IN')
    expect(updated_user.street).to eql('Asdd')
    expect(updated_user.alias_aka).to eql('asdd')
    expect(updated_user.state).to eql('Tamil Nadu')
    expect(updated_user.fax).to eql('42342')
    expect(updated_user.first_name).to eql('dum')
    expect(updated_user.email).to eql('ruby_automation@sdk.com')
    expect(updated_user.zip).to eql('60010')
    expect(updated_user.zuid).to be(nil)
    expect(updated_user.is_confirm).to be(false)
    expect(updated_user.website).to eql('www.zoho.com')
    expect(updated_user.time_format).to eql('hh:mm a')
    expect(updated_user.mobile).to eql('34234324')
    expect(updated_user.last_name).to eql('dum_dum')
    expect(updated_user.phone).to eql('2343243242')
    expect(updated_user.date_format).to eql('MM/dd/yyyy')
  end
  it 'delete_user' do
    expect(deleted_response.status_code).to eql(200)
    expect(deleted_user.role).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRole)
    expect(deleted_user.role.id).to eql(role_admin_id)
    expect(deleted_user.role.name).to be_a_kind_of(String)
    expect(deleted_user.profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
    expect(deleted_user.profile.id).to eql(profile_admin_id)
    expect(deleted_user.profile.name).to eql('Administrator')
    expect(deleted_user.country).to eql('India')
    expect(deleted_user.city).to eql('sd')
    expect(deleted_user.language).to eql('en_US')
    expect(deleted_user.is_microsoft).to be(false)
    expect(deleted_user.is_online).to be(false)
    expect(deleted_user.id).to be_a_kind_of(String)
    expect(deleted_user.created_time).to be_a_kind_of(String)
    expect(deleted_user.modified_time).to be_a_kind_of(String)
    expect(deleted_user.country_locale).to eql('US')
    expect(deleted_user.locale).to eql('hi_IN')
    expect(deleted_user.street).to eql('Asdd')
    expect(deleted_user.alias_aka).to eql('asdd')
    expect(deleted_user.state).to eql('Tamil Nadu')
    expect(deleted_user.fax).to eql('42342')
    expect(deleted_user.first_name).to eql('dum')
    expect(deleted_user.email).to eql('ruby_automation@sdk.com')
    expect(deleted_user.zip).to eql('60010')
    expect(deleted_user.zuid).to be(nil)
    expect(deleted_user.is_confirm).to be(false)
    expect(deleted_user.website).to eql('www.zoho.com')
    expect(deleted_user.time_format).to eql('hh:mm a')
    expect(deleted_user.mobile).to eql('34234324')
    expect(deleted_user.last_name).to eql('dum_dum')
    expect(deleted_user.phone).to eql('2343243242')
    expect(deleted_user.date_format).to eql('MM/dd/yyyy')
    expect(deleted_user.status).to eql('deleted')
  end
  it 'get_organization_taxes' do
    organization_taxes.each do |org_tax_instance|
      expect(org_tax_instance.id).to be_a_kind_of(String)
      expect(org_tax_instance.name).to be_a_kind_of(String)
      expect(org_tax_instance.display_label).to be_a_kind_of(String)
      expect(org_tax_instance.value).to be_a_kind_of(Integer)
    end
  end
  it 'get_organization_tax' do
    org_tax_all.each do |org_tax_instance|
      expect(org_tax_instance.id).to be_a_kind_of(String)
      expect(org_tax_instance.name).to be_a_kind_of(String)
      expect(org_tax_instance.display_label).to be_a_kind_of(String)
      expect(org_tax_instance.value).to be_a_kind_of(Integer)
    end
  end
  it 'create_organization_taxes' do
    org_tax_instance = created_orgtaxes[0]
    expect(org_tax_instance.name).to eql('12')
    expect(org_tax_instance.display_label).to eql('12')
    expect(org_tax_instance.value).to eql(1)
    org_tax_instance = created_orgtaxes[1]
    expect(org_tax_instance.name).to eql('23')
    expect(org_tax_instance.display_label).to eql('23')
    expect(org_tax_instance.value).to eql(2)
    org_tax_instance = created_orgtaxes[2]
    expect(org_tax_instance.name).to eql('34')
    expect(org_tax_instance.display_label).to eql('34')
    expect(org_tax_instance.value).to eql(3)
  end
  it 'update_organization_taxes' do
    org_tax_instance = updated_orgtaxes[0]
    expect(org_tax_instance.name).to eql('21')
    expect(org_tax_instance.display_label).to eql('21')
    expect(org_tax_instance.value).to eql(4)
    org_tax_instance = updated_orgtaxes[1]
    expect(org_tax_instance.name).to eql('32')
    expect(org_tax_instance.display_label).to eql('32')
    expect(org_tax_instance.value).to eql(5)
    org_tax_instance = updated_orgtaxes[2]
    expect(org_tax_instance.name).to eql('43')
    expect(org_tax_instance.display_label).to eql('43')
    expect(org_tax_instance.value).to eql(6)
  end
  it 'delete_organization_taxes' do
    deleted_org_taxes.each do |deleted_org_tax_resp|
      expect(deleted_org_tax_resp.code).to eql('SUCCESS')
    end
  end
  it 'delete_organization_tax' do
    expect(delete_org_tax.status_code).to eql(200)
  end
  it 'search_users_by_criteria' do
    search_users.each do |search_user|
      expect(search_user.profile.name).to eql('Administrator')
      expect(search_user.country).to eql('India')
    end
  end
end
