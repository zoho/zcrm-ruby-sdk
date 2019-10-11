# frozen_string_literal: true

require 'mysql2'
require 'json'
activity_module = %w[Tasks Events Calls]
sort_order_module = %w[Leads Vendors Price_Books Products Campaigns Solutions Accounts Contacts Deals Quotes Sales_Orders Purchase_Orders Invoices Cases Tasks Events Calls]
config_details = { 'client_id' => 'client_id', 'client_secret' => 'client_secret', 'redirect_uri' => 'www.zoho.com', 'api_base_url' => 'https://www.zohoapis.com', 'api_version' => 'v2', 'sandbox' => 'false', 'application_log_file_path' => nil, 'current_user_email' => 'current_user_email', 'db_port' => '3306' }
ZCRMSDK::RestClient::ZCRMRestClient.init(config_details)
rest = ZCRMSDK::RestClient::ZCRMRestClient.get_instance
current_user = rest.get_organization_instance.get_current_user.data[0]
current_user_id = current_user.id
current_user_name = current_user.full_name
file_path = '/Users/path/Downloads/resource.jpg'
file_link = 'https://archive.org/download/android_logo_low_quality/android_logo_low_quality.jpg'
con = Mysql2::Client.new(host: config_details['db_address'], username: config_details['db_username'], password: config_details['db_password'], database: 'zohooauth', port: config_details['db_port'])
query = "select * from oauthtokens where useridentifier='" + config_details['current_user_email'] + "'"
rs = con.query(query)
oauth_tokens = nil
accesstoken = nil
rs.each do |row|
  accesstoken = row['accesstoken']
  con.close
end
url = URI('https://zohoapis.com/crm/v2/Contacts/roles')
http = Net::HTTP.new(url.host, url.port)
req = Net::HTTP::Get.new(url.request_uri)
accesstoken = 'Zoho-oauthtoken ' + accesstoken
req.add_field('Authorization', accesstoken)
http.use_ssl = true
response = http.request(req)
contact_role_id = JSON.parse(response.body)['contact_roles'][0]['id']
modules = []
record_count = 1
modules = rest.get_all_modules.data
module_api_names = []
creatable_module_api_names = []
created_record = {}
deleted_record_response = {}
convert_lead_response = nil
add_note_response = {}
update_note_response = {}
added_note = {}
updated_note = {}
deleted_note = {}
note_ids = {}
upload_attachment_response = {}
upload_attachment_link_response = {}
get_attachment_response = {}
download_attachment_response = {}
delete_attachment_attachment_response = {}
upload_photo_response = {}
download_photo_response = {}
delete_photo_response = {}
add_tags_record = {}
remove_tags_record = {}
add_relation_response = {}
remove_relation_response = {}
get_relatedrecords = {}
tag_delete_response = nil
tag_merge_response = nil
tag_update_response = nil
note_upload_attachment_res = nil
note_download_attachment_res = nil
note_delete_attachment_res = []
note_get_attachment = nil
modulevsfields = {} # moduleapiname vs all fields data
moduleapinamevsfieldsarrayvsfielddetail = {}
modules.each do |module_instance|
  if module_instance.is_api_supported
    module_api_names.push(module_instance.api_name)
  end
  if module_instance.is_quick_create
    creatable_module_api_names.push(module_instance.api_name)
  end
end
sort_order_module.each do |module_apiname|
  if creatable_module_api_names.include? module_apiname
    creatable_module_api_names -= [module_apiname]
    creatable_module_api_names.push(module_apiname)
  end
end
#module_api_names = %w[Leads Contacts Price_Books Accounts Deals Activities Products Quotes Sales_Orders Purchase_Orders Invoices Campaigns Vendors Price_Books Cases Solutions Visits Tasks Events Notes Attachments Calls Actions_Performed Approvals]
#module_api_names = %w[Leads Vendors Price_Books Products Campaigns Solutions Accounts Contacts Deals Quotes Sales_Orders Purchase_Orders Invoices Cases Tasks Events Calls]
#module_api_names = %w[Leads Price_Books Products Campaigns Accounts Contacts Deals]
module_api_names.each do |module_api_name| # fields
  if module_api_name != 'Approvals'
    module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
    modulevsfields[module_api_name] = module_instance.get_all_fields.data
  end
end
module_api_names.each do |module_api_name| # setting module vs fields
  next unless module_api_name != 'Approvals'

  fieldsarray = {}
  modulevsfields[module_api_name].each do |field|
    fielddetails = {}
    next unless (field.field_layout_permissions.include?('CREATE') || field.api_name == 'Tag') && field.api_name != 'Exchange_Rate'

    fielddetails = {}
    if field.field_layout_permissions.include?('EDIT')
      fielddetails['editable'] == true
    end
    fielddetails['data_type'] = field.data_type
    fielddetails['decimal_place'] = field.decimal_place
    fielddetails['field_label'] = field.field_label
    fielddetails['length'] = field.length unless field.length.nil?
    if field.data_type == 'lookup'
      fielddetails['lookup'] = field.lookup_field
    elsif field.data_type == 'multiselectlookup'
      fielddetails['multiselectlookup'] = field.multiselectlookup
    elsif field.data_type == 'picklist' || field.data_type == 'multiselectpicklist'
      fielddetails['picklist'] = field.picklist_values
    elsif field.data_type == 'currency'
      fielddetails['precision'] = field.precision
      fielddetails['rounding_option'] = field.rounding_option
    end
    fieldsarray[field.api_name] = fielddetails
  end
  moduleapinamevsfieldsarrayvsfielddetail[module_api_name] = fieldsarray
end
#creatable_module_api_names = %w[Leads Price_Books Products Campaigns Accounts Contacts Deals]
creatable_module_api_names.each do |creatable_module_api_name| # create()
  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, nil)
  moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
    datatype = field_details['data_type']
    length = field_details['length']
    fieldlabel = field_details['field_label']
    lookup_ins = field_details['lookup']
    if datatype == 'ownerlookup'
      record1.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user_id)
    elsif fieldlabel == 'Pricing Details'
      price_ins = ZCRMSDK::Operations::ZCRMPriceBookPricing.get_instance
      price_ins.from_range = 1
      price_ins.to_range = 100
      price_ins.discount = 5
      record1.price_details = [price_ins]
    elsif fieldlabel == 'Product Details'
      line_item_instance = ZCRMSDK::Operations::ZCRMInventoryLineItem.get_instance(ZCRMSDK::Operations::ZCRMRecord.get_instance('Products', created_record['Products'][0].entity_id))
      line_item_instance.description = 'ruby_automation_lineitem'
      line_item_instance.list_price = 123
      line_item_instance.quantity = 10
      line_item_instance.discount = 10
      record1.line_items.push(line_item_instance)
    elsif fieldlabel == 'Participants'
      record1.field_data[field_api_name] = [{ 'type' => 'user', 'participant' => current_user_id }]
    elsif fieldlabel == 'Call Duration'
      record1.field_data[field_api_name] = '10:00'
    elsif datatype == 'lookup'
      if created_record[lookup_ins.module_apiname]
        record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][0].entity_id
      end
      if lookup_ins.module_apiname == 'se_module'
        record1.field_data['$se_module'] = 'Accounts'
        record1.field_data[field_api_name] = { 'id' => created_record['Accounts'][0].entity_id }
      end
    elsif datatype == 'text'
      word = '1234567890'
      word = word[0, length - 1]
      record1.field_data[field_api_name] = word
    elsif datatype == 'RRULE'
      if creatable_module_api_name == 'Events'
        record1.field_data[field_api_name] = { 'RRULE' => 'FREQ=YEARLY;INTERVAL=99;DTSTART=2017-08-29;UNTIL=2017-08-29' }
      else
        record1.field_data[field_api_name] = { 'RRULE' => 'FREQ=DAILY;INTERVAL=99;DTSTART=2017-08-29;UNTIL=2017-08-29' }
      end
    elsif datatype == 'event_reminder'
      record1.field_data[field_api_name] = '0'
    elsif datatype == 'ALARM'
      record1.field_data[field_api_name] = { 'ALARM' => 'FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30' }
    elsif datatype == 'picklist'
      if field_details['picklist'].length > 1
        record1.field_data[field_api_name] = field_details['picklist'][1].display_value
      elsif
        record1.field_data[field_api_name] = field_details['picklist'][0].display_value
      end
    elsif datatype == 'multiselectpicklist'
      record1.field_data[field_api_name] = [field_details['picklist'][0].display_value]
    elsif datatype == 'email'
      record1.field_data[field_api_name] = 'rubysdk+automation@zoho.com'
    elsif datatype == 'fileupload'
    #      record1.field_data[field_api_name]=[{"file_id"=>fileid}]
    elsif datatype == 'website'
      record1.field_data[field_api_name] = 'www.zoho.com'
    elsif datatype == 'integer' || datatype == 'bigint'
      record1.field_data[field_api_name] = 123
    elsif datatype == 'phone'
      record1.field_data[field_api_name] = '123'
    elsif datatype == 'currency'
      record1.field_data[field_api_name] = 123
    elsif datatype == 'boolean'
      record1.field_data[field_api_name] = true
    elsif datatype == 'date'
      record1.field_data[field_api_name] = '2019-07-11'
    elsif datatype == 'double'
      record1.field_data[field_api_name] = 2.1
    elsif datatype == 'textarea'
      record1.field_data[field_api_name] = 'ruby_automation_at_work'
    elsif datatype == 'datetime'
      record1.field_data[field_api_name] = '2019-06-15T15:53:00+05:30'
    end
  end
  create_record_response = record1.create
  if create_record_response.code == 'SUCCESS'
    create_record_id = create_record_response.details['id']
    created_record[creatable_module_api_name] = [ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(create_record_id).data]
  end
end
creatable_module_api_names.each do |creatable_module_api_name|
  if creatable_module_api_name != 'Calls'
    record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
    upload_attachment_response[creatable_module_api_name] = record1.upload_attachment(file_path)
  end
end
creatable_module_api_names.each do |creatable_module_api_name|
  if creatable_module_api_name != 'Calls'
    record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
    upload_attachment_link_response[creatable_module_api_name] = record1.upload_link_as_attachment(file_link)
  end
end
creatable_module_api_names.each do |creatable_module_api_name|
  if creatable_module_api_name != 'Calls'
    record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
    get_attachment_response[creatable_module_api_name] = record1.get_attachments.data
  end
end
creatable_module_api_names.each do |creatable_module_api_name|
  if creatable_module_api_name != 'Calls'
    record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
    download_attachment_response[creatable_module_api_name] = record1.download_attachment(upload_attachment_response[creatable_module_api_name].details['id'])
  end
end
creatable_module_api_names.each do |creatable_module_api_name|
  next unless creatable_module_api_name != 'Calls'

  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  delete_attachment_attachment_response[creatable_module_api_name] = []
  delete_attachment_attachment_response[creatable_module_api_name].push(record1.delete_attachment(upload_attachment_response[creatable_module_api_name].details['id']))
  delete_attachment_attachment_response[creatable_module_api_name].push(record1.delete_attachment(upload_attachment_link_response[creatable_module_api_name].details['id']))
end
creatable_module_api_names.each do |creatable_module_api_name|
  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  note = ZCRMSDK::Operations::ZCRMNote.get_instance(record1, nil)
  note.title = 'ruby_automation_note_create'
  note.content = 'ruby_automation_note_create'
  add_note_response[creatable_module_api_name] = record1.add_note(note)
  note_ids[creatable_module_api_name] = add_note_response[creatable_module_api_name].details['id']
  next unless creatable_module_api_names[0] == creatable_module_api_name

  note.id = note_ids[creatable_module_api_name]
  note_upload_attachment_res = note.upload_attachment(file_path)
  note_get_attachment = note.get_attachments.data
  note_download_attachment_res = note.download_attachment(note_upload_attachment_res.details['id'])
  note_delete_attachment_res.push(note.delete_attachment(note_upload_attachment_res.details['id']))
end

creatable_module_api_names.each do |creatable_module_api_name|
  if add_note_response[creatable_module_api_name].code == 'SUCCESS'
    record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
    added_note[creatable_module_api_name] = record1.get_notes.data
  end
end

creatable_module_api_names.each do |creatable_module_api_name|
  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  note = ZCRMSDK::Operations::ZCRMNote.get_instance(record1, note_ids[creatable_module_api_name])
  note.title = 'ruby_automation_note_update'
  note.content = 'ruby_automation_note_update'
  update_note_response[creatable_module_api_name] = record1.update_note(note)
end

creatable_module_api_names.each do |creatable_module_api_name|
  if update_note_response[creatable_module_api_name].code == 'SUCCESS'
    record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
    updated_note[creatable_module_api_name] = record1.get_notes.data
  end
end

creatable_module_api_names.each do |creatable_module_api_name|
  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  note = ZCRMSDK::Operations::ZCRMNote.get_instance(record1, note_ids[creatable_module_api_name])
  deleted_note[creatable_module_api_name] = record1.delete_note(note)
end
creatable_module_api_names.each do |creatable_module_api_name|
  next unless %w[Leads Vendors Products Accounts Contacts].include?(creatable_module_api_name)

  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  upload_photo_response[creatable_module_api_name] = record1.upload_photo(file_path)
  download_photo_response[creatable_module_api_name] = record1.download_photo
  delete_photo_response[creatable_module_api_name] = record1.delete_photo
end
creatable_module_api_names.each do |creatable_module_api_name|
  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  tagnames = %w[ruby_automation_tag_1 ruby_automation_tag_2]
  add_tags_record[creatable_module_api_name] = record1.add_tags(tagnames)
  remove_tags_record[creatable_module_api_name] = record1.remove_tags(tagnames)
  tags = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_tags.data
  tags.each(&:delete)
end
creatable_module_api_names.each do |creatable_module_api_name|
  next unless %w[Leads Price_Books Accounts Contacts Deals].include?(creatable_module_api_name)

  add_relation_response[creatable_module_api_name] = []
  get_relatedrecords[creatable_module_api_name] = []
  remove_relation_response[creatable_module_api_name] = []
  if creatable_module_api_names.include?('Campaigns') && %w[Leads Contacts].include?(creatable_module_api_name)
    parent_record = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
    junction_record = ZCRMSDK::Operations::ZCRMJunctionRecord.get_instance('Campaigns', created_record['Campaigns'][0].entity_id)
    if creatable_module_api_name == 'Contacts'
      junction_record.related_data['Contact_Role'] = contact_role_id
    end
    add_relation_response[creatable_module_api_name].push(parent_record.add_relation(junction_record))
    get_relatedrecords[creatable_module_api_name].push(parent_record.get_relatedlist_records('Campaigns').data)
    remove_relation_response[creatable_module_api_name].push(parent_record.remove_relation(junction_record))
  end
  next unless creatable_module_api_names.include?('Products')

  parent_record = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  junction_record = ZCRMSDK::Operations::ZCRMJunctionRecord.get_instance('Products', created_record['Products'][0].entity_id)
  if creatable_module_api_name == 'Price_Books'
    junction_record.related_data['list_price'] = 123.0
  end
  add_relation_response[creatable_module_api_name].push(parent_record.add_relation(junction_record))
  get_relatedrecords[creatable_module_api_name].push(parent_record.get_relatedlist_records('Products').data)
  remove_relation_response[creatable_module_api_name].push(parent_record.remove_relation(junction_record))
end
creatable_module_api_names.each do |creatable_module_api_name| # convert a lead
  next unless creatable_module_api_name == 'Leads'

  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, nil)
  moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
    datatype = field_details['data_type']
    length = field_details['length']
    fieldlabel = field_details['field_label']
    lookup_ins = field_details['lookup']
    if datatype == 'ownerlookup'
      record1.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user_id)
    elsif fieldlabel == 'Pricing Details'
      price_ins = ZCRMSDK::Operations::ZCRMPriceBookPricing.get_instance
      price_ins.from_range = 1
      price_ins.to_range = 100
      price_ins.discount = 5
      record1.price_details = [price_ins]
    elsif fieldlabel == 'Product Details'
      line_item_instance = ZCRMSDK::Operations::ZCRMInventoryLineItem.get_instance(ZCRMSDK::Operations::ZCRMRecord.get_instance('Products', created_record['Products'][0].entity_id))
      line_item_instance.description = 'ruby_automation_lineitem'
      line_item_instance.list_price = 123
      line_item_instance.quantity = 10
      line_item_instance.discount = 10
      record1.line_items.push(line_item_instance)
    elsif fieldlabel == 'Participants'
      record1.field_data[field_api_name] = [{ 'type' => 'user', 'participant' => current_user_id }]
    elsif fieldlabel == 'Call Duration'
      record1.field_data[field_api_name] = '10:00'
    elsif datatype == 'lookup'
      if created_record[lookup_ins.module_apiname]
        record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][0].entity_id
      end
      if lookup_ins.module_apiname == 'se_module'
        record1.field_data['$se_module'] = 'Accounts'
        record1.field_data[field_api_name] = { 'id' => created_record['Accounts'][0].entity_id }
      end
    elsif datatype == 'text'
      word = '1234567890'
      word = word[0, length - 1]
      record1.field_data[field_api_name] = word
    elsif datatype == 'RRULE'
      if creatable_module_api_name == 'Events'
        record1.field_data[field_api_name] = { 'RRULE' => 'FREQ=YEARLY;INTERVAL=99;DTSTART=2017-08-29;UNTIL=2017-08-29' }
      else
        record1.field_data[field_api_name] = { 'RRULE' => 'FREQ=DAILY;INTERVAL=99;DTSTART=2017-08-29;UNTIL=2017-08-29' }
      end
    elsif datatype == 'event_reminder'
      record1.field_data[field_api_name] = '0'
    elsif datatype == 'ALARM'
      record1.field_data[field_api_name] = { 'ALARM' => 'FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30' }
    elsif datatype == 'picklist'
      if field_details['picklist'].length > 1
        record1.field_data[field_api_name] = field_details['picklist'][1].display_value
      elsif
        record1.field_data[field_api_name] = field_details['picklist'][0].display_value
      end
    elsif datatype == 'multiselectpicklist'
      record1.field_data[field_api_name] = [field_details['picklist'][0].display_value]
    elsif datatype == 'email'
      record1.field_data[field_api_name] = 'rubysdk+automation@zoho.com'
    elsif datatype == 'fileupload'
    #      record1.field_data[field_api_name]=[{"file_id"=>fileid}]
    elsif datatype == 'website'
      record1.field_data[field_api_name] = 'www.zoho.com'
    elsif datatype == 'integer' || datatype == 'bigint'
      record1.field_data[field_api_name] = 123
    elsif datatype == 'phone'
      record1.field_data[field_api_name] = '123'
    elsif datatype == 'currency'
      record1.field_data[field_api_name] = 123
    elsif datatype == 'boolean'
      record1.field_data[field_api_name] = true
    elsif datatype == 'date'
      record1.field_data[field_api_name] = '2019-07-11'
    elsif datatype == 'double'
      record1.field_data[field_api_name] = 2.1
    elsif datatype == 'textarea'
      record1.field_data[field_api_name] = 'ruby_automation_at_work'
    elsif datatype == 'datetime'
      record1.field_data[field_api_name] = '2019-06-15T15:53:00+05:30'
    end
  end
  create_record_response = record1.create
  if create_record_response.code == 'SUCCESS'
    record1.entity_id = create_record_response.details['id']
  end
  deal = ZCRMSDK::Operations::ZCRMRecord.get_instance('Deals', nil)
  deal.field_data = { 'Deal_Name' => 'test3', 'stage' => 'Qualification', 'Closing_Date' => '2016-03-30' }
  details = Array('overwrite' => TRUE, 'notify_lead_owner' => TRUE, 'notify_new_entity_owner' => TRUE, 'Accounts' => created_record['Accounts'][0].entity_id, 'Contacts' => created_record['Contacts'][0].entity_id, 'assign_to' => current_user_id)
  convert_lead_response = record1.convert(deal, details)
  deal.entity_id = convert_lead_response['Deals']
  deal.delete
end
creatable_module_api_names.each do |creatable_module_api_name|
  next unless creatable_module_api_names[0] == creatable_module_api_name

  tags = []
  tag1 = ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag_test1')
  tags.push(tag1)
  tag2 = ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag_test2')
  tags.push(tag2)
  tag_creation_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).create_tags(tags)
  tags_ins = tag_creation_response.data
  tags_ins[0].name = 'ruby_update_tag_test'
  tags_ins[0].module_apiname = creatable_module_api_name
  tag_update_response = tags_ins[0].update
  tag_merge_response = tags_ins[0].merge(tags_ins[1])
  tag_delete_response = tags_ins[0].delete
end
creatable_module_api_names.reverse!
creatable_module_api_names.each do |creatable_module_api_name| # delete() and delete_records()
  record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
  deleted_record_response[creatable_module_api_name] = record1.delete
end

RSpec.describe 'meta_data' do
  it 'note_upload_attachment' do
    expect(note_upload_attachment_res.code).to eql 'SUCCESS'
  end
  it 'note_download_attachment' do
    expect(note_download_attachment_res.status_code).to eql 200
    expect(note_download_attachment_res.filename).to eql 'resource.jpg'
  end
  it 'note_get_attachments' do
    note_get_attachment.each do |zcrmattachment_ins|
      expect(zcrmattachment_ins).to be_an_instance_of(ZCRMSDK::Operations::ZCRMAttachment)
      expect(zcrmattachment_ins.id).to be_a_kind_of(String)
      expect(zcrmattachment_ins.file_name).to eql('resource.jpg')
      expect(zcrmattachment_ins.type).to eql('Attachment')
      expect(zcrmattachment_ins.file_id).to be_a_kind_of(String)
      owner = zcrmattachment_ins.owner
      expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(owner.id).to eql(current_user_id)
      expect(owner.name).to eql(current_user_name)
      created_by = zcrmattachment_ins.created_by
      expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
      expect(created_by.id).to eql(current_user_id)
      expect(created_by.name).to eql(current_user_name)
      modified_by = zcrmattachment_ins.modified_by
      unless modified_by.nil?
        expect(modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(modified_by.id).to eql(current_user_id)
        expect(modified_by.name).to eql(current_user_name)
        expect(zcrmattachment_ins.modified_time).to be_a_kind_of(String)
      end
      expect(zcrmattachment_ins.created_time).to be_a_kind_of(String)
      expect(zcrmattachment_ins.parent_module).to eql('Notes')
      expect(zcrmattachment_ins.parent_id).to be_a_kind_of(String)
      expect(zcrmattachment_ins.parent_name).to be_a_kind_of(String)
      expect(zcrmattachment_ins.size).to be_a_kind_of(String)
      expect(zcrmattachment_ins.is_editable).to be(true).or be(false)
    end
  end
  it 'note_delete_attachment' do
    expect(note_delete_attachment_res[0].status_code).to eql 200
    expect(note_delete_attachment_res[0].code).to eql 'SUCCESS'
    expect(note_delete_attachment_res[0].message).to eql 'record deleted'
  end
  it 'upload_attachment' do
    creatable_module_api_names.each do |creatable_module_api_name|
      if creatable_module_api_name != 'Calls'
        expect(upload_attachment_response[creatable_module_api_name].code).to eql 'SUCCESS' 
      end
    end
  end
  it 'upload_attachment_as_link' do
    creatable_module_api_names.each do |creatable_module_api_name|
      if creatable_module_api_name != 'Calls'
        expect(upload_attachment_link_response[creatable_module_api_name].code).to eql 'SUCCESS'
      end
    end
  end
  it 'download_attachment' do
    creatable_module_api_names.each do |creatable_module_api_name|
      if creatable_module_api_name != 'Calls'
        expect(download_attachment_response[creatable_module_api_name].status_code).to eql 200
        expect(download_attachment_response[creatable_module_api_name].filename).to eql 'resource.jpg'
      end
    end
  end
  it 'delete_attachment' do
    creatable_module_api_names.each do |creatable_module_api_name|
      next unless creatable_module_api_name != 'Calls'

      expect(delete_attachment_attachment_response[creatable_module_api_name][0].status_code).to eql 200
      expect(delete_attachment_attachment_response[creatable_module_api_name][0].code).to eql 'SUCCESS'
      expect(delete_attachment_attachment_response[creatable_module_api_name][0].message).to eql 'record deleted'
      expect(delete_attachment_attachment_response[creatable_module_api_name][1].status_code).to eql 200
      expect(delete_attachment_attachment_response[creatable_module_api_name][1].code).to eql 'SUCCESS'
      expect(delete_attachment_attachment_response[creatable_module_api_name][1].message).to eql 'record deleted'
    end
  end
  it 'get_attachments' do
    creatable_module_api_names.each do |creatable_module_api_name|
      next unless creatable_module_api_name != 'Calls'

      get_attachment_response[creatable_module_api_name].each do |zcrmattachment_ins|
        expect(zcrmattachment_ins).to be_an_instance_of(ZCRMSDK::Operations::ZCRMAttachment)
        expect(zcrmattachment_ins.id).to be_a_kind_of(String)
        expect(zcrmattachment_ins.file_name).to eql('resource.jpg').or eql('android_logo_low_quality.jpg')
        expect(zcrmattachment_ins.type).to eql('Link URL').or eql('Attachment')
        if zcrmattachment_ins.type == 'Link URL'
          expect(zcrmattachment_ins.link_url).to eql(file_link)
        else
          expect(zcrmattachment_ins.file_id).to be_a_kind_of(String)
        end
        owner = zcrmattachment_ins.owner
        expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(owner.id).to eql(current_user_id)
        expect(owner.name).to eql(current_user_name)
        created_by = zcrmattachment_ins.created_by
        expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(created_by.id).to eql(current_user_id)
        expect(created_by.name).to eql(current_user_name)
        modified_by = zcrmattachment_ins.modified_by
        unless modified_by.nil?
          expect(modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
          expect(modified_by.id).to eql(current_user_id)
          expect(modified_by.name).to eql(current_user_name)
          expect(zcrmattachment_ins.modified_time).to be_a_kind_of(String)
        end
        expect(zcrmattachment_ins.created_time).to be_a_kind_of(String)
        expect(zcrmattachment_ins.parent_module).to eql(creatable_module_api_name)
        expect(zcrmattachment_ins.parent_id).to be_a_kind_of(String)
        expect(zcrmattachment_ins.parent_name).to be_a_kind_of(String)
        expect(zcrmattachment_ins.size).to be_a_kind_of(String)
        expect(zcrmattachment_ins.is_editable).to be(true).or be(false)
      end
    end
  end
  it 'add_note' do
    creatable_module_api_names.each do |creatable_module_api_name|
      added_note[creatable_module_api_name].each do |zcrmnote_ins|
        expect(zcrmnote_ins.id).to be_a_kind_of(String)
        expect(zcrmnote_ins.title).to eql('ruby_automation_note_create')
        expect(zcrmnote_ins.content).to eql('ruby_automation_note_create')
        owner = zcrmnote_ins.owner
        expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(owner.id).to eql(current_user_id)
        expect(owner.name).to eql(current_user_name)
        created_by = zcrmnote_ins.created_by
        expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(created_by.id).to eql(current_user_id)
        expect(created_by.name).to eql(current_user_name)
        expect(zcrmnote_ins.modified_time).to be_a_kind_of(String)
        expect(zcrmnote_ins.created_time).to be_a_kind_of(String)
        expect(zcrmnote_ins.is_voice_note).to be(false)
        if creatable_module_api_name == 'Accounts'
          expect(zcrmnote_ins.parent_module).to eql(creatable_module_api_name).or eql('Calls').or eql('Events').or eql('Tasks').or eql('Deals').or eql('Contacts')
        end
        if creatable_module_api_name == 'Contacts'
          expect(zcrmnote_ins.parent_module).to eql(creatable_module_api_name).or eql('Calls').or eql('Events').or eql('Tasks').or eql('Deals')
        end
        if creatable_module_api_name == 'Tasks' || creatable_module_api_name == 'Calls' || creatable_module_api_name == 'Events'
          expect(zcrmnote_ins.parent_module).to eql(creatable_module_api_name).or eql('Contacts')
        end
        expect(zcrmnote_ins.parent_id).to be_a_kind_of(String)
        expect(zcrmnote_ins.parent_name).to be_a_kind_of(String)
        expect(zcrmnote_ins.is_editable).to be(true)
      end
    end
  end
  it 'update_note' do
    creatable_module_api_names.each do |creatable_module_api_name|
      updated_note[creatable_module_api_name].each do |zcrmnote_ins|
        expect(zcrmnote_ins.id).to be_a_kind_of(String)
        expect(zcrmnote_ins.title).to eql('ruby_automation_note_update')
        expect(zcrmnote_ins.content).to eql('ruby_automation_note_update')
        owner = zcrmnote_ins.owner
        expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(owner.id).to eql(current_user_id)
        expect(owner.name).to eql(current_user_name)
        created_by = zcrmnote_ins.created_by
        expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(created_by.id).to eql(current_user_id)
        expect(created_by.name).to eql(current_user_name)
        modified_by = zcrmnote_ins.modified_by
        expect(modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
        expect(modified_by.id).to eql(current_user_id)
        expect(modified_by.name).to eql(current_user_name)
        expect(zcrmnote_ins.created_time).to be_a_kind_of(String)
        expect(zcrmnote_ins.is_voice_note).to be(false)
        if creatable_module_api_name == 'Accounts'
          expect(zcrmnote_ins.parent_module).to eql(creatable_module_api_name).or eql('Calls').or eql('Events').or eql('Tasks').or eql('Deals').or eql('Contacts')
        end
        if creatable_module_api_name == 'Contacts'
          expect(zcrmnote_ins.parent_module).to eql(creatable_module_api_name).or eql('Calls').or eql('Events').or eql('Tasks').or eql('Deals')
        end
        if creatable_module_api_name == 'Tasks' || creatable_module_api_name == 'Calls' || creatable_module_api_name == 'Events'
          expect(zcrmnote_ins.parent_module).to eql(creatable_module_api_name).or eql('Contacts')
        end
        expect(zcrmnote_ins.parent_id).to be_a_kind_of(String)
        expect(zcrmnote_ins.parent_name).to be_a_kind_of(String)
        expect(zcrmnote_ins.is_editable).to be(true)
      end
    end
  end
  it 'delete_note' do
    creatable_module_api_names.each do |creatable_module_api_name|
      expect(deleted_note[creatable_module_api_name].code).to eql('SUCCESS')
      expect(deleted_note[creatable_module_api_name].message).to eql('record deleted')
      expect(deleted_note[creatable_module_api_name].details['id']).to eql(note_ids[creatable_module_api_name])
      expect(deleted_note[creatable_module_api_name].status).to eql('success')
    end
  end
  it 'upload_photo' do
    creatable_module_api_names.each do |creatable_module_api_name|
      next unless %w[Leads Vendors Products Accounts Contacts].include?(creatable_module_api_name)

      expect(upload_photo_response[creatable_module_api_name].code).to eql('SUCCESS')
      expect(upload_photo_response[creatable_module_api_name].message).to eql('photo uploaded successfully')
      expect(upload_photo_response[creatable_module_api_name].status).to eql('success')
    end
  end
  it 'download_photo' do
    creatable_module_api_names.each do |creatable_module_api_name|
      if %w[Leads Vendors Products Accounts Contacts].include?(creatable_module_api_name)
        expect(download_photo_response[creatable_module_api_name].status_code).to eql(200)
      end
    end
  end
  it 'delete_photo' do
    creatable_module_api_names.each do |creatable_module_api_name|
      next unless %w[Leads Vendors Products Accounts Contacts].include?(creatable_module_api_name)

      expect(delete_photo_response[creatable_module_api_name].code).to eql('SUCCESS')
      expect(delete_photo_response[creatable_module_api_name].message).to eql('Photo deleted')
      expect(delete_photo_response[creatable_module_api_name].status).to eql('success')
    end
  end
  it 'add_tags_record' do
    creatable_module_api_names.each do |creatable_module_api_name|
      expect(add_tags_record[creatable_module_api_name].status).to eql('success')
      expect(add_tags_record[creatable_module_api_name].message).to eql('tags updated successfully')
      add_tags_record[creatable_module_api_name].details['tags'].each do |tag_name|
        expect(tag_name).to eql('ruby_automation_tag_1').or eql('ruby_automation_tag_2')
      end
    end
  end
  it 'remove_tags_record' do
    creatable_module_api_names.each do |creatable_module_api_name|
      expect(remove_tags_record[creatable_module_api_name].status).to eql('success')
      expect(add_tags_record[creatable_module_api_name].message).to eql('tags updated successfully')
    end
  end
  it 'converted_lead' do
    expect(convert_lead_response['Accounts']).to eql(created_record['Accounts'][0].entity_id)
    expect(convert_lead_response['Contacts']).to eql(created_record['Contacts'][0].entity_id)
    expect(convert_lead_response['Deals']).to be_a_kind_of(String)
  end
  it 'add_relation' do
    creatable_module_api_names.each do |creatable_module_api_name|
      next unless %w[Leads Accounts Contacts Deals Price_Books].include?(creatable_module_api_name)

      add_relation_response[creatable_module_api_name].each do |res|
        expect(res.code).to eql('SUCCESS')
        expect(res.status).to eql('success')
        expect(res.message).to eql('relation added')
      end
    end
  end
  it 'get_related_records' do
    creatable_module_api_names.each do |creatable_module_api_name|
      next unless %w[Leads Accounts Contacts Deals Price_Books].include?(creatable_module_api_name)

      get_relatedrecords[creatable_module_api_name].each do |records|
        records.each do |record|
          expect(record.module_api_name).to be_a_kind_of(String)
          expect(record.entity_id).to eql(created_record[record.module_api_name][0].entity_id)
        end
      end
    end
  end
  it 'remove_relation' do
    creatable_module_api_names.each do |creatable_module_api_name|
      next unless %w[Leads Accounts Contacts Deals Price_Books].include?(creatable_module_api_name)

      remove_relation_response[creatable_module_api_name].each do |res|
        expect(res.code).to eql('SUCCESS')
        expect(res.status).to eql('success')
        expect(res.message).to eql('relation removed')
      end
    end
  end

  it 'tag_update' do
    expect(tag_update_response.status).to eql('success')
    expect(tag_update_response.code).to eql('SUCCESS')
    expect(tag_update_response.message).to eql('tags updated successfully')
  end
  it 'tag_merge' do
    expect(tag_merge_response.status).to eql('success')
    expect(tag_merge_response.code).to eql('SUCCESS')
    expect(tag_merge_response.message).to eql('tags merged successfully')
  end
  it 'tag_delete' do
    expect(tag_delete_response.status).to eql('success')
    expect(tag_delete_response.code).to eql('SUCCESS')
    expect(tag_delete_response.message).to eql('tags deleted successfully')
  end
end
