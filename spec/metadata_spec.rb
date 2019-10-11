# # frozen_string_literal: true

# require 'mysql2'
# require 'json'
# record_count = 3
# iterator = 0
# activity_module = %w[Tasks Events Calls]
# sort_order_module = %w[Leads Vendors Price_Books Products Campaigns Solutions Accounts Contacts Deals Quotes Sales_Orders Purchase_Orders Invoices Cases Tasks Events Calls]
# config_details = { 'client_id' => 'client_id', 'client_secret' => 'client_secret', 'redirect_uri' => 'www.zoho.com', 'api_base_url' => 'https://www.zohoapis.com', 'api_version' => 'v2', 'sandbox' => 'false', 'application_log_file_path' => nil, 'current_user_email' => 'current_user_email', 'db_port' => '3306' }
# ZCRMSDK::RestClient::ZCRMRestClient.init(config_details)
# rest = ZCRMSDK::RestClient::ZCRMRestClient.get_instance
# current_user = rest.get_organization_instance.get_current_user.data[0]
# current_user_id = current_user.id
# current_user_name = current_user.full_name
# # con = Mysql2::Client.new(host: config_details['db_address'], username: config_details['db_username'], password: config_details['db_password'], database: 'zohooauth', port: config_details['db_port'])
# # query = "select * from oauthtokens where useridentifier='" + config_details['current_userEmail'] + "'"
# # rs = con.query(query)
# # oauth_tokens = nil
# # accesstoken=nil
# # rs.each do |row|
# #  accesstoken = row['accesstoken']
# #  con.close
# # end
# # url = URI("https://crm.zoho.com/crm/v2/files")
# # file_path="/Users/path/Desktop/parser"
# # form_data = [['file', File.open(file_path)]]
# # http = Net::HTTP.new(url.host, url.port)
# # req = Net::HTTP::Post.new(url.request_uri)
# # req.set_form form_data, 'multipart/form-data'
# # accesstoken = "Zoho-oauthtoken " + accesstoken
# # req.add_field("Authorization",accesstoken)
# # http.use_ssl = true
# # response = http.request(req)
# # fileid = JSON.parse(response.body)['data'][0]["details"]["id"]
# modules = []
# modules = rest.get_all_modules.data
# module_api_names = []
# creatable_module_api_names = []
# created_record = {}
# created_record_ids = {}
# updated_record = {}
# created_records = {}
# updated_records = {}
# upserted_records = {}
# mass_updated_records = {}
# upsert_records_instances = {}
# deleted_record_response = {}
# deleted_records_response = {}
# search_records_response = {}
# search_records_response_phone = {}
# search_records_response_email = {}
# search_records_response_criteria = {}
# get_records_response = {}
# create_tags_flag = 0
# update_tags_flag = 0
# created_tags = {}
# updated_tags = {}
# deleted_tags = {}
# record_tag_count = {}
# tag_ids = {}
# phonemodules = {}
# emailmodules = {}
# records_tag_added = {}
# records_tag_removed = {}
# modules_all = []
# all_deleted_records = {}
# recyclebin_records = {}
# permanently_deleted_records = {}
# modulevsfields = {} # moduleapiname vs all fields data
# moduleapinamevsfieldsidvsdata = {} # moduleapiname vs field id vsindividual fields data
# moduleapinamevsfieldsarrayvsfielddetail = {}
# modulevslayouts = {} # moduleapiname vs all layouts data
# moduleapinamevslayoutsidvsdata = {} # moduleapiname vs layout id vsindividual layout data
# modulevscustomviews = {} # moduleapiname vs all customviews data
# moduleapinamevscustomviewsidvsdata = {} # moduleapiname vs customview id vsindividual customview data
# modulevsrelatedlists = {} # moduleapiname vs all relatedlists data
# moduleapinamevsrelatedlistsidvsdata = {} # moduleapiname vs relatedlist id vsindividual relatedlist data
# modules.each do |module_instance|
#   if module_instance.is_api_supported
#     module_api_names.push(module_instance.api_name)
#         # modules_all.push(rest.get_module(module_instance.api_name).data)
#   end
#   if module_instance.is_quick_create
#     creatable_module_api_names.push(module_instance.api_name)
#   end
# end
# sort_order_module.each do |module_apiname|
#   if creatable_module_api_names.include? module_apiname
#     creatable_module_api_names -= [module_apiname]
#     creatable_module_api_names.push(module_apiname)
#   end
# end
# # module_api_names=["Leads", "Contacts","Price_Books", "Accounts", "Deals", "Activities", "Products", "Quotes", "Sales_Orders", "Purchase_Orders", "Invoices", "Campaigns", "Vendors", "Price_Books", "Cases", "Solutions", "Visits", "Tasks", "Events", "Notes", "Attachments", "Calls", "Actions_Performed", "Approvals"]
# # module_api_names=["Leads","Vendors","Price_Books","Products","Campaigns","Solutions","Accounts","Contacts","Deals","Quotes","Sales_Orders","Purchase_Orders","Invoices","Cases","Tasks", "Events","Calls"]
# # module_api_names=["Leads"]
# module_api_names.each do |module_api_name| # fields
#   next unless module_api_name != 'Approvals'

#   module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
#   modulevsfields[module_api_name] = module_instance.get_all_fields.data
#   fieldsidsvsdata = {}
#   modulevsfields[module_api_name].each do |field|
#     fieldsidsvsdata[field.id] = module_instance.get_field(field.id).data
#   end
#   moduleapinamevsfieldsidvsdata[module_api_name] = fieldsidsvsdata
# end
# module_api_names.each do |module_api_name| # layout
#   module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
#   next unless module_api_name != 'Approvals'

#   modulevslayouts[module_api_name] = module_instance.get_all_layouts.data
#   layoutsidsvsdata = {}
#   modulevslayouts[module_api_name].each do |layout|
#     layoutsidsvsdata[layout.id] = module_instance.get_layout(layout.id).data
#   end
#   moduleapinamevslayoutsidvsdata[module_api_name] = layoutsidsvsdata
# end
# module_api_names.each do |module_api_name| # custom view
#   module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
#   next unless module_api_name != 'Approvals' && module_api_name != 'Notes' && module_api_name != 'Actions_Performed' && module_api_name != 'Attachments'

#   modulevscustomviews[module_api_name] = module_instance.get_all_customviews.data
  
#   customviewsidsvsdata = {}
#   modulevscustomviews[module_api_name].each do |customview|
#     customviewsidsvsdata[customview.id] = module_instance.get_customview(customview.id).data
#   end
#   moduleapinamevscustomviewsidvsdata[module_api_name] = customviewsidsvsdata
# end
# module_api_names.each do |module_api_name| # related list
#   module_instance = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name)
#   next unless module_api_name != 'Activities' && module_api_name != 'Notes' && module_api_name != 'Attachments' && module_api_name != 'Actions_Performed' && module_api_name != 'Approvals'

#   modulevsrelatedlists[module_api_name] = module_instance.get_all_relatedlists.data
#   relatedlistsidsvsdata = {}
#   modulevsrelatedlists[module_api_name].each do |relatedlist|
#     relatedlistsidsvsdata[relatedlist.id] = module_instance.get_relatedlist(relatedlist.id).data
#   end
#   moduleapinamevsrelatedlistsidvsdata[module_api_name] = relatedlistsidsvsdata
# end
# module_api_names.each do |module_api_name| # setting module vs fields
#   next unless module_api_name != 'Approvals'

#   fieldsarray = {}
#   modulevsfields[module_api_name].each do |field|
#     fielddetails = {}
#     next unless (field.field_layout_permissions.include?('CREATE') || field.api_name == 'Tag') && field.api_name != 'Exchange_Rate'

#     fielddetails = {}
#     if field.field_layout_permissions.include?('EDIT')
#       fielddetails['editable'] = true
#     elsif
#       fielddetails['editable'] = false
#     end
#     fielddetails['data_type'] = field.data_type
#     fielddetails['decimal_place'] = field.decimal_place
#     fielddetails['field_label'] = field.field_label
#     fielddetails['length'] = field.length unless field.length.nil?
#     if field.data_type == 'lookup'
#       fielddetails['lookup'] = field.lookup_field
#     elsif field.data_type == 'multiselectlookup'
#       fielddetails['multiselectlookup'] = field.multiselectlookup
#     elsif field.data_type == 'picklist' || field.data_type == 'multiselectpicklist'
#       fielddetails['picklist'] = field.picklist_values
#     elsif field.data_type == 'currency'
#       fielddetails['precision'] = field.precision
#       fielddetails['rounding_option'] = field.rounding_option
#     end
#     fieldsarray[field.api_name] = fielddetails
#   end
#   moduleapinamevsfieldsarrayvsfielddetail[module_api_name] = fieldsarray
# end
# creatable_module_api_names=["Leads"]
# creatable_module_api_names.each do |creatable_module_api_name| # create tag and gettags
# begin
#   tags = []
#   tag1 = ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag1')
#   tags.push(tag1)
#   tag2 = ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag2')
#   tags.push(tag2)
#   tag3 = ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag3')
#   tags.push(tag3)
#   create_tags_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).create_tags(tags).bulk_entity_response
# rescue ZCRMSDK::Utility::ZCRMException => e
#     print e.status_code
#     print e.error_message
#     print e.exception_code
#     print e.error_details
#     print e.error_content
# end
#   tag_ids[creatable_module_api_name] = []
#   create_tags_response.each do |res|
#     if res.code == 'SUCCESS'
#       tag_ids[creatable_module_api_name].push(res.details['id'])
#     else
#       create_tags_flag = 1
#     end
#   end
#   created_tags[creatable_module_api_name] = []
#   get_tags_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_tags.data
#   get_tags_response.each do |tag_ins|
#     if tag_ids[creatable_module_api_name].include?(tag_ins.id)
#       created_tags[creatable_module_api_name].push(tag_ins)
#     end
#   end
# end
# org_ins = rest.get_organization_instance
# org_tax_ins= ZCRMSDK::Operations::ZCRMOrgTax.get_instance
# org_tax_ins.name = 'record_tax'
# org_tax_ins.value = 10
# org_tax_id=[]
# org_tax_responses = org_ins.create_organization_taxes([org_tax_ins]).bulk_entity_response
# org_tax_responses.each do |orgtax_response|
#   org_tax_id.push(orgtax_response.details['id'])
# end
# creatable_module_api_names.each do |creatable_module_api_name| # create()
#   iterator = 0
#   while iterator < record_count
#     record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, nil)
#     moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#       datatype = field_details['data_type']
#       length = field_details['length']
#       fieldlabel = field_details['field_label']
#       lookup_ins = field_details['lookup']
#       if datatype == 'ownerlookup'
#         record1.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user_id)
#       elsif fieldlabel == 'Pricing Details'
#         price_ins = ZCRMSDK::Operations::ZCRMPriceBookPricing.get_instance
#         price_ins.from_range = 1
#         price_ins.to_range = 100
#         price_ins.discount = 5
#         record1.price_details = [price_ins]
#       elsif fieldlabel == 'Product Details'
#         line_item_instance = ZCRMSDK::Operations::ZCRMInventoryLineItem.get_instance(ZCRMSDK::Operations::ZCRMRecord.get_instance('Products', created_record['Products'][0].entity_id))
#         line_item_instance.description = 'ruby_automation_lineitem'
#         line_item_instance.list_price = 123
#         line_item_instance.quantity = 10
#         line_item_instance.discount = 10
#         record1.line_items.push(line_item_instance)
#       elsif fieldlabel == 'Participants'
#         record1.field_data[field_api_name] = [{ 'type' => 'user', 'participant' => current_user_id }]
#       elsif fieldlabel == 'Call Duration'
#         record1.field_data[field_api_name] = '10:00'
#       elsif fieldlabel == 'Tag'
#         record1.tag_list.push(ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag1'))
#       elsif datatype == 'lookup'
#         if created_record[lookup_ins.module_apiname]
#           record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][0].entity_id
#         end
#         if lookup_ins.module_apiname == 'se_module'
#           record1.field_data['$se_module'] = 'Accounts'
#           record1.field_data[field_api_name] = { 'id' => created_record['Accounts'][0].entity_id }
#         end
#       elsif datatype == 'text'
#         word = iterator.to_s + '1234567890'
#         word = word[0, length - 1]
#         record1.field_data[field_api_name] = word
#       elsif datatype == 'RRULE'
#         if creatable_module_api_name == 'Events'
#           record1.field_data[field_api_name] = { 'RRULE' => 'FREQ=YEARLY;INTERVAL=99;DTSTART=2017-08-29;UNTIL=2017-08-29' }
#         else
#           record1.field_data[field_api_name] = { 'RRULE' => 'FREQ=DAILY;INTERVAL=99;DTSTART=2017-08-29;UNTIL=2017-08-29' }
#         end
#       elsif datatype == 'event_reminder'
#         record1.field_data[field_api_name] = '0'
#       elsif datatype == 'ALARM'
#         record1.field_data[field_api_name] = { 'ALARM' => 'FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30' }
#       elsif datatype == 'picklist'
#         if field_details['picklist'].length > 1
#           record1.field_data[field_api_name] = field_details['picklist'][1].display_value
#         elsif
#           record1.field_data[field_api_name] = field_details['picklist'][0].display_value
#         end
#       elsif datatype == 'multiselectpicklist'
#         if fieldlabel == 'Tax'
#           record1.field_data[field_api_name] = ['record_tax']
#         else
#           record1.field_data[field_api_name] = [field_details['picklist'][0].display_value]
#         end
#       elsif datatype == 'email'
#         emailmodules[creatable_module_api_name] = 1
#         record1.field_data[field_api_name] = iterator.to_s + 'rubysdk+automation@zoho.com'
#       elsif datatype == 'fileupload'
#       #      record1.field_data[field_api_name]=[{"file_id"=>fileid}]
#       elsif datatype == 'website'
#         record1.field_data[field_api_name] = 'www.zoho.com'
#       elsif datatype == 'integer' || datatype == 'bigint'
#         record1.field_data[field_api_name] = 123
#       elsif datatype == 'phone'
#         phonemodules[creatable_module_api_name] = 1
#         record1.field_data[field_api_name] = iterator.to_s + '123'
#       elsif datatype == 'currency'
#         record1.field_data[field_api_name] = iterator + 123
#       elsif datatype == 'boolean'
#         record1.field_data[field_api_name] = true
#       elsif datatype == 'date'
#         record1.field_data[field_api_name] = '2019-07-11'
#       elsif datatype == 'double'
#         record1.field_data[field_api_name] = 2.1
#       elsif datatype == 'textarea'
#         record1.field_data[field_api_name] = 'ruby_automation_at_work'
#       elsif datatype == 'datetime'
#         record1.field_data[field_api_name] = '2019-06-15T15:53:00+05:30'
#       end
#     end
#     create_record_response = record1.create
#     if create_record_response.code == 'SUCCESS'
#       create_record_id = create_record_response.details['id']
#       if iterator == 0
#         created_record[creatable_module_api_name] = [ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(create_record_id).data]
#       else
#         created_record[creatable_module_api_name].push(ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(create_record_id).data)
#       end
#     end
#     iterator += 1
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # create_records()
#   multiplerecords = []
#   iterator = 2 * record_count
#   while iterator < 3 * record_count
#     record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, nil)
#     moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#       datatype = field_details['data_type']
#       length = field_details['length']
#       fieldlabel = field_details['field_label']
#       lookup_ins = field_details['lookup']
#       if datatype == 'ownerlookup'
#         record1.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user_id)
#       elsif fieldlabel == 'Pricing Details'
#         price_ins = ZCRMSDK::Operations::ZCRMPriceBookPricing.get_instance
#         price_ins.from_range = 1
#         price_ins.to_range = 100
#         price_ins.discount = 5
#         record1.price_details = [price_ins]
#       elsif fieldlabel == 'Product Details'
#         line_item_instance = ZCRMSDK::Operations::ZCRMInventoryLineItem.get_instance(ZCRMSDK::Operations::ZCRMRecord.get_instance('Products', created_record['Products'][0].entity_id))
#         line_item_instance.description = 'ruby_automation_lineitem'
#         line_item_instance.list_price = 123
#         line_item_instance.quantity = 10
#         line_item_instance.discount = 10
#         record1.line_items.push(line_item_instance)
#       elsif fieldlabel == 'Participants'
#         record1.field_data[field_api_name] = [{ 'type' => 'user', 'participant' => current_user_id }]
#       elsif fieldlabel == 'Call Duration'
#         record1.field_data[field_api_name] = '10:00'
#       elsif fieldlabel == 'Tag'
#         record1.tag_list.push(ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag1'))
#       elsif datatype == 'lookup'
#         if created_record[lookup_ins.module_apiname]
#           record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][0].entity_id
#         end
#         if lookup_ins.module_apiname == 'se_module'
#           record1.field_data['$se_module'] = 'Accounts'
#           record1.field_data[field_api_name] = { 'id' => created_record['Accounts'][0].entity_id }
#         end
#       elsif datatype == 'text'
#         word = iterator.to_s + '1234567890'
#         word = word[0, length - 1]
#         record1.field_data[field_api_name] = word
#       elsif datatype == 'event_reminder'
#         record1.field_data[field_api_name] = '0'
#       elsif datatype == 'ALARM'
#         record1.field_data[field_api_name] = { 'ALARM' => 'FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30' }
#       elsif datatype == 'picklist'
#         if field_details['picklist'].length > 1
#           record1.field_data[field_api_name] = field_details['picklist'][1].display_value
#         elsif
#           record1.field_data[field_api_name] = field_details['picklist'][0].display_value
#         end
#       elsif datatype == 'multiselectpicklist'
#         if fieldlabel == 'Tax'
#           record1.field_data[field_api_name] = ['record_tax']
#         else
#           record1.field_data[field_api_name] = [field_details['picklist'][0].display_value]
#         end
#       elsif datatype == 'email'
#         record1.field_data[field_api_name] = iterator.to_s + 'rubysdk+automation@zoho.com'
#       elsif datatype == 'fileupload'
#       #      record1.field_data[field_api_name]=[{"file_id"=>fileid}]
#       elsif datatype == 'website'
#         record1.field_data[field_api_name] = 'www.zoho.com'
#       elsif datatype == 'integer' || datatype == 'bigint'
#         record1.field_data[field_api_name] = 123
#       elsif datatype == 'phone'
#         record1.field_data[field_api_name] = iterator.to_s + '123'
#       elsif datatype == 'currency'
#         record1.field_data[field_api_name] = iterator + 123
#       elsif datatype == 'boolean'
#         record1.field_data[field_api_name] = true
#       elsif datatype == 'date'
#         record1.field_data[field_api_name] = '2019-07-11'
#       elsif datatype == 'double'
#         record1.field_data[field_api_name] = 2.1
#       elsif datatype == 'textarea'
#         record1.field_data[field_api_name] = 'ruby_automation_at_work'
#       elsif datatype == 'datetime'
#         record1.field_data[field_api_name] = '2019-06-15T15:53:00+05:30'
#       end
#     end
#     iterator += 1
#     multiplerecords.push(record1)
#   end
#   create_records_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).create_records(multiplerecords).bulk_entity_response
#   created_records[creatable_module_api_name] = []
#   created_record_ids[creatable_module_api_name] = []
#   create_records_response.each do |record_response|
#     created_record_ids[creatable_module_api_name].push(record_response.details['id'])
#     if record_response.code == 'SUCCESS'
#       created_record_ids[creatable_module_api_name].push(record_response.details['id'])
#       created_records[creatable_module_api_name].push(ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(record_response.details['id']).data)
#     end
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # update
#   iterator = record_count
#   while iterator < 2 * record_count
#     record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][iterator - record_count].entity_id)
#     moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#       next unless field_details['editable']

#       datatype = field_details['data_type']
#       length = field_details['length']
#       fieldlabel = field_details['field_label']
#       lookup_ins = field_details['lookup']
#       if fieldlabel == 'Pricing Details'
#         price_ins = ZCRMSDK::Operations::ZCRMPriceBookPricing.get_instance
#         price_ins.from_range = 2
#         price_ins.to_range = 200
#         price_ins.discount = 10
#         record1.price_details = [price_ins]
#       elsif fieldlabel == 'Product Details'
#         line_item_instance = ZCRMSDK::Operations::ZCRMInventoryLineItem.get_instance(ZCRMSDK::Operations::ZCRMRecord.get_instance('Products', created_record['Products'][1].entity_id))
#         line_item_instance.description = 'ruby_update_automation_lineitem'
#         line_item_instance.list_price = 246
#         line_item_instance.quantity = 20
#         line_item_instance.discount = 20
#         record1.line_items.push(line_item_instance)
#       elsif fieldlabel == 'Participants'
#         record1.field_data[field_api_name] = [{ 'type' => 'user', 'participant' => current_user_id }]
#       elsif fieldlabel == 'Call Duration'
#         record1.field_data[field_api_name] = '20:00'
#       elsif datatype == 'lookup'
#         if lookup_ins.module_apiname == creatable_module_api_name && iterator != record_count && created_record[lookup_ins.module_apiname]
#           record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][iterator - record_count - 1].entity_id
#         elsif lookup_ins.module_apiname != creatable_module_api_name && created_record[lookup_ins.module_apiname]
#           record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][1].entity_id
#         end
#         if lookup_ins.module_apiname == 'se_module'
#           record1.field_data['$se_module'] = 'Accounts'
#           record1.field_data[field_api_name] = { 'id' => created_record['Accounts'][1].entity_id }
#         end
#       elsif datatype == 'ownerlookup'
#         record1.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user_id)
#       elsif datatype == 'text'
#         word = iterator.to_s + '1234567890'
#         word = word[0, length - 1]
#         record1.field_data[field_api_name] = word
#       elsif datatype == 'RRULE'
#         record1.field_data[field_api_name] = { 'RRULE' => 'FREQ=YEARLY;BYMONTH=11;INTERVAL=50;BYMONTHDAY=14;DTSTART=2016-10-30;UNTIL=2016-11-31' }
#       elsif datatype == 'event_reminder'
#         record1.field_data[field_api_name] = '0'
#       elsif datatype == 'ALARM'
#         record1.field_data[field_api_name] = { 'ALARM' => 'FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30' }
#       elsif datatype == 'picklist'
#         if field_details['picklist'].length > 1
#           record1.field_data[field_api_name] = field_details['picklist'][1].display_value
#         elsif
#           record1.field_data[field_api_name] = field_details['picklist'][0].display_value
#         end
#       elsif datatype == 'multiselectpicklist'
#         if fieldlabel == 'Tax'
#           record1.field_data[field_api_name] = ['record_tax']
#         else
#           record1.field_data[field_api_name] = [field_details['picklist'][0].display_value]
#         end
#       elsif datatype == 'email'
#         record1.field_data[field_api_name] = iterator.to_s + 'rubysdk+automation@zoho.com'
#       elsif datatype == 'fileupload'
#       #      record1.field_data[field_api_name]=[{"file_id"=>fileid}]
#       elsif datatype == 'website'
#         record1.field_data[field_api_name] = 'www.zoho.com'
#       elsif datatype == 'integer' || datatype == 'bigint'
#         record1.field_data[field_api_name] = 123
#       elsif datatype == 'phone'
#         record1.field_data[field_api_name] = iterator.to_s + '123'
#       elsif datatype == 'currency'
#         record1.field_data[field_api_name] = iterator + 123
#       elsif datatype == 'boolean'
#         record1.field_data[field_api_name] = true
#       elsif datatype == 'date'
#         record1.field_data[field_api_name] = '2019-08-11'
#       elsif datatype == 'double'
#         record1.field_data[field_api_name] = 2.1
#       elsif datatype == 'textarea'
#         record1.field_data[field_api_name] = 'ruby_updation_at_work'
#       elsif datatype == 'datetime'
#         record1.field_data[field_api_name] = '2019-06-15T15:53:00+05:30'
#       end
#     end
#     update_record_response = record1.update
#     if update_record_response.code == 'SUCCESS'
#       update_record_id = update_record_response.details['id']
#       if iterator == 3
#         updated_record[creatable_module_api_name] = [ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(update_record_id).data]
#       else
#         updated_record[creatable_module_api_name].push(ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(update_record_id).data)
#       end
#     end
#     iterator += 1
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # update_records
#   multiplerecords = []
#   iterator = 3 * record_count
#   while iterator < 4 * record_count
#     record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_records[creatable_module_api_name][(iterator + record_count) - (4 * record_count)].entity_id)
#     moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#       next unless field_details['editable']

#       datatype = field_details['data_type']
#       length = field_details['length']
#       fieldlabel = field_details['field_label']
#       lookup_ins = field_details['lookup']
#       if fieldlabel == 'Pricing Details'
#         price_ins = ZCRMSDK::Operations::ZCRMPriceBookPricing.get_instance
#         price_ins.from_range = 2
#         price_ins.to_range = 200
#         price_ins.discount = 10
#         record1.price_details = [price_ins]
#       elsif fieldlabel == 'Product Details'
#         line_item_instance = ZCRMSDK::Operations::ZCRMInventoryLineItem.get_instance(ZCRMSDK::Operations::ZCRMRecord.get_instance('Products', created_record['Products'][1].entity_id))
#         line_item_instance.description = 'ruby_update_automation_lineitem'
#         line_item_instance.list_price = 246
#         line_item_instance.quantity = 20
#         line_item_instance.discount = 20
#         record1.line_items.push(line_item_instance)
#       elsif fieldlabel == 'Participants'
#         record1.field_data[field_api_name] = [{ 'type' => 'user', 'participant' => current_user_id }]
#       elsif fieldlabel == 'Call Duration'
#         record1.field_data[field_api_name] = '20:00'
#       elsif datatype == 'lookup'
#         if created_record[lookup_ins.module_apiname]
#           record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][1].entity_id
#         end
#         if lookup_ins.module_apiname == 'se_module'
#           record1.field_data['$se_module'] = 'Accounts'
#           record1.field_data[field_api_name] = { 'id' => created_record['Accounts'][1].entity_id }
#         end
#       elsif datatype == 'ownerlookup'
#         record1.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user_id)
#       elsif datatype == 'text'
#         word = iterator.to_s + '1234567890'
#         word = word[0, length - 1]
#         record1.field_data[field_api_name] = word
#       elsif datatype == 'event_reminder'
#         record1.field_data[field_api_name] = '0'
#       elsif datatype == 'ALARM'
#         record1.field_data[field_api_name] = { 'ALARM' => 'FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30' }
#       elsif datatype == 'picklist'
#         if field_details['picklist'].length > 1
#           record1.field_data[field_api_name] = field_details['picklist'][1].display_value
#         elsif
#           record1.field_data[field_api_name] = field_details['picklist'][0].display_value
#         end
#       elsif datatype == 'multiselectpicklist'
#         if fieldlabel == 'Tax'
#           record1.field_data[field_api_name] = ['record_tax']
#         else
#           record1.field_data[field_api_name] = [field_details['picklist'][0].display_value]
#         end
#       elsif datatype == 'email'
#         record1.field_data[field_api_name] = iterator.to_s + 'rubysdk+automation@zoho.com'
#       elsif datatype == 'fileupload'
#       #      record1.field_data[field_api_name]=[{"file_id"=>fileid}]
#       elsif datatype == 'website'
#         record1.field_data[field_api_name] = 'www.zoho.com'
#       elsif datatype == 'integer' || datatype == 'bigint'
#         record1.field_data[field_api_name] = 123
#       elsif datatype == 'phone'
#         record1.field_data[field_api_name] = iterator.to_s + '123'
#       elsif datatype == 'currency'
#         record1.field_data[field_api_name] = iterator + 123
#       elsif datatype == 'boolean'
#         record1.field_data[field_api_name] = true
#       elsif datatype == 'date'
#         record1.field_data[field_api_name] = '2019-08-11'
#       elsif datatype == 'double'
#         record1.field_data[field_api_name] = 2.1
#       elsif datatype == 'textarea'
#         record1.field_data[field_api_name] = 'ruby_updation_at_work'
#       elsif datatype == 'datetime'
#         record1.field_data[field_api_name] = '2019-06-15T15:53:00+05:30'
#       end
#     end
#     multiplerecords.push(record1)
#     iterator += 1
#     if iterator == 4 * record_count
#       upsert_records_instances[creatable_module_api_name] = [record1]
#     end
#   end
#   updated_records_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).update_records(multiplerecords).bulk_entity_response
#   updated_records[creatable_module_api_name] = []
#   updated_records_response.each do |record_response|
#     updated_records[creatable_module_api_name].push(ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(record_response.details['id']).data)
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # upsert_records
#   next if activity_module.include?(creatable_module_api_name)

#   iterator = 4 * record_count
#   upsert_records_instances[creatable_module_api_name][0].entity_id = nil
#   record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, nil)
#   moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#     datatype = field_details['data_type']
#     length = field_details['length']
#     fieldlabel = field_details['field_label']
#     lookup_ins = field_details['lookup']
#     if datatype == 'ownerlookup'
#       record1.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(current_user_id)
#     elsif fieldlabel == 'Pricing Details'
#       price_ins = ZCRMSDK::Operations::ZCRMPriceBookPricing.get_instance
#       price_ins.from_range = 2
#       price_ins.to_range = 200
#       price_ins.discount = 10
#       record1.price_details = [price_ins]
#     elsif fieldlabel == 'Product Details'
#       line_item_instance = ZCRMSDK::Operations::ZCRMInventoryLineItem.get_instance(ZCRMSDK::Operations::ZCRMRecord.get_instance('Products', created_record['Products'][1].entity_id))
#       line_item_instance.description = 'ruby_automation_lineitem'
#       line_item_instance.list_price = 246
#       line_item_instance.quantity = 20
#       line_item_instance.discount = 20
#       record1.line_items.push(line_item_instance)
#     elsif fieldlabel == 'Participants'
#       record1.field_data[field_api_name] = [{ 'type' => 'user', 'participant' => current_user_id }]
#     elsif fieldlabel == 'Call Duration'
#       record1.field_data[field_api_name] = '20:00'
#     elsif fieldlabel == 'Tag'
#       record1.tag_list.push(ZCRMSDK::Operations::ZCRMTag.get_instance(nil, 'ruby_automation_tag1'))
#     elsif datatype == 'lookup'
#       if created_record[lookup_ins.module_apiname]
#         record1.field_data[field_api_name] = created_record[lookup_ins.module_apiname][1].entity_id
#       end
#       if lookup_ins.module_apiname == 'se_module'
#         record1.field_data['$se_module'] = 'Accounts'
#         record1.field_data[field_api_name] = { 'id' => created_record['Accounts'][1].entity_id }
#       end
#     elsif datatype == 'text'
#       word = iterator.to_s + '1234567890'
#       word = word[0, length - 1]
#       record1.field_data[field_api_name] = word
#     elsif datatype == 'event_reminder'
#       record1.field_data[field_api_name] = '0'
#     elsif datatype == 'ALARM'
#       record1.field_data[field_api_name] = { 'ALARM' => 'FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30' }
#     elsif datatype == 'picklist'
#       if field_details['picklist'].length > 1
#         record1.field_data[field_api_name] = field_details['picklist'][1].display_value
#       elsif
#         record1.field_data[field_api_name] = field_details['picklist'][0].display_value
#       end
#     elsif datatype == 'multiselectpicklist'
#       if fieldlabel == 'Tax'
#         record1.field_data[field_api_name] = ['record_tax']
#       else
#         record1.field_data[field_api_name] = [field_details['picklist'][0].display_value]
#       end
#     elsif datatype == 'email'
#       record1.field_data[field_api_name] = iterator.to_s + 'rubysdk+automation@zoho.com'
#     elsif datatype == 'fileupload'
#     #      record1.field_data[field_api_name]=[{"file_id"=>fileid}]
#     elsif datatype == 'website'
#       record1.field_data[field_api_name] = 'www.zoho.com'
#     elsif datatype == 'integer' || datatype == 'bigint'
#       record1.field_data[field_api_name] = 123
#     elsif datatype == 'phone'
#       record1.field_data[field_api_name] = iterator.to_s + '123'
#     elsif datatype == 'currency'
#       record1.field_data[field_api_name] = iterator + 123
#     elsif datatype == 'boolean'
#       record1.field_data[field_api_name] = true
#     elsif datatype == 'date'
#       record1.field_data[field_api_name] = '2019-07-11'
#     elsif datatype == 'double'
#       record1.field_data[field_api_name] = 2.1
#     elsif datatype == 'textarea'
#       record1.field_data[field_api_name] = 'ruby_automation_at_work'
#     elsif datatype == 'datetime'
#       record1.field_data[field_api_name] = '2019-06-15T15:53:00+05:30'
#     end
#   end
#   upsert_records_instances[creatable_module_api_name].push(record1)
#   upserted_records_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).upsert_records(upsert_records_instances[creatable_module_api_name]).bulk_entity_response
#   upserted_records[creatable_module_api_name] = []
#   upserted_records_response.each do |record_response|
#     upserted_records[creatable_module_api_name].push(ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_record(record_response.details['id']).data)
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # update_tags
#   tags = []
#   tag1 = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_ids[creatable_module_api_name][0], 'ruby_updated_tag1')
#   tags.push(tag1)
#   tag2 = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_ids[creatable_module_api_name][1], 'ruby_updated_tag2')
#   tags.push(tag2)
#   tag3 = ZCRMSDK::Operations::ZCRMTag.get_instance(tag_ids[creatable_module_api_name][2], 'ruby_updated_tag3')
#   tags.push(tag3)
#   update_tag_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).update_tags(tags).bulk_entity_response
#   updated_tags[creatable_module_api_name] = []
#   updated_tag_ids = []
#   update_tag_response.each do |res|
#     if res.code == 'SUCCESS'
#       updated_tag_ids.push(res.details['id'])
#     else
#       update_tags_flag = 1
#     end
#   end
#   get_tags_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_tags.data
#   get_tags_response.each do |tag_ins|
#     if updated_tag_ids.include?(tag_ins.id)
#       updated_tags[creatable_module_api_name].push(tag_ins)
#     end
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # search by word
#   begin
#     search_records_response[creatable_module_api_name] = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).search_records('ruby_updation_at_work').data
#   rescue StandardError
#     print "\n no content \n"
#   end
# end
# phonemodules.each do |module_api_name, _value| # search by phone
#   begin
#     phone = record_count.to_s + '123'
#     search_records_response_phone[module_api_name] = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).search_records_by_phone(phone).data
#   rescue StandardError
#     print "\n no content \n"
#   end
# end
# emailmodules.each do |module_api_name, _value| # search by email
#   begin
#     email = record_count.to_s + 'rubysdk+automation@zoho.com'
#     search_records_response_email[module_api_name] = ZCRMSDK::Operations::ZCRMModule.get_instance(module_api_name).search_records_by_email(email).data
#   rescue StandardError
#     print "\n no content \n"
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # search record by criteria
#   begin
#     criteria = ''
#     moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#       datatype = field_details['data_type']
#       if datatype == 'textarea'
#         criteria = field_api_name + ':starts_with:ruby_updation_at_work'
#       end
#     end
#     search_records_response_criteria[creatable_module_api_name] = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).search_records_by_criteria(criteria).data
#   rescue StandardError
#     print "\n no content \n"
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # mass update
#   moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#     datatype = field_details['data_type']
#     if datatype == 'textarea'
#       response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).mass_update_records(created_record_ids[creatable_module_api_name], field_api_name, 'ruby_mass_updation_at_work').bulk_entity_response
#     end
#   end
#   mass_update_records_response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_records.data
#   mass_updated_records[creatable_module_api_name] = []
#   mass_update_records_response.each do |record|
#     if created_record_ids[creatable_module_api_name].include?(record.entity_id)
#       mass_updated_records[creatable_module_api_name].push(record)
#     end
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # add tags to records
#   tag_list = %w[ruby_updated_tag1 ruby_updated_tag2 ruby_updated_tag3]
#   ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).add_tags_to_multiple_records(tag_list, created_record_ids[creatable_module_api_name])
#   records_tag_added[creatable_module_api_name] = []
#   response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_records.data
#   response.each do |record|
#     if created_record_ids[creatable_module_api_name].include?(record.entity_id)
#       records_tag_added[creatable_module_api_name].push(record)
#     end
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # tagrecord count
#   tags = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_tags.data
#   record_tag_count[creatable_module_api_name] = []
#   tags.each do |tag_ins|
#     record_tag_count[creatable_module_api_name].push(ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_tag_count(tag_ins.id).data.count)
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # remove tags from records
#   tag_list = %w[ruby_updated_tag1 ruby_updated_tag2 ruby_updated_tag3]
#   ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).remove_tags_from_multiple_records(tag_list, created_record_ids[creatable_module_api_name])
#   records_tag_removed[creatable_module_api_name] = []
#   response = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name).get_records.data
#   response.each do |record|
#     if created_record_ids[creatable_module_api_name].include?(record.entity_id)
#       records_tag_removed[creatable_module_api_name].push(record)
#     end
#   end
# end
# creatable_module_api_names.each do |creatable_module_api_name| # delete_tags
#   deleted_tags[creatable_module_api_name] = []
#   updated_tags[creatable_module_api_name].each do |tag_ins|
#     tag_ins.module_apiname = creatable_module_api_name
#     deleted_tags[creatable_module_api_name].push(tag_ins.delete)
#   end
# end
# creatable_module_api_names.reverse!
# creatable_module_api_names.each do |creatable_module_api_name| # delete() and delete_records()
#   module_ins = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name)
#   delete_record_ids = [created_record[creatable_module_api_name][1].entity_id, created_record[creatable_module_api_name][2].entity_id, created_records[creatable_module_api_name][0].entity_id, created_records[creatable_module_api_name][1].entity_id, created_records[creatable_module_api_name][2].entity_id]
#   unless activity_module.include?(creatable_module_api_name)
#     delete_record_ids.push(upserted_records[creatable_module_api_name][1].entity_id)
#   end
#   deleted_records_response[creatable_module_api_name] = module_ins.delete_records(delete_record_ids).bulk_entity_response
#   record1 = ZCRMSDK::Operations::ZCRMRecord.get_instance(creatable_module_api_name, created_record[creatable_module_api_name][0].entity_id)
#   deleted_record_response[creatable_module_api_name] = record1.delete
# end
# creatable_module_api_names.each do |creatable_module_api_name|
#   module_ins = ZCRMSDK::Operations::ZCRMModule.get_instance(creatable_module_api_name)
#   begin
#     all_deleted_records[creatable_module_api_name] = module_ins.get_all_deleted_records.data
#     recyclebin_records[creatable_module_api_name] = module_ins.get_recyclebin_records.data
#     permanently_deleted_records[creatable_module_api_name] = module_ins.get_permanently_deleted_records.data
#   rescue StandardError
#   end
# end
# org_ins.delete_organization_taxes(org_tax_id)
# RSpec.describe 'meta_data' do
#   it 'get_all_modules' do
#     modules.each do |module_ins|
#       expect(module_ins).to be_an_instance_of(ZCRMSDK::Operations::ZCRMModule)
#       expect(module_ins.api_name).to be_a_kind_of(String)
#       expect(module_ins.is_convertable).to be(true).or be(false)
#       expect(module_ins.is_creatable).to be(true).or be(false)
#       expect(module_ins.is_editable).to be(true).or be(false)
#       expect(module_ins.is_deletable).to be(true).or be(false)
#       expect(module_ins.web_link).to be_a_kind_of(String).or be(nil)
#       expect(module_ins.singular_label).to be_a_kind_of(String)
#       expect(module_ins.plural_label).to be_a_kind_of(String)
#       modified_by = module_ins.modified_by
#       unless modified_by.nil?
#         expect(modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(modified_by.id).to be_a_kind_of(String)
#         expect(modified_by.name).to be_a_kind_of(String)
#       end
#       expect(module_ins.modified_time).to be_a_kind_of(String).or be(nil)
#       expect(module_ins.is_viewable).to be(true).or be(false)
#       expect(module_ins.is_api_supported).to be(true).or be(false)
#       expect(module_ins.is_custom_module).to be(true).or be(false)
#       expect(module_ins.is_scoring_supported).to be(true).or be(false)
#       expect(module_ins.id).to be_a_kind_of(String)
#       expect(module_ins.module_name).to be_a_kind_of(String)
#       expect(module_ins.business_card_field_limit).to be_a_kind_of(Integer)
#       expect(module_ins.business_card_fields).to be_a_kind_of(Array)
#       profiles = module_ins.profiles
#       profiles.each do |profile|
#         expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
#         expect(profile.id).to be_a_kind_of(String)
#         expect(profile.name).to be_a_kind_of(String)
#       end
#       expect(module_ins.is_global_search_supported).to be(true).or be(false)
#       expect(module_ins.sequence_number).to be_a_kind_of(Integer)
#       expect(module_ins.is_presence_sub_menu).to be(true).or be(false)
#       expect(module_ins.arguments).to be_a_kind_of(Array)
#       expect(module_ins.generated_type).to be_a_kind_of(String)
#       expect(module_ins.is_quick_create).to be(true).or be(false)
#       expect(module_ins.is_filter_supported).to be(true).or be(false)
#       parent_module = module_ins.parent_module
#       unless parent_module.nil?
#         expect(parent_module).to be_an_instance_of(ZCRMSDK::Operations::ZCRMModule)
#         expect(parent_module.id).to be_a_kind_of(String)
#         expect(parent_module.api_name).to be_a_kind_of(String)
#       end
#       expect(module_ins.is_feeds_required).to be(true).or be(false)
#       expect(module_ins.is_email_template_support).to be(true).or be(false)
#       expect(module_ins.is_webform_supported).to be(true).or be(false)
#       expect(module_ins.visibility).to be_a_kind_of(Integer)
#     end
#   end
#   it 'get_module' do
#     modules_all.each do |module_ins|
#       print "\n"
#       print module_ins.api_name
#       expect(module_ins).to be_an_instance_of(ZCRMSDK::Operations::ZCRMModule)
#       expect(module_ins.api_name).to be_a_kind_of(String)
#       expect(module_ins.is_convertable).to be(true).or be(false)
#       expect(module_ins.is_creatable).to be(true).or be(false)
#       expect(module_ins.is_editable).to be(true).or be(false)
#       expect(module_ins.is_deletable).to be(true).or be(false)
#       expect(module_ins.is_inventory_template_supported).to be(true).or be(false)
#       expect(module_ins.web_link).to be_a_kind_of(String).or be(nil)
#       expect(module_ins.singular_label).to be_a_kind_of(String)
#       expect(module_ins.plural_label).to be_a_kind_of(String)
#       modified_by = module_ins.modified_by
#       unless modified_by.nil?
#         expect(modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(modified_by.id).to be_a_kind_of(String)
#         expect(modified_by.name).to be_a_kind_of(String)
#       end
#       expect(module_ins.modified_time).to be_a_kind_of(String).or be(nil)
#       expect(module_ins.is_viewable).to be(true).or be(false)
#       expect(module_ins.is_api_supported).to be(true)
#       expect(module_ins.is_custom_module).to be(true).or be(false)
#       expect(module_ins.is_scoring_supported).to be(true).or be(false)
#       expect(module_ins.id).to be_a_kind_of(String)
#       expect(module_ins.module_name).to be_a_kind_of(String)
#       expect(module_ins.per_page).to be_a_kind_of(Integer)
#       expect(module_ins.business_card_field_limit).to be_a_kind_of(Integer)
#       profiles = module_ins.profiles
#       profiles.each do |profile|
#         expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
#         expect(profile.id).to be_a_kind_of(String)
#         expect(profile.name).to be_a_kind_of(String)
#       end
#       expect(module_ins.search_layout_fields).to be_a_kind_of(Array)
#       expect(module_ins.display_field_name).to be_a_kind_of(String)
#       rel_list_prop = module_ins.related_list_properties
#       unless rel_list_prop.nil?
#         expect(rel_list_prop).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRelatedListProperties)
#         expect(rel_list_prop.sort_by).to be_a_kind_of(String).or be(nil)
#         expect(rel_list_prop.sort_order).to be_a_kind_of(String).or be(nil)
#         expect(rel_list_prop.fields).to be_a_kind_of(Array)
#       end
#       expect(module_ins.default_territory_name).to be_a_kind_of(String).or be(nil)
#       expect(module_ins.default_territory_id).to be_a_kind_of(String).or be(nil)
#       expect(module_ins.is_global_search_supported).to be(true).or be(false)
#       expect(module_ins.sequence_number).to be_a_kind_of(Integer)
#       expect(module_ins.is_filter_status).to be(true).or be(false)
#       expect(module_ins.is_presence_sub_menu).to be(true).or be(false)
#       expect(module_ins.arguments).to be_a_kind_of(Array)
#       module_custom_view = module_ins.default_custom_view
#       expect(module_custom_view).to be_an_instance_of(ZCRMSDK::Operations::ZCRMCustomView)
#       expect(module_custom_view.id).to be_a_kind_of(String)
#       expect(module_custom_view.module_api_name).to be_a_kind_of(String)
#       expect(module_custom_view.display_value).to be_a_kind_of(String)
#       expect(module_custom_view.name).to be_a_kind_of(String)
#       expect(module_custom_view.system_name).to be_a_kind_of(String)
#       expect(module_custom_view.sort_by).to be_a_kind_of(String).or be(nil)
#       expect(module_custom_view.category).to be_a_kind_of(String)
#       expect(module_custom_view.fields).to be_an_instance_of(Array)
#       expect(module_custom_view.favorite).to be_a_kind_of(String).or be(nil)
#       expect(module_custom_view.sort_order).to be_a_kind_of(String)
#       expect(module_custom_view.criteria).to be_an_instance_of(ZCRMSDK::Operations::ZCRMCustomViewCriteria).or be(nil)
#       expect(module_custom_view.criteria_condition).to be_a_kind_of(String).or be(nil)
#       expect(module_custom_view.criteria_pattern).to be_a_kind_of(String).or be(nil)
#       expect(module_custom_view.is_default).to be(true).or be(false)
#       expect(module_custom_view.is_off_line).to be(true).or be(false)
#       expect(module_custom_view.is_system_defined).to be(true).or be(false)
#       expect(module_custom_view.shared_details).to be_a_kind_of(String).or be(nil)
#       expect(module_ins.default_custom_view_id).to be_a_kind_of(String)
#       expect(module_ins.generated_type).to be_a_kind_of(String)
#       expect(module_ins.is_quick_create).to be(true).or be(false)
#       expect(module_ins.is_kanban_view_supported).to be(true).or be(false)
#       expect(module_ins.is_filter_supported).to be(true).or be(false)
#       parent_module = module_ins.parent_module
#       unless parent_module.nil?
#         expect(parent_module).to be_an_instance_of(ZCRMSDK::Operations::ZCRMModule)
#         expect(parent_module.id).to be_a_kind_of(String)
#         expect(parent_module.api_name).to be_a_kind_of(String)
#       end
#       expect(module_ins.is_feeds_required).to be(true).or be(false)
#       expect(module_ins.is_email_template_support).to be(true).or be(false)
#       expect(module_ins.is_webform_supported).to be(true).or be(false)
#       expect(module_ins.visibility).to be_a_kind_of(Integer)
#     end
#   end
#   it 'get_fields' do
#     modulevsfields.each do |module_api_name, field_array|
#       field_array.each do |field_instance|
#         print "\n " + module_api_name + ': ' + field_instance.api_name
#         expect(field_instance.api_name).to be_a_kind_of(String)
#         expect(field_instance.is_webhook).to be(true).or be(false)
#         expect(field_instance.crypt).to be(nil)
#         unless field_instance.tooltip.nil?
#           expect(field_instance.tooltip['name']).to be_a_kind_of(String)
#           expect(field_instance.tooltip['value']).to be_a_kind_of(String)
#         end
#         expect(field_instance.is_field_read_only).to be(true).or be(false)
#         expect(field_instance.association_details).to be(String).or be(nil)
#         expect(field_instance.subform).to be(nil)
#         expect(field_instance.is_mass_update).to be(true).or be(false)
#         multiselectlookup = field_instance.multiselectlookup
#         unless multiselectlookup.empty?
#           expect(multiselectlookup.display_label).to be_a_kind_of(String)
#           expect(multiselectlookup.linking_module).to be_a_kind_of(String)
#           expect(multiselectlookup.connected_module).to be_a_kind_of(String)
#           expect(multiselectlookup.api_name).to be_a_kind_of(String)
#           expect(multiselectlookup.id).to be_a_kind_of(String)
#         end
#         expect(field_instance.is_custom_field).to be(true).or be(false)
#         expect(field_instance.lookup_field).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLookupField).or be_a_kind_of(Hash)
#         expect(field_instance.is_visible).to be(true).or be(false)
#         expect(field_instance.field_label).to be_a_kind_of(String)
#         expect(field_instance.length).to be_a_kind_of(Integer)
#         expect(field_instance.created_source).to be_a_kind_of(String)
#         expect(field_instance.is_mandatory).to be(true).or be(false)
#         expect(field_instance.is_read_only).to be(true).or be(false)
#         expect(field_instance.is_unique_field).to be(true).or be(false)
#         expect(field_instance.is_case_sensitive).to be(true).or be(false)
#         expect(field_instance.data_type).to be_a_kind_of(String)
#         expect(field_instance.is_formula_field).to be(true).or be(false)
#         if field_instance.is_formula_field
#           expect(field_instance.formula_return_type).to be_a_kind_of(String)
#           expect(field_instance.formula_expression).to be_a_kind_of(String).or be(nil)
#         end
#         expect(field_instance.is_currency_field).to be(true).or be(false)
#         if field_instance.is_currency_field
#           expect(field_instance.precision).to be_a_kind_of(Integer)
#           expect(field_instance.rounding_option).to be_a_kind_of(String)
#         end
#         expect(field_instance.id).to be_a_kind_of(String)
#         picklist_values = field_instance.picklist_values
#         picklist_values.each do |picklist_instance|
#           expect(picklist_instance.display_value).to be_a_kind_of(String)
#           expect(picklist_instance.sequence_number).to be_a_kind_of(Integer).or be(nil)
#           expect(picklist_instance.actual_value).to be_a_kind_of(String)
#           expect(picklist_instance.maps).to be_a_kind_of(String).or be(nil).or be_a_kind_of(Array)
#         end
#         expect(field_instance.is_auto_number).to be(true).or be(false)
#         if field_instance.is_auto_number
#           expect(field_instance.prefix).to be_a_kind_of(Integer).or be(nil)
#           expect(field_instance.suffix).to be_a_kind_of(Integer).or be(nil)
#           expect(field_instance.start_number).to be_a_kind_of(Integer).or be(nil)
#         end
#         expect(field_instance.is_business_card_supported).to be(true).or be(false)
#         expect(field_instance.field_layout_permissions).to be_a_kind_of(Array)
#         expect(field_instance.decimal_place).to be_a_kind_of(Integer).or be(nil)
#         if field_instance.api_name != 'file' && field_instance.api_name != 'Record_Image' && field_instance.api_name != 'Recurring_Activity' && field_instance.api_name != 'Remind_At'
#           expect(field_instance.json_type).to be_a_kind_of(String)
#         end
#       end
#     end
#   end
#   it 'get_field' do
#     moduleapinamevsfieldsidvsdata.each do |moduleapiname, fieldsidvsdata|
#       fieldsidvsdata.each do |fieldid, field_instance|
#         print "\n " + moduleapiname + ': ' + field_instance.api_name + ':' + fieldid
#         expect(field_instance.api_name).to be_a_kind_of(String)
#         expect(field_instance.is_webhook).to be(true).or be(false)
#         expect(field_instance.crypt).to be(nil)
#         unless field_instance.tooltip.nil?
#           expect(field_instance.tooltip['name']).to be_a_kind_of(String)
#           expect(field_instance.tooltip['value']).to be_a_kind_of(String)
#         end
#         expect(field_instance.is_field_read_only).to be(true).or be(false)
#         expect(field_instance.association_details).to be(String).or be(nil)
#         expect(field_instance.subform).to be(nil)
#         expect(field_instance.is_mass_update).to be(true).or be(false)
#         multiselectlookup = field_instance.multiselectlookup
#         unless multiselectlookup.empty?
#           expect(multiselectlookup.display_label).to be_a_kind_of(String)
#           expect(multiselectlookup.linking_module).to be_a_kind_of(String)
#           expect(multiselectlookup.connected_module).to be_a_kind_of(String)
#           expect(multiselectlookup.api_name).to be_a_kind_of(String)
#           expect(multiselectlookup.id).to be_a_kind_of(String)
#         end
#         expect(field_instance.is_custom_field).to be(true).or be(false)
#         expect(field_instance.lookup_field).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLookupField).or be_a_kind_of(Hash)
#         expect(field_instance.is_visible).to be(true).or be(false)
#         expect(field_instance.field_label).to be_a_kind_of(String)
#         expect(field_instance.length).to be_a_kind_of(Integer)
#         expect(field_instance.created_source).to be_a_kind_of(String)
#         expect(field_instance.is_mandatory).to be(true).or be(false)
#         expect(field_instance.is_read_only).to be(true).or be(false)
#         expect(field_instance.is_unique_field).to be(true).or be(false)
#         expect(field_instance.is_case_sensitive).to be(true).or be(false)
#         expect(field_instance.data_type).to be_a_kind_of(String)
#         expect(field_instance.is_formula_field).to be(true).or be(false)
#         if field_instance.is_formula_field
#           expect(field_instance.formula_return_type).to be_a_kind_of(String)
#           expect(field_instance.formula_expression).to be_a_kind_of(String).or be(nil)
#         end
#         expect(field_instance.is_currency_field).to be(true).or be(false)
#         if field_instance.is_currency_field
#           expect(field_instance.precision).to be_a_kind_of(Integer)
#           expect(field_instance.rounding_option).to be_a_kind_of(String)
#         end
#         expect(field_instance.id).to be_a_kind_of(String)
#         picklist_values = field_instance.picklist_values
#         picklist_values.each do |picklist_instance|
#           expect(picklist_instance.display_value).to be_a_kind_of(String)
#           expect(picklist_instance.sequence_number).to be_a_kind_of(Integer).or be(nil)
#           expect(picklist_instance.actual_value).to be_a_kind_of(String)
#           expect(picklist_instance.maps).to be_a_kind_of(String).or be(nil).or be_a_kind_of(Array)
#         end
#         expect(field_instance.is_auto_number).to be(true).or be(false)
#         if field_instance.is_auto_number
#           expect(field_instance.prefix).to be_a_kind_of(Integer).or be(nil)
#           expect(field_instance.suffix).to be_a_kind_of(Integer).or be(nil)
#           expect(field_instance.start_number).to be_a_kind_of(Integer).or be(nil)
#         end
#         expect(field_instance.is_business_card_supported).to be(true).or be(false)
#         expect(field_instance.field_layout_permissions).to be_a_kind_of(Array)
#         expect(field_instance.decimal_place).to be_a_kind_of(Integer).or be(nil)
#         if field_instance.api_name != 'file' && field_instance.api_name != 'Record_Image' && field_instance.api_name != 'Recurring_Activity' && field_instance.api_name != 'Remind_At'
#           expect(field_instance.json_type).to be_a_kind_of(String)
#         end
#       end
#     end
#   end
#   it 'get_layouts' do
#     modulevslayouts.each do |module_api_name, layout_array|
#       layout_array.each do |layout|
#         print "\n " + module_api_name + ': ' + layout.id
#         expect(layout.id).to be_a_kind_of(String)
#         expect(layout.name).to be_a_kind_of(String)
#         expect(layout.created_time).to be_a_kind_of(String).or be(nil)
#         expect(layout.modified_time).to be_a_kind_of(String).or be(nil)
#         expect(layout.is_visible).to be(true).or be(false)
#         unless layout.modified_by.nil?
#           expect(layout.modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#           expect(layout.modified_by.id).to be_a_kind_of(String)
#           expect(layout.modified_by.name).to be_a_kind_of(String)
#         end
#         unless layout.created_by.nil?
#           expect(layout.created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#           expect(layout.created_by.id).to be_a_kind_of(String)
#           expect(layout.created_by.name).to be_a_kind_of(String)
#         end
#         profiles = layout.accessible_profiles
#         profiles.each do |profile|
#           expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
#           expect(profile.is_default).to be(true).or be(false)
#           expect(profile.name).to be_a_kind_of(String)
#           expect(profile.id).to be_a_kind_of(String)
#         end
#         sections = layout.sections
#         sections.each do |section|
#           expect(section).to be_an_instance_of(ZCRMSDK::Operations::ZCRMSection)
#           expect(section.name).to be_a_kind_of(String)
#           expect(section.display_label).to be_a_kind_of(String)
#           expect(section.column_count).to be_a_kind_of(Integer)
#           expect(section.sequence_number).to be_a_kind_of(Integer)
#           fields = section.fields
#           fields.each do |field_instance|
#             expect(field_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMField)
#             expect(field_instance.api_name).to be_a_kind_of(String)
#             expect(field_instance.is_webhook).to be(true).or be(false)
#             expect(field_instance.crypt).to be(nil)
#             unless field_instance.tooltip.nil?
#               expect(field_instance.tooltip['name']).to be_a_kind_of(String)
#               expect(field_instance.tooltip['value']).to be_a_kind_of(String)
#             end
#             expect(field_instance.is_field_read_only).to be(true).or be(false)
#             expect(field_instance.association_details).to be(String).or be(nil)
#             expect(field_instance.subform).to be(nil)
#             multiselectlookup = field_instance.multiselectlookup
#             unless multiselectlookup.empty?
#               expect(multiselectlookup.display_label).to be_a_kind_of(String)
#               expect(multiselectlookup.linking_module).to be_a_kind_of(String)
#               expect(multiselectlookup.connected_module).to be_a_kind_of(String)
#               expect(multiselectlookup.api_name).to be_a_kind_of(String)
#               expect(multiselectlookup.id).to be_a_kind_of(String)
#             end
#             expect(field_instance.is_custom_field).to be(true).or be(false)
#             expect(field_instance.lookup_field).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLookupField).or be_a_kind_of(Hash)
#             expect(field_instance.is_visible).to be(true).or be(false)
#             expect(field_instance.field_label).to be_a_kind_of(String)
#             expect(field_instance.length).to be_a_kind_of(Integer)
#             expect(field_instance.created_source).to be_a_kind_of(String)
#             expect(field_instance.is_mandatory).to be(true).or be(false)
#             expect(field_instance.is_read_only).to be(true).or be(false)
#             expect(field_instance.is_unique_field).to be(true).or be(false)
#             expect(field_instance.is_case_sensitive).to be(true).or be(false)
#             expect(field_instance.data_type).to be_a_kind_of(String)
#             expect(field_instance.is_formula_field).to be(true).or be(false)
#             if field_instance.is_formula_field
#               expect(field_instance.formula_return_type).to be_a_kind_of(String)
#               expect(field_instance.formula_expression).to be_a_kind_of(String).or be(nil)
#             end
#             expect(field_instance.is_currency_field).to be(true).or be(false)
#             if field_instance.is_currency_field
#               expect(field_instance.precision).to be_a_kind_of(Integer)
#               expect(field_instance.rounding_option).to be_a_kind_of(String)
#             end
#             expect(field_instance.id).to be_a_kind_of(String)
#             picklist_values = field_instance.picklist_values
#             picklist_values.each do |picklist_instance|
#               expect(picklist_instance.display_value).to be_a_kind_of(String)
#               expect(picklist_instance.sequence_number).to be_a_kind_of(Integer).or be(nil)
#               expect(picklist_instance.actual_value).to be_a_kind_of(String)
#               expect(picklist_instance.maps).to be_a_kind_of(String).or be(nil).or be_a_kind_of(Array)
#             end
#             expect(field_instance.is_auto_number).to be(true).or be(false)
#             if field_instance.is_auto_number
#               expect(field_instance.prefix).to be_a_kind_of(Integer).or be(nil)
#               expect(field_instance.suffix).to be_a_kind_of(Integer).or be(nil)
#               expect(field_instance.start_number).to be_a_kind_of(Integer).or be(nil)
#             end
#             expect(field_instance.field_layout_permissions).to be_a_kind_of(Array)
#             expect(field_instance.decimal_place).to be_a_kind_of(Integer).or be(nil)
#             if field_instance.api_name != 'file' && field_instance.api_name != 'Record_Image' && field_instance.api_name != 'Recurring_Activity' && field_instance.api_name != 'Remind_At'
#               expect(field_instance.json_type).to be_a_kind_of(String)
#             end
#           end
#           expect(section.is_subform_section).to be(true).or be(false)
#           expect(section.tab_traversal).to be_a_kind_of(Integer)
#           expect(section.api_name).to be_a_kind_of(String)
#           properties = section.properties
#           next if properties.nil?

#           expect(properties.reorder_rows).to be(nil)
#           expect(properties.tooltip).to be(nil)
#           expect(properties.maximum_rows).to be(nil)
#         end
#         expect(layout.status).to be_a_kind_of(Integer)
#         expect(convert_mappings = layout.convert_mapping).to be_a_kind_of(Hash)
#         convert_mappings.each do |_key, convert_mapping|
#           expect(convert_mapping).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLeadConvertMapping)
#           expect(convert_mapping.name).to be_a_kind_of(String)
#           expect(convert_mapping.id).to be_a_kind_of(String)
#           convert_mapping_fields = convert_mapping.fields
#           next if convert_mapping_fields.nil?

#           convert_mapping_fields.each do |convert_mapping_field|
#             expect(convert_mapping_field).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLeadConvertMappingField)
#             expect(convert_mapping_field.id).to be_a_kind_of(String)
#             expect(convert_mapping_field.api_name).to be_a_kind_of(String)
#             expect(convert_mapping_field.field_label).to be_a_kind_of(String)
#             expect(convert_mapping_field.is_required).to be(true).or be(false)
#           end
#         end
#       end
#     end
#   end
#   it 'get_layout' do
#     moduleapinamevslayoutsidvsdata.each do |moduleapiname, layoutsidvsdata|
#       layoutsidvsdata.each do |layoutid, layout|
#         print "\n " + moduleapiname + ': ' + layoutid
#         expect(layout.id).to be_a_kind_of(String)
#         expect(layout.name).to be_a_kind_of(String)
#         expect(layout.created_time).to be_a_kind_of(String).or be(nil)
#         expect(layout.modified_time).to be_a_kind_of(String).or be(nil)
#         expect(layout.is_visible).to be(true).or be(false)
#         unless layout.modified_by.nil?
#           expect(layout.modified_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#           expect(layout.modified_by.id).to be_a_kind_of(String)
#           expect(layout.modified_by.name).to be_a_kind_of(String)
#         end
#         unless layout.created_by.nil?
#           expect(layout.created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#           expect(layout.created_by.id).to be_a_kind_of(String)
#           expect(layout.created_by.name).to be_a_kind_of(String)
#         end
#         profiles = layout.accessible_profiles
#         profiles.each do |profile|
#           expect(profile).to be_an_instance_of(ZCRMSDK::Operations::ZCRMProfile)
#           expect(profile.is_default).to be(true).or be(false)
#           expect(profile.name).to be_a_kind_of(String)
#           expect(profile.id).to be_a_kind_of(String)
#         end
#         sections = layout.sections
#         sections.each do |section|
#           expect(section).to be_an_instance_of(ZCRMSDK::Operations::ZCRMSection)
#           expect(section.name).to be_a_kind_of(String)
#           expect(section.display_label).to be_a_kind_of(String)
#           expect(section.column_count).to be_a_kind_of(Integer)
#           expect(section.sequence_number).to be_a_kind_of(Integer)
#           fields = section.fields
#           fields.each do |field_instance|
#             expect(field_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMField)
#             expect(field_instance.api_name).to be_a_kind_of(String)
#             expect(field_instance.is_webhook).to be(true).or be(false)
#             expect(field_instance.crypt).to be(nil)
#             unless field_instance.tooltip.nil?
#               expect(field_instance.tooltip['name']).to be_a_kind_of(String)
#               expect(field_instance.tooltip['value']).to be_a_kind_of(String)
#             end
#             expect(field_instance.is_field_read_only).to be(true).or be(false)
#             expect(field_instance.association_details).to be(String).or be(nil)
#             expect(field_instance.subform).to be(nil)
#             multiselectlookup = field_instance.multiselectlookup
#             unless multiselectlookup.empty?
#               expect(multiselectlookup.display_label).to be_a_kind_of(String)
#               expect(multiselectlookup.linking_module).to be_a_kind_of(String)
#               expect(multiselectlookup.connected_module).to be_a_kind_of(String)
#               expect(multiselectlookup.api_name).to be_a_kind_of(String)
#               expect(multiselectlookup.id).to be_a_kind_of(String)
#             end
#             expect(field_instance.is_custom_field).to be(true).or be(false)
#             expect(field_instance.lookup_field).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLookupField).or be_a_kind_of(Hash)
#             expect(field_instance.is_visible).to be(true).or be(false)
#             expect(field_instance.field_label).to be_a_kind_of(String)
#             expect(field_instance.length).to be_a_kind_of(Integer)
#             expect(field_instance.created_source).to be_a_kind_of(String)
#             expect(field_instance.is_mandatory).to be(true).or be(false)
#             expect(field_instance.is_read_only).to be(true).or be(false)
#             expect(field_instance.is_unique_field).to be(true).or be(false)
#             expect(field_instance.is_case_sensitive).to be(true).or be(false)
#             expect(field_instance.data_type).to be_a_kind_of(String)
#             expect(field_instance.is_formula_field).to be(true).or be(false)
#             if field_instance.is_formula_field
#               expect(field_instance.formula_return_type).to be_a_kind_of(String)
#               expect(field_instance.formula_expression).to be_a_kind_of(String).or be(nil)
#             end
#             expect(field_instance.is_currency_field).to be(true).or be(false)
#             if field_instance.is_currency_field
#               expect(field_instance.precision).to be_a_kind_of(Integer)
#               expect(field_instance.rounding_option).to be_a_kind_of(String)
#             end
#             expect(field_instance.id).to be_a_kind_of(String)
#             picklist_values = field_instance.picklist_values
#             picklist_values.each do |picklist_instance|
#               expect(picklist_instance.display_value).to be_a_kind_of(String)
#               expect(picklist_instance.sequence_number).to be_a_kind_of(Integer).or be(nil)
#               expect(picklist_instance.actual_value).to be_a_kind_of(String)
#               expect(picklist_instance.maps).to be_a_kind_of(String).or be(nil).or be_a_kind_of(Array)
#             end
#             expect(field_instance.is_auto_number).to be(true).or be(false)
#             if field_instance.is_auto_number
#               expect(field_instance.prefix).to be_a_kind_of(Integer).or be(nil)
#               expect(field_instance.suffix).to be_a_kind_of(Integer).or be(nil)
#               expect(field_instance.start_number).to be_a_kind_of(Integer).or be(nil)
#             end
#             expect(field_instance.field_layout_permissions).to be_a_kind_of(Array)
#             expect(field_instance.decimal_place).to be_a_kind_of(Integer).or be(nil)
#             if field_instance.api_name != 'file' && field_instance.api_name != 'Record_Image' && field_instance.api_name != 'Recurring_Activity' && field_instance.api_name != 'Remind_At'
#               expect(field_instance.json_type).to be_a_kind_of(String)
#             end
#           end
#           expect(section.is_subform_section).to be(true).or be(false)
#           expect(section.tab_traversal).to be_a_kind_of(Integer)
#           expect(section.api_name).to be_a_kind_of(String)
#           properties = section.properties
#           next if properties.nil?

#           expect(properties.reorder_rows).to be(nil)
#           expect(properties.tooltip).to be(nil)
#           expect(properties.maximum_rows).to be(nil)
#         end
#         expect(layout.status).to be_a_kind_of(Integer)
#         expect(convert_mappings = layout.convert_mapping).to be_a_kind_of(Hash)
#         convert_mappings.each do |_key, convert_mapping|
#           expect(convert_mapping).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLeadConvertMapping)
#           expect(convert_mapping.name).to be_a_kind_of(String)
#           expect(convert_mapping.id).to be_a_kind_of(String)
#           convert_mapping_fields = convert_mapping.fields
#           next if convert_mapping_fields.nil?

#           convert_mapping_fields.each do |convert_mapping_field|
#             expect(convert_mapping_field).to be_an_instance_of(ZCRMSDK::Operations::ZCRMLeadConvertMappingField)
#             expect(convert_mapping_field.id).to be_a_kind_of(String)
#             expect(convert_mapping_field.api_name).to be_a_kind_of(String)
#             expect(convert_mapping_field.field_label).to be_a_kind_of(String)
#             expect(convert_mapping_field.is_required).to be(true).or be(false)
#           end
#         end
#       end
#     end
#   end
#   it 'get_custom_views' do
#     modulevscustomviews.each do |module_api_name, custom_view_array|
#       custom_view_array.each do |cv_ins|
#         print "\n " + module_api_name + ': ' + cv_ins.id
#         expect(cv_ins.id).to be_a_kind_of(String)
#         expect(cv_ins.display_value).to be_a_kind_of(String)
#         expect(cv_ins.is_default).to be(true).or be(false)
#         expect(cv_ins.name).to be_a_kind_of(String)
#         if cv_ins.is_system_defined
#           expect(cv_ins.system_name).to be_a_kind_of(String)
#         else
#           expect(cv_ins.system_name).to be(nil)
#         end
#         expect(cv_ins.is_system_defined).to be(true).or be(false)
#         expect(cv_ins.category).to be_a_kind_of(String)
#         expect(cv_ins.is_off_line).to be(true).or be(false)
#       end
#     end
#   end
#   it 'get_custom_view' do
#     moduleapinamevscustomviewsidvsdata.each do |moduleapiname, customviewsidvsdata|
#       customviewsidvsdata.each do |customviewid, cv_ins|
#         print "\n " + moduleapiname + ': ' + customviewid
#         expect(cv_ins.id).to be_a_kind_of(String)
#         expect(cv_ins.display_value).to be_a_kind_of(String)
#         expect(cv_ins.is_default).to be(true).or be(false)
#         expect(cv_ins.name).to be_a_kind_of(String)
#         if cv_ins.is_system_defined
#           expect(cv_ins.system_name).to be_a_kind_of(String)
#         else
#           expect(cv_ins.system_name).to be(nil)
#         end
#         expect(cv_ins.is_system_defined).to be(true).or be(false)
#         expect(cv_ins.category).to be_a_kind_of(String)
#         expect(cv_ins.is_off_line).to be(true).or be(false)
#         expect(cv_ins.shared_details).to be(true).or be(false).or be(nil).or be_a_kind_of(Array)
#         expect(cv_ins.sort_by).to be_a_kind_of(String).or be(nil)
#         expect(cv_ins.fields).to be_a_kind_of(Array).or be(nil)
#         expect(cv_ins.favorite).to be(nil)
#         expect(cv_ins.sort_order).to be_a_kind_of(String).or be(nil)
#         cv_criteria = cv_ins.criteria
#         next if cv_criteria.nil?

#         expect(cv_ins.criteria_condition).to be_a_kind_of(String)
#         expect(cv_criteria).to be_an_instance_of(ZCRMSDK::Operations::ZCRMCustomViewCriteria)
#         if !cv_criteria.group_operator.nil?
#           expect(cv_criteria.group_operator).to be_a_kind_of(String)
#           expect(cv_criteria.group).to be_a_kind_of(Array)
#         else
#           expect(cv_criteria.comparator).to be_a_kind_of(String)
#           expect(cv_criteria.field).to be_a_kind_of(String)
#           expect(cv_criteria.value).to be_a_kind_of(String).or be(false).or be(true).or be_a_kind_of(Integer)
#         end
#         expect(cv_criteria.index).to be_a_kind_of(Integer).or be(nil)
#         expect(cv_criteria.criteria).to be_a_kind_of(String)
#       end
#     end
#   end
#   it 'get_related_lists' do
#     modulevsrelatedlists.each do |module_api_name, related_lists_array|
#       related_lists_array.each do |relatedlist_ins|
#         print "\n " + module_api_name + ': ' + relatedlist_ins.id
#         expect(relatedlist_ins.api_name).to be_a_kind_of(String)
#         expect(relatedlist_ins.id).to be_a_kind_of(String)
#         expect(relatedlist_ins.module_apiname).to be_a_kind_of(String).or be(nil)
#         expect(relatedlist_ins.display_label).to be_a_kind_of(String)
#         expect(relatedlist_ins.name).to be_a_kind_of(String)
#         expect(relatedlist_ins.type).to be_a_kind_of(String)
#         expect(relatedlist_ins.href).to be_a_kind_of(String).or be(nil)
#         expect(relatedlist_ins.action).to be(nil)
#         expect(relatedlist_ins.sequence_number).to be_a_kind_of(String)
#       end
#     end
#   end
#   it 'get_related_list' do
#     moduleapinamevsrelatedlistsidvsdata.each do |moduleapiname, relatedlistsidvsdata|
#       relatedlistsidvsdata.each do |relatedlistid, relatedlist_ins|
#         print "\n " + moduleapiname + ': ' + relatedlistid
#         expect(relatedlist_ins.api_name).to be_a_kind_of(String)
#         expect(relatedlist_ins.id).to be_a_kind_of(String)
#         expect(relatedlist_ins.module_apiname).to be_a_kind_of(String).or be(nil)
#         expect(relatedlist_ins.display_label).to be_a_kind_of(String)
#         expect(relatedlist_ins.name).to be_a_kind_of(String)
#         expect(relatedlist_ins.type).to be_a_kind_of(String)
#         expect(relatedlist_ins.href).to be_a_kind_of(String).or be(nil)
#         expect(relatedlist_ins.action).to be(nil)
#         expect(relatedlist_ins.sequence_number).to be_a_kind_of(String)
#       end
#     end
#   end
#   it 'create record' do # create() and get_record(record_id)
#     creatable_module_api_names.each do |creatable_module_api_name|
#       iterator = 0
#       created_record[creatable_module_api_name].each do |record|
#         expect(record).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#         owner = record.owner
#         expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(owner.id).to eql(current_user_id)
#         expect(owner.name).to eql(current_user_name)
#         created_by = record.created_by
#         expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(created_by.id).to eql(current_user_id)
#         expect(created_by.name).to eql(current_user_name)
#         expect(record.created_time).to be_a_kind_of(String)
#         expect(record.modified_time).to be_a_kind_of(String)
#         expect(record.properties).to be_a_kind_of(Hash)
#         moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           lookup_ins = field_details['lookup']
#           if fieldlabel == 'Call Duration'
#             expect(record.field_data[field_api_name]).to eql('10:00')
#           elsif field_api_name == 'Remind_At'
#             if creatable_module_api_name == 'Events'
#               expect(record.field_data[field_api_name]).to eql('2019-06-14T05:30:00+05:30')
#             else
#               expect(record.field_data[field_api_name]['ALARM']).to eql('FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30')
#             end
#           elsif field_api_name == 'Recurring_Activity'
#             if creatable_module_api_name == 'Events'
#               expect(record.field_data[field_api_name]['RRULE']).to eql('FREQ=YEARLY;INTERVAL=99;UNTIL=2029-06-12;BYMONTH=6;BYMONTHDAY=15;DTSTART=2019-06-15')
#             else
#               expect(record.field_data[field_api_name]['RRULE']).to eql('FREQ=DAILY;INTERVAL=99;UNTIL=2017-08-29;DTSTART=2017-08-29')
#             end
#           elsif field_api_name == 'Parent_Campaign' && iterator != 0
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Campaign')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][0].entity_id)
#           elsif field_api_name == 'Reporting_To' && iterator != 0
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Reporting_To')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'Vendor_Name' && creatable_module_api_name != 'Vendors'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Vendor_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Vendors'][0].entity_id)
#           elsif field_api_name == 'Product_Name'  && creatable_module_api_name != 'Products'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Product_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Products'][0].entity_id)
#           elsif field_api_name == 'Account_Name'  && creatable_module_api_name != 'Accounts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Account_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][0].entity_id)
#           elsif field_api_name == 'Parent_Account' && iterator != 0
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Account')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][0].entity_id)
#           elsif field_api_name == 'Related_To' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Related_To')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'Who_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Who_Id')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'What_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('What_Id')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][0].entity_id)
#           elsif field_api_name == 'Contact_Name' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Contact_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'Campaign_Source' && creatable_module_api_name != 'Campaigns'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Campaign_Source')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][0].entity_id)
#           elsif field_api_name == 'Deal_Name' && creatable_module_api_name != 'Deals'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Deal_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Deals'][0].entity_id)
#           elsif field_api_name == 'Quote_Name' && creatable_module_api_name != 'Quotes'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Quote_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Quotes'][0].entity_id)
#           elsif field_api_name == 'Sales_Order' && creatable_module_api_name != 'Sales_Orders'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Sales_Order')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Sales_Orders'][0].entity_id)
#           elsif field_api_name == 'Product_Details'
#             line_items = record.line_items
#             if %w[Quotes Sales_Orders Purchase_Orders Invoices].include?(creatable_module_api_name)
#               line_items.each do |line_item|
#                 expect(line_item).to be_an_instance_of(ZCRMSDK::Operations::ZCRMInventoryLineItem)
#                 product = line_item.product
#                 expect(product).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#                 expect(product.module_api_name).to eql('Products')
#                 expect(product.entity_id).to eql(created_record['Products'][0].entity_id)
#                 expect(product.lookup_label).to be_a_kind_of(String)
#                 expect(product.field_data['Product_Code']).to be_a_kind_of(String)
#                 expect(line_item.list_price).to eql(123.0)
#                 expect(line_item.quantity).to eql(10)
#                 expect(line_item.description).to eql('ruby_automation_lineitem')
#                 expect(line_item.total).to eql(1230.0)
#                 expect(line_item.discount).to eql(10.0)
#                 expect(line_item.total_after_discount).to eql(1220.0)
#                 expect(line_item.tax_amount).to eql(122.0)
#                 expect(line_item.net_total).to eql(1342.0)
#                 expect(line_item.delete_flag).to be(false)
#                 line_taxes = line_item.line_tax
#                 line_taxes.each do |line_tax|
#                   expect(line_tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#                   expect(line_tax.name).to eql('record_tax')
#                   expect(line_tax.percentage).to eql(10)
#                   expect(line_tax.value).to eql(122.0)
#                 end
#               end
#             end
#           elsif field_api_name == 'Participants'
#             participants = record.participants
#             participants.each do |participant|
#               expect(participant.id).to eql(current_user_id)
#               expect(participant.type).to eql('user')
#               expect(participant.name).to eql(current_user.full_name)
#               expect(participant.email).to eql(current_user.email)
#               expect(participant.is_invited).to be(false)
#               expect(participant.status).to eql('not_known')
#             end
#           elsif field_api_name == 'Tag'
#             tags = record.tag_list
#             tags.each do |tag|
#               expect(tag).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTag)
#               expect(tag.id).to be_a_kind_of(String)
#               expect(tag.name).to eql('ruby_automation_tag1')
#             end
#           elsif field_api_name == 'Tax'
#             tax_list = record.tax_list
#             tax_list.each do |tax|
#               expect(tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#               expect(tax.name).to eql('record_tax')
#             end
#           elsif field_api_name == 'Pricing_Details'
#             if creatable_module_api_name == 'Price_books'
#               pricing_instances = record.price_details
#               pricing_instances.each do |pricing_instance|
#                 expect(pricing_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMPriceBookPricing)
#                 expect(pricing_instance.id).to be_a_kind_of(String)
#                 expect(pricing_instance.discount).to eql(5.0)
#                 expect(pricing_instance.to_range).to eql(100.0)
#                 expect(pricing_instance.from_range).to eql(1.0)
#               end
#             end
#           elsif field_api_name == 'Start_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-14T00:00:00+00:00')
#           elsif field_api_name == 'End_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T23:59:59+00:00')
#           elsif datatype == 'text'
#             word = iterator.to_s + '1234567890'
#             word = word[0, length - 1]
#             expect(record.field_data[field_api_name]).to eql(word)
#           elsif datatype == 'picklist' && creatable_module_api_name != 'Calls'
#             if field_details['picklist'].length > 1
#               if field_details['picklist'][1].display_value == '-None-'
#                 expect(record.field_data[field_api_name]).to be(nil)
#               else
#                 expect(record.field_data[field_api_name]).to eql(field_details['picklist'][1].display_value)
#               end
#             elsif
#               expect(record.field_data[field_api_name]).to eql(field_details['picklist'][0].display_value)
#             end
#           elsif datatype == 'multiselectpicklist'
#             expect(record.field_data[field_api_name]).to eql([field_details['picklist'][0].display_value])
#           elsif datatype == 'email'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + 'rubysdk+automation@zoho.com')
#           elsif datatype == 'fileupload'
#           #      record.field_data[field_api_name]=[{"file_id"=>fileid}]
#           elsif datatype == 'website'
#             expect(record.field_data[field_api_name]).to eql('www.zoho.com')
#           elsif datatype == 'integer'
#             expect(record.field_data[field_api_name]).to eql(123)
#           elsif datatype == 'bigint'
#             expect(record.field_data[field_api_name]).to eql('123')
#           elsif datatype == 'phone'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + '123')
#           elsif datatype == 'currency'
#             expect(record.field_data[field_api_name]).to be_a_kind_of(Integer).or be_a_kind_of(Float)
#           elsif datatype == 'boolean'
#             expect(record.field_data[field_api_name]).to be(true)
#           elsif datatype == 'date'
#             expect(record.field_data[field_api_name]).to eql('2019-07-11').or eql('2017-08-29')
#           elsif datatype == 'double'
#             expect(record.field_data[field_api_name]).to eql(2.1)
#           elsif datatype == 'textarea'
#             expect(record.field_data[field_api_name]).to eql('ruby_automation_at_work')
#           elsif datatype == 'datetime'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T15:53:00+05:30')
#            end
#         end
#         iterator += 1
#       end
#     end
#   end
#   it 'update record' do # update() and get_record(record_id)
#     creatable_module_api_names.each do |creatable_module_api_name|
#       iterator = record_count
#       updated_record[creatable_module_api_name].each do |record|
#         expect(record).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#         owner = record.owner
#         expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(owner.id).to eql(current_user_id)
#         expect(owner.name).to eql(current_user_name)
#         created_by = record.created_by
#         expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(created_by.id).to eql(current_user_id)
#         expect(created_by.name).to eql(current_user_name)
#         expect(record.created_time).to be_a_kind_of(String)
#         expect(record.modified_time).to be_a_kind_of(String)
#         expect(record.properties).to be_a_kind_of(Hash)
#         moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           lookup_ins = field_details['lookup']
#           if fieldlabel == 'Call Duration'
#             expect(record.field_data[field_api_name]).to eql('20:00')
#           elsif field_api_name == 'Remind_At'
#             if creatable_module_api_name == 'Events'
#               expect(record.field_data[field_api_name]).to eql('2019-06-15T05:30:00+05:30')
#             else
#               expect(record.field_data[field_api_name]['ALARM']).to eql('FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30')
#             end
#           elsif field_api_name == 'Recurring_Activity'
#             if creatable_module_api_name == 'Events'
#               expect(record.field_data[field_api_name]['RRULE']).to eql('FREQ=YEARLY;INTERVAL=99;UNTIL=2029-06-12;BYMONTH=6;BYMONTHDAY=15;DTSTART=2019-06-15')
#             else
#               expect(record.field_data[field_api_name]['RRULE']).to eql('FREQ=YEARLY;INTERVAL=1;UNTIL=2016-12-01;BYMONTH=11;BYMONTHDAY=14;DTSTART=2016-10-30')
#             end
#           elsif field_api_name == 'Parent_Campaign' && iterator != record_count
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Campaign')
#             expect(record.field_data[field_api_name].name).to eql('31234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][0].entity_id)
#           elsif field_api_name == 'Reporting_To' && iterator != record_count
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Reporting_To')
#             if iterator == record_count + 1
#               expect(record.field_data[field_api_name].name).to eql('31234567890 31234567890')
#             elsif iterator == record_count + 1
#               expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             end
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][iterator - 4].entity_id)
#           elsif field_api_name == 'Vendor_Name' && creatable_module_api_name != 'Vendors'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Vendor_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Vendors'][1].entity_id)
#           elsif field_api_name == 'Product_Name'  && creatable_module_api_name != 'Products'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Product_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Products'][1].entity_id)
#           elsif field_api_name == 'Account_Name'  && creatable_module_api_name != 'Accounts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Account_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Parent_Account' && iterator != 3
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Account')
#             if iterator == 4
#               expect(record.field_data[field_api_name].name).to eql('31234567890')
#             elsif iterator == 5
#               expect(record.field_data[field_api_name].name).to eql('41234567890')
#             end
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][iterator - 4].entity_id)
#           elsif field_api_name == 'Related_To' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Related_To')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Who_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Who_Id')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'What_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('What_Id')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Contact_Name' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Contact_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Campaign_Source' && creatable_module_api_name != 'Campaigns'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Campaign_Source')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][1].entity_id)
#           elsif field_api_name == 'Deal_Name' && creatable_module_api_name != 'Deals'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Deal_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Deals'][1].entity_id)
#           elsif field_api_name == 'Quote_Name' && creatable_module_api_name != 'Quotes'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Quote_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Quotes'][1].entity_id)
#           elsif field_api_name == 'Sales_Order' && creatable_module_api_name != 'Sales_Orders'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Sales_Order')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Sales_Orders'][1].entity_id)
#           elsif field_api_name == 'Product_Details'
#             line_items = record.line_items
#             if %w[Quotes Sales_Orders Purchase_Orders Invoices].include?(creatable_module_api_name)
#               line_items.each do |line_item|
#                 expect(line_item).to be_an_instance_of(ZCRMSDK::Operations::ZCRMInventoryLineItem)
#                 product = line_item.product
#                 expect(product).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#                 expect(product.module_api_name).to eql('Products')
#                 expect(product.entity_id).to eql(created_record['Products'][1].entity_id)
#                 expect(product.lookup_label).to be_a_kind_of(String)
#                 expect(product.field_data['Product_Code']).to be_a_kind_of(String)
#                 expect(line_item.list_price).to eql(246.0)
#                 expect(line_item.quantity).to eql(20)
#                 expect(line_item.description).to eql('ruby_update_automation_lineitem')
#                 expect(line_item.total).to eql(4920.0)
#                 expect(line_item.discount).to eql(20.0)
#                 expect(line_item.total_after_discount).to eql(4900.0)
#                 expect(line_item.tax_amount).to eql(490.0)
#                 expect(line_item.net_total).to eql(5390.0)
#                 expect(line_item.delete_flag).to be(false)
#                 line_taxes = line_item.line_tax
#                 line_taxes.each do |line_tax|
#                   expect(line_tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#                   expect(line_tax.name).to eql('record_tax')
#                   expect(line_tax.percentage).to eql(10)
#                   expect(line_tax.value).to eql(490.0)
#                 end
#               end
#             end
#           elsif field_api_name == 'Participants'
#             participants = record.participants
#             participants.each do |participant|
#               expect(participant.id).to eql(current_user_id)
#               expect(participant.type).to eql('user')
#               expect(participant.name).to eql(current_user.full_name)
#               expect(participant.email).to eql(current_user.email)
#               expect(participant.is_invited).to be(false)
#               expect(participant.status).to eql('not_known')
#             end
#           elsif field_api_name == 'Tag'
#             tags = record.tag_list
#             tags.each do |tag|
#               expect(tag).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTag)
#               expect(tag.id).to be_a_kind_of(String)
#               expect(tag.name).to eql('ruby_automation_tag1')
#             end
#           elsif field_api_name == 'Tax'
#             tax_list = record.tax_list
#             tax_list.each do |tax|
#               expect(tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#               expect(tax.name).to eql('record_tax')
#             end
#           elsif field_api_name == 'Pricing_Details'
#             if creatable_module_api_name == 'Price_books'
#               pricing_instances = record.price_details
#               pricing_instances.each do |pricing_instance|
#                 expect(pricing_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMPriceBookPricing)
#                 expect(pricing_instance.id).to be_a_kind_of(String)
#                 expect(pricing_instance.discount).to eql(10.0)
#                 expect(pricing_instance.to_range).to eql(200.0)
#                 expect(pricing_instance.from_range).to eql(2.0)
#               end
#             end
#           elsif field_api_name == 'Start_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T00:00:00+00:00')
#           elsif field_api_name == 'End_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T23:59:59+00:00')
#           elsif datatype == 'text'
#             word = iterator.to_s + '1234567890'
#             word = word[0, length - 1]
#             expect(record.field_data[field_api_name]).to eql(word)
#           elsif datatype == 'picklist' && creatable_module_api_name != 'Calls'
#             if field_details['picklist'].length > 1
#               if field_details['picklist'][1].display_value == '-None-'
#                 expect(record.field_data[field_api_name]).to be(nil)
#               else
#                 expect(record.field_data[field_api_name]).to eql(field_details['picklist'][1].display_value)
#               end
#             elsif
#               expect(record.field_data[field_api_name]).to eql(field_details['picklist'][0].display_value)
#             end
#           elsif datatype == 'multiselectpicklist'
#             expect(record.field_data[field_api_name]).to eql([field_details['picklist'][0].display_value])
#           elsif datatype == 'email'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + 'rubysdk+automation@zoho.com')
#           elsif datatype == 'fileupload'
#           #      record.field_data[field_api_name]=[{"file_id"=>fileid}]
#           elsif datatype == 'website'
#             expect(record.field_data[field_api_name]).to eql('www.zoho.com')
#           elsif datatype == 'integer'
#             expect(record.field_data[field_api_name]).to eql(123)
#           elsif datatype == 'bigint'
#             expect(record.field_data[field_api_name]).to eql('123')
#           elsif datatype == 'phone'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + '123')
#           elsif datatype == 'currency'
#             expect(record.field_data[field_api_name]).to be_a_kind_of(Integer).or be_a_kind_of(Float)
#           elsif datatype == 'boolean'
#             expect(record.field_data[field_api_name]).to be(true)
#           elsif datatype == 'date'
#             expect(record.field_data[field_api_name]).to eql('2016-11-14').or eql('2019-08-11')
#           elsif datatype == 'double'
#             expect(record.field_data[field_api_name]).to eql(2.1)
#           elsif datatype == 'textarea'
#             expect(record.field_data[field_api_name]).to eql('ruby_updation_at_work')
#           elsif datatype == 'datetime'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T15:53:00+05:30')
#            end
#         end
#         iterator += 1
#       end
#     end
#   end
#   it 'create_records' do # create_records() and get_record(record_id)
#     creatable_module_api_names.each do |creatable_module_api_name|
#       iterator = record_count * 2
#       created_records[creatable_module_api_name].each do |record|
#         expect(record).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#         owner = record.owner
#         expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(owner.id).to eql(current_user_id)
#         expect(owner.name).to eql(current_user_name)
#         created_by = record.created_by
#         expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(created_by.id).to eql(current_user_id)
#         expect(created_by.name).to eql(current_user_name)
#         expect(record.created_time).to be_a_kind_of(String)
#         expect(record.modified_time).to be_a_kind_of(String)
#         expect(record.properties).to be_a_kind_of(Hash)
#         moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           lookup_ins = field_details['lookup']
#           if fieldlabel == 'Call Duration'
#             expect(record.field_data[field_api_name]).to eql('10:00')
#           elsif field_api_name == 'Remind_At'
#             if creatable_module_api_name == 'Events'
#               expect(record.field_data[field_api_name]).to eql('2019-06-15T05:30:00+05:30')
#             else
#               expect(record.field_data[field_api_name]['ALARM']).to eql('FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30')
#             end
#           elsif field_api_name == 'Parent_Campaign'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Campaign')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][0].entity_id)
#           elsif field_api_name == 'Reporting_To'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Reporting_To')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'Vendor_Name' && creatable_module_api_name != 'Vendors'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Vendor_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Vendors'][0].entity_id)
#           elsif field_api_name == 'Product_Name'  && creatable_module_api_name != 'Products'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Product_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Products'][0].entity_id)
#           elsif field_api_name == 'Account_Name'  && creatable_module_api_name != 'Accounts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Account_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][0].entity_id)
#           elsif field_api_name == 'Parent_Account'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Account')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][0].entity_id)
#           elsif field_api_name == 'Related_To' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Related_To')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'Who_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Who_Id')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'What_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('What_Id')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][0].entity_id)
#           elsif field_api_name == 'Contact_Name' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Contact_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890 01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][0].entity_id)
#           elsif field_api_name == 'Campaign_Source' && creatable_module_api_name != 'Campaigns'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Campaign_Source')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][0].entity_id)
#           elsif field_api_name == 'Deal_Name' && creatable_module_api_name != 'Deals'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Deal_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Deals'][0].entity_id)
#           elsif field_api_name == 'Quote_Name' && creatable_module_api_name != 'Quotes'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Quote_Name')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Quotes'][0].entity_id)
#           elsif field_api_name == 'Sales_Order' && creatable_module_api_name != 'Sales_Orders'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Sales_Order')
#             expect(record.field_data[field_api_name].name).to eql('01234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Sales_Orders'][0].entity_id)
#           elsif field_api_name == 'Product_Details'
#             line_items = record.line_items
#             if %w[Quotes Sales_Orders Purchase_Orders Invoices].include?(creatable_module_api_name)
#               line_items.each do |line_item|
#                 expect(line_item).to be_an_instance_of(ZCRMSDK::Operations::ZCRMInventoryLineItem)
#                 product = line_item.product
#                 expect(product).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#                 expect(product.module_api_name).to eql('Products')
#                 expect(product.entity_id).to eql(created_record['Products'][0].entity_id)
#                 expect(product.lookup_label).to be_a_kind_of(String)
#                 expect(product.field_data['Product_Code']).to be_a_kind_of(String)
#                 expect(line_item.list_price).to eql(123.0)
#                 expect(line_item.quantity).to eql(10)
#                 expect(line_item.description).to eql('ruby_automation_lineitem')
#                 expect(line_item.total).to eql(1230.0)
#                 expect(line_item.discount).to eql(10.0)
#                 expect(line_item.total_after_discount).to eql(1220.0)
#                 expect(line_item.tax_amount).to eql(122.0)
#                 expect(line_item.net_total).to eql(1342.0)
#                 expect(line_item.delete_flag).to be(false)
#                 line_taxes = line_item.line_tax
#                 line_taxes.each do |line_tax|
#                   expect(line_tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#                   expect(line_tax.name).to eql('record_tax')
#                   expect(line_tax.percentage).to eql(10)
#                   expect(line_tax.value).to eql(122.0)
#                 end
#               end
#             end
#           elsif field_api_name == 'Participants'
#             participants = record.participants
#             participants.each do |participant|
#               expect(participant.id).to eql(current_user_id)
#               expect(participant.type).to eql('user')
#               expect(participant.name).to eql(current_user.full_name)
#               expect(participant.email).to eql(current_user.email)
#               expect(participant.is_invited).to be(false)
#               expect(participant.status).to eql('not_known')
#             end
#           elsif field_api_name == 'Tag'
#             tags = record.tag_list
#             tags.each do |tag|
#               expect(tag).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTag)
#               expect(tag.id).to be_a_kind_of(String)
#               expect(tag.name).to eql('ruby_automation_tag1')
#             end
#           elsif field_api_name == 'Tax'
#             tax_list = record.tax_list
#             tax_list.each do |tax|
#               expect(tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#               expect(tax.name).to eql('record_tax')
#             end
#           elsif field_api_name == 'Pricing_Details'
#             if creatable_module_api_name == 'Price_books'
#               pricing_instances = record.price_details
#               pricing_instances.each do |pricing_instance|
#                 expect(pricing_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMPriceBookPricing)
#                 expect(pricing_instance.id).to be_a_kind_of(String)
#                 expect(pricing_instance.discount).to eql(5.0)
#                 expect(pricing_instance.to_range).to eql(100.0)
#                 expect(pricing_instance.from_range).to eql(1.0)
#               end
#             end
#           elsif field_api_name == 'Start_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T00:00:00+00:00')
#           elsif field_api_name == 'End_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T23:59:59+00:00')
#           elsif datatype == 'text'
#             word = iterator.to_s + '1234567890'
#             word = word[0, length - 1]
#             expect(record.field_data[field_api_name]).to eql(word)
#           elsif datatype == 'picklist' && creatable_module_api_name != 'Calls'
#             if field_details['picklist'].length > 1
#               if field_details['picklist'][1].display_value == '-None-'
#                 expect(record.field_data[field_api_name]).to be(nil)
#               else
#                 expect(record.field_data[field_api_name]).to eql(field_details['picklist'][1].display_value)
#               end
#             elsif
#               expect(record.field_data[field_api_name]).to eql(field_details['picklist'][0].display_value)
#             end
#           elsif datatype == 'multiselectpicklist'
#             expect(record.field_data[field_api_name]).to eql([field_details['picklist'][0].display_value])
#           elsif datatype == 'email'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + 'rubysdk+automation@zoho.com')
#           elsif datatype == 'fileupload'
#           #      record.field_data[field_api_name]=[{"file_id"=>fileid}]
#           elsif datatype == 'website'
#             expect(record.field_data[field_api_name]).to eql('www.zoho.com')
#           elsif datatype == 'integer'
#             expect(record.field_data[field_api_name]).to eql(123)
#           elsif datatype == 'bigint'
#             expect(record.field_data[field_api_name]).to eql('123')
#           elsif datatype == 'phone'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + '123')
#           elsif datatype == 'currency'
#             expect(record.field_data[field_api_name]).to be_a_kind_of(Integer).or be_a_kind_of(Float)
#           elsif datatype == 'boolean'
#             expect(record.field_data[field_api_name]).to be(true)
#           elsif datatype == 'date'
#             expect(record.field_data[field_api_name]).to eql('2019-07-11').or eql('2017-08-29')
#           elsif datatype == 'double'
#             expect(record.field_data[field_api_name]).to eql(2.1)
#           elsif datatype == 'textarea'
#             expect(record.field_data[field_api_name]).to eql('ruby_automation_at_work')
#           elsif datatype == 'datetime'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T15:53:00+05:30')
#            end
#         end
#         iterator += 1
#       end
#     end
#   end
#   it 'update_records' do # update_records() and get_record(record_id)
#     creatable_module_api_names.each do |creatable_module_api_name|
#       iterator = record_count * 3
#       updated_records[creatable_module_api_name].each do |record|
#         expect(record).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#         owner = record.owner
#         expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(owner.id).to eql(current_user_id)
#         expect(owner.name).to eql(current_user_name)
#         created_by = record.created_by
#         expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(created_by.id).to eql(current_user_id)
#         expect(created_by.name).to eql(current_user_name)
#         expect(record.created_time).to be_a_kind_of(String)
#         expect(record.modified_time).to be_a_kind_of(String)
#         expect(record.properties).to be_a_kind_of(Hash)
#         moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           lookup_ins = field_details['lookup']
#           if fieldlabel == 'Call Duration'
#             expect(record.field_data[field_api_name]).to eql('20:00')
#           elsif field_api_name == 'Remind_At'
#             if creatable_module_api_name == 'Events'
#               expect(record.field_data[field_api_name]).to eql('2019-06-15T05:30:00+05:30')
#             else
#               expect(record.field_data[field_api_name]['ALARM']).to eql('FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30')
#             end
#           elsif field_api_name == 'Parent_Campaign'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Campaign')
#             expect(record.field_data[field_api_name].name).to eql('31234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][0].entity_id)
#           elsif field_api_name == 'Reporting_To'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Reporting_To')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Vendor_Name' && creatable_module_api_name != 'Vendors'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Vendor_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Vendors'][1].entity_id)
#           elsif field_api_name == 'Product_Name'  && creatable_module_api_name != 'Products'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Product_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Products'][1].entity_id)
#           elsif field_api_name == 'Account_Name'  && creatable_module_api_name != 'Accounts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Account_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Parent_Account' && iterator != 3
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Account')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Related_To' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Related_To')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Who_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Who_Id')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'What_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('What_Id')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Contact_Name' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Contact_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Campaign_Source' && creatable_module_api_name != 'Campaigns'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Campaign_Source')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][1].entity_id)
#           elsif field_api_name == 'Deal_Name' && creatable_module_api_name != 'Deals'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Deal_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Deals'][1].entity_id)
#           elsif field_api_name == 'Quote_Name' && creatable_module_api_name != 'Quotes'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Quote_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Quotes'][1].entity_id)
#           elsif field_api_name == 'Sales_Order' && creatable_module_api_name != 'Sales_Orders'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Sales_Order')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Sales_Orders'][1].entity_id)
#           elsif field_api_name == 'Product_Details'
#             line_items = record.line_items
#             if %w[Quotes Sales_Orders Purchase_Orders Invoices].include?(creatable_module_api_name)
#               line_items.each do |line_item|
#                 expect(line_item).to be_an_instance_of(ZCRMSDK::Operations::ZCRMInventoryLineItem)
#                 product = line_item.product
#                 expect(product).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#                 expect(product.module_api_name).to eql('Products')
#                 expect(product.entity_id).to eql(created_record['Products'][1].entity_id)
#                 expect(product.lookup_label).to be_a_kind_of(String)
#                 expect(product.field_data['Product_Code']).to be_a_kind_of(String)
#                 expect(line_item.list_price).to eql(246.0)
#                 expect(line_item.quantity).to eql(20)
#                 expect(line_item.description).to eql('ruby_update_automation_lineitem')
#                 expect(line_item.total).to eql(4920.0)
#                 expect(line_item.discount).to eql(20.0)
#                 expect(line_item.total_after_discount).to eql(4900.0)
#                 expect(line_item.tax_amount).to eql(490.0)
#                 expect(line_item.net_total).to eql(5390.0)
#                 expect(line_item.delete_flag).to be(false)
#                 line_taxes = line_item.line_tax
#                 line_taxes.each do |line_tax|
#                   expect(line_tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#                   expect(line_tax.name).to eql('record_tax')
#                   expect(line_tax.percentage).to eql(10)
#                   expect(line_tax.value).to eql(490.0)
#                 end
#               end
#             end
#           elsif field_api_name == 'Participants'
#             participants = record.participants
#             participants.each do |participant|
#               expect(participant.id).to eql(current_user_id)
#               expect(participant.type).to eql('user')
#               expect(participant.name).to eql(current_user.full_name)
#               expect(participant.email).to eql(current_user.email)
#               expect(participant.is_invited).to be(false)
#               expect(participant.status).to eql('not_known')
#             end
#           elsif field_api_name == 'Tag'
#             tags = record.tag_list
#             tags.each do |tag|
#               expect(tag).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTag)
#               expect(tag.id).to be_a_kind_of(String)
#               expect(tag.name).to eql('ruby_automation_tag1')
#             end
#           elsif field_api_name == 'Tax'
#             tax_list = record.tax_list
#             tax_list.each do |tax|
#               expect(tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#               expect(tax.name).to eql('record_tax')
#             end
#           elsif field_api_name == 'Pricing_Details'
#             if creatable_module_api_name == 'Price_books'
#               pricing_instances = record.price_details
#               pricing_instances.each do |pricing_instance|
#                 expect(pricing_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMPriceBookPricing)
#                 expect(pricing_instance.id).to be_a_kind_of(String)
#                 expect(pricing_instance.discount).to eql(10.0)
#                 expect(pricing_instance.to_range).to eql(200.0)
#                 expect(pricing_instance.from_range).to eql(2.0)
#               end
#             end
#           elsif field_api_name == 'Start_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T00:00:00+00:00')
#           elsif field_api_name == 'End_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T23:59:59+00:00')
#           elsif datatype == 'text'
#             word = iterator.to_s + '1234567890'
#             word = word[0, length - 1]
#             expect(record.field_data[field_api_name]).to eql(word)
#           elsif datatype == 'picklist' && creatable_module_api_name != 'Calls'
#             if field_details['picklist'].length > 1
#               if field_details['picklist'][1].display_value == '-None-'
#                 expect(record.field_data[field_api_name]).to be(nil)
#               else
#                 expect(record.field_data[field_api_name]).to eql(field_details['picklist'][1].display_value)
#               end
#             elsif
#               expect(record.field_data[field_api_name]).to eql(field_details['picklist'][0].display_value)
#             end
#           elsif datatype == 'multiselectpicklist'
#             expect(record.field_data[field_api_name]).to eql([field_details['picklist'][0].display_value])
#           elsif datatype == 'email'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + 'rubysdk+automation@zoho.com')
#           elsif datatype == 'fileupload'
#           #      record.field_data[field_api_name]=[{"file_id"=>fileid}]
#           elsif datatype == 'website'
#             expect(record.field_data[field_api_name]).to eql('www.zoho.com')
#           elsif datatype == 'integer'
#             expect(record.field_data[field_api_name]).to eql(123)
#           elsif datatype == 'bigint'
#             expect(record.field_data[field_api_name]).to eql('123')
#           elsif datatype == 'phone'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + '123')
#           elsif datatype == 'currency'
#             expect(record.field_data[field_api_name]).to be_a_kind_of(Integer).or be_a_kind_of(Float)
#           elsif datatype == 'boolean'
#             expect(record.field_data[field_api_name]).to be(true)
#           elsif datatype == 'date'
#             expect(record.field_data[field_api_name]).to eql('2016-11-14').or eql('2019-08-11')
#           elsif datatype == 'double'
#             expect(record.field_data[field_api_name]).to eql(2.1)
#           elsif datatype == 'textarea'
#             expect(record.field_data[field_api_name]).to eql('ruby_updation_at_work')
#           elsif datatype == 'datetime'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T15:53:00+05:30')
#            end
#         end
#         iterator += 1
#       end
#     end
#   end
#   it 'upsert_records' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       iterator = record_count * 4 - 1
#       next if activity_module.include?(creatable_module_api_name)

#       upserted_records[creatable_module_api_name].each do |record|
#         expect(record).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#         owner = record.owner
#         expect(owner).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(owner.id).to eql(current_user_id)
#         expect(owner.name).to eql(current_user_name)
#         created_by = record.created_by
#         expect(created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(created_by.id).to eql(current_user_id)
#         expect(created_by.name).to eql(current_user_name)
#         expect(record.created_time).to be_a_kind_of(String)
#         expect(record.modified_time).to be_a_kind_of(String)
#         expect(record.properties).to be_a_kind_of(Hash)
#         moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           lookup_ins = field_details['lookup']
#           if fieldlabel == 'Call Duration'
#             expect(record.field_data[field_api_name]).to eql('20:00')
#           elsif field_api_name == 'Remind_At'
#             if creatable_module_api_name == 'Events'
#               expect(record.field_data[field_api_name]).to eql('2019-06-15T05:30:00+05:30')
#             else
#               expect(record.field_data[field_api_name]['ALARM']).to eql('FREQ=DAILY;ACTION=EMAIL;TRIGGER=DATE-TIME:2019-10-29T17:59:00+05:30')
#             end
#           elsif field_api_name == 'Parent_Campaign'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Campaign')
#             expect(record.field_data[field_api_name].name).to eql('31234567890').or eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][0].entity_id).or eql(created_record['Campaigns'][1].entity_id)
#           elsif field_api_name == 'Reporting_To'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Reporting_To')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Vendor_Name' && creatable_module_api_name != 'Vendors'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Vendor_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Vendors'][1].entity_id)
#           elsif field_api_name == 'Product_Name'  && creatable_module_api_name != 'Products'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Product_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Products'][1].entity_id)
#           elsif field_api_name == 'Account_Name'  && creatable_module_api_name != 'Accounts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Account_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Parent_Account' && creatable_module_api_name != 'Accounts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Parent_Account')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Related_To' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Related_To')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Who_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Who_Id')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'What_Id'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('What_Id')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Accounts'][1].entity_id)
#           elsif field_api_name == 'Contact_Name' && creatable_module_api_name != 'Contacts'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Contact_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890 41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Contacts'][1].entity_id)
#           elsif field_api_name == 'Campaign_Source' && creatable_module_api_name != 'Campaigns'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Campaign_Source')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Campaigns'][1].entity_id)
#           elsif field_api_name == 'Deal_Name' && creatable_module_api_name != 'Deals'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Deal_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Deals'][1].entity_id)
#           elsif field_api_name == 'Quote_Name' && creatable_module_api_name != 'Quotes'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Quote_Name')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Quotes'][1].entity_id)
#           elsif field_api_name == 'Sales_Order' && creatable_module_api_name != 'Sales_Orders'
#             expect(record.field_data[field_api_name]).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#             expect(record.field_data[field_api_name].module_api_name).to eql('Sales_Order')
#             expect(record.field_data[field_api_name].name).to eql('41234567890')
#             expect(record.field_data[field_api_name].entity_id).to eql(created_record['Sales_Orders'][1].entity_id)
#           elsif field_api_name == 'Product_Details'
#             line_items = record.line_items
#             if %w[Quotes Sales_Orders Purchase_Orders Invoices].include?(creatable_module_api_name)
#               line_items.each do |line_item|
#                 expect(line_item).to be_an_instance_of(ZCRMSDK::Operations::ZCRMInventoryLineItem)
#                 product = line_item.product
#                 expect(product).to be_an_instance_of(ZCRMSDK::Operations::ZCRMRecord)
#                 expect(product.module_api_name).to eql('Products')
#                 expect(product.entity_id).to eql(created_record['Products'][1].entity_id)
#                 expect(product.lookup_label).to be_a_kind_of(String)
#                 expect(product.field_data['Product_Code']).to be_a_kind_of(String)
#                 expect(line_item.list_price).to eql(246.0)
#                 expect(line_item.quantity).to eql(20)
#                 expect(line_item.description).to eql('ruby_update_automation_lineitem').or eql('ruby_automation_lineitem')
#                 expect(line_item.total).to eql(4920.0)
#                 expect(line_item.discount).to eql(20.0)
#                 expect(line_item.total_after_discount).to eql(4900.0)
#                 expect(line_item.tax_amount).to eql(490.0)
#                 expect(line_item.net_total).to eql(5390.0)
#                 expect(line_item.delete_flag).to be(false)
#                 line_taxes = line_item.line_tax
#                 line_taxes.each do |line_tax|
#                   expect(line_tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#                   expect(line_tax.name).to eql('record_tax')
#                   expect(line_tax.percentage).to eql(10)
#                   expect(line_tax.value).to eql(490.0)
#                 end
#               end
#             end
#           elsif field_api_name == 'Participants'
#             participants = record.participants
#             participants.each do |participant|
#               expect(participant.id).to eql(current_user_id)
#               expect(participant.type).to eql('user')
#               expect(participant.name).to eql(current_user.full_name)
#               expect(participant.email).to eql(current_user.email)
#               expect(participant.is_invited).to be(false)
#               expect(participant.status).to eql('not_known')
#             end
#           elsif field_api_name == 'Tag'
#             tags = record.tag_list
#             tags.each do |tag|
#               expect(tag).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTag)
#               expect(tag.id).to be_a_kind_of(String)
#               expect(tag.name).to eql('ruby_automation_tag1')
#             end
#           elsif field_api_name == 'Tax'
#             tax_list = record.tax_list
#             tax_list.each do |tax|
#               expect(tax).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTax)
#               expect(tax.name).to eql('record_tax')
#             end
#           elsif field_api_name == 'Pricing_Details'
#             if creatable_module_api_name == 'Price_books'
#               pricing_instances = record.price_details
#               pricing_instances.each do |pricing_instance|
#                 expect(pricing_instance).to be_an_instance_of(ZCRMSDK::Operations::ZCRMPriceBookPricing)
#                 expect(pricing_instance.id).to be_a_kind_of(String)
#                 expect(pricing_instance.discount).to eql(10.0)
#                 expect(pricing_instance.to_range).to eql(200.0)
#                 expect(pricing_instance.from_range).to eql(2.0)
#               end
#             end
#           elsif field_api_name == 'Start_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T00:00:00+00:00')
#           elsif field_api_name == 'End_DateTime' && creatable_module_api_name == 'Events'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T23:59:59+00:00')
#           elsif datatype == 'text'
#             word = iterator.to_s + '1234567890'
#             word = word[0, length - 1]
#             expect(record.field_data[field_api_name]).to eql(word)
#           elsif datatype == 'picklist' && creatable_module_api_name != 'Calls'
#             if field_details['picklist'].length > 1
#               if field_details['picklist'][1].display_value == '-None-'
#                 expect(record.field_data[field_api_name]).to be(nil)
#               else
#                 expect(record.field_data[field_api_name]).to eql(field_details['picklist'][1].display_value)
#               end
#             elsif
#               expect(record.field_data[field_api_name]).to eql(field_details['picklist'][0].display_value)
#             end
#           elsif datatype == 'multiselectpicklist'
#             expect(record.field_data[field_api_name]).to eql([field_details['picklist'][0].display_value])
#           elsif datatype == 'email'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + 'rubysdk+automation@zoho.com')
#           elsif datatype == 'fileupload'
#           #      record.field_data[field_api_name]=[{"file_id"=>fileid}]
#           elsif datatype == 'website'
#             expect(record.field_data[field_api_name]).to eql('www.zoho.com')
#           elsif datatype == 'integer'
#             expect(record.field_data[field_api_name]).to eql(123)
#           elsif datatype == 'bigint'
#             expect(record.field_data[field_api_name]).to eql('123')
#           elsif datatype == 'phone'
#             expect(record.field_data[field_api_name]).to eql(iterator.to_s + '123')
#           elsif datatype == 'currency'
#             expect(record.field_data[field_api_name]).to be_a_kind_of(Integer).or be_a_kind_of(Float)
#           elsif datatype == 'boolean'
#             expect(record.field_data[field_api_name]).to be(true)
#           elsif datatype == 'date'
#             expect(record.field_data[field_api_name]).to eql('2019-07-11').or eql('2019-08-11')
#           elsif datatype == 'double'
#             expect(record.field_data[field_api_name]).to eql(2.1)
#           elsif datatype == 'textarea'
#             expect(record.field_data[field_api_name]).to eql('ruby_automation_at_work').or eql('ruby_updation_at_work')
#           elsif datatype == 'datetime'
#             expect(record.field_data[field_api_name]).to eql('2019-06-15T15:53:00+05:30')
#            end
#         end
#         iterator = record_count * 4
#       end
#     end
#   end
#   it 'search records by word' do # search_records()
#     creatable_module_api_names.each do |creatable_module_api_name|
#       search_records_response[creatable_module_api_name].each do |record|
#         moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           if datatype == 'textarea'
#             expect(record.field_data[field_api_name]).to eql('ruby_updation_at_work')
#           end
#         end
#       end
#     end
#   end
#   it 'search records by phone' do # search_records()
#     phonemodules.each do |module_name, _value|
#       search_records_response_phone[module_name].each do |record|
#         moduleapinamevsfieldsarrayvsfielddetail[module_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           if datatype == 'phone'
#             phone = record_count.to_s + '123'
#             expect(record.field_data[field_api_name]).to eql(phone)
#           end
#         end
#       end
#     end
#   end
#   it 'search records by email' do # search_records()
#     emailmodules.each do |module_name, _value|
#       search_records_response_email[module_name].each do |record|
#         moduleapinamevsfieldsarrayvsfielddetail[module_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           length = field_details['length']
#           fieldlabel = field_details['field_label']
#           if datatype == 'email'
#             email = record_count.to_s + 'rubysdk+automation@zoho.com'
#             expect(record.field_data[field_api_name]).to eql(email)
#           end
#         end
#       end
#     end
#   end
#   it 'search records by Criteria' do # search_records()
#     emailmodules.each do |module_name, _value|
#       search_records_response_criteria[module_name].each do |record|
#         moduleapinamevsfieldsarrayvsfielddetail[module_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           if datatype == 'textarea'
#             criteria = 'ruby_updation_at_work'
#             expect(record.field_data[field_api_name]).to eql(criteria)
#           end
#         end
#       end
#     end
#   end
#   it 'mass update records' do # massupdate()
#     creatable_module_api_names.each do |creatable_module_api_name|
#       mass_updated_records[creatable_module_api_name].each do |record|
#         moduleapinamevsfieldsarrayvsfielddetail[creatable_module_api_name].each do |field_api_name, field_details|
#           datatype = field_details['data_type']
#           if datatype == 'textarea'
#             expect(record.field_data[field_api_name]).to eql('ruby_mass_updation_at_work')
#           end
#         end
#       end
#     end
#   end
#   it 'create_tags' do
#     expect(create_tags_flag).to eql(0)
#     creatable_module_api_names.each do |creatable_module_api_name|
#       created_tags[creatable_module_api_name].each do |tag_ins|
#         expect(tag_ins.id).to be_a_kind_of(String)
#         expect(tag_ins.name).to eql('ruby_automation_tag1').or eql('ruby_automation_tag2').or eql('ruby_automation_tag3')
#         expect(tag_ins.created_time).to be_a_kind_of(String)
#         expect(tag_ins.created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(tag_ins.created_by.id).to eql(current_user_id)
#         expect(tag_ins.created_by.name).to eql(current_user_name)
#       end
#     end
#   end
#   it 'update_tags' do
#     expect(update_tags_flag).to eql(0)
#     creatable_module_api_names.each do |creatable_module_api_name|
#       updated_tags[creatable_module_api_name].each do |tag_ins|
#         expect(tag_ins.id).to be_a_kind_of(String)
#         expect(tag_ins.name).to eql('ruby_updated_tag1').or eql('ruby_updated_tag2').or eql('ruby_updated_tag3')
#         expect(tag_ins.created_time).to be_a_kind_of(String)
#         expect(tag_ins.created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(tag_ins.created_by.id).to eql(current_user_id)
#         expect(tag_ins.created_by.name).to eql(current_user_name)
#       end
#     end
#   end
#   it 'deleted_tags' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       deleted_tags[creatable_module_api_name].each do |response|
#         expect(response.code).to eql('SUCCESS')
#         expect(tag_ids[creatable_module_api_name]).to include(response.details['id'])
#         expect(response.message).to eql('tags deleted successfully')
#       end
#     end
#   end
#   it 'add_tags_to_multiple_records' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       records_tag_added[creatable_module_api_name].each do |record|
#         tags = record.tag_list
#         tags.each do |tag_ins|
#           expect(tag_ins.name).to eql('ruby_updated_tag1').or eql('ruby_updated_tag2').or eql('ruby_updated_tag3')
#         end
#       end
#     end
#   end
#   it 'record_count' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       expect(record_tag_count[creatable_module_api_name][0]).to eql((record_count * 2).to_s).or eql((record_count * 2 + 1).to_s )
#       expect(record_tag_count[creatable_module_api_name][1]).to eql(record_count.to_s)
#       expect(record_tag_count[creatable_module_api_name][2]).to eql(record_count.to_s)
#     end
#   end
#   it 'remove_tags_from_multiple_records' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       records_tag_removed[creatable_module_api_name].each do |record|
#         expect(record.tag_list.length).to eql(0)
#       end
#     end
#   end
#   it 'deleted record' do # delete() and delete_records(record_id[])
#     creatable_module_api_names.each do |creatable_module_api_name|
#       expect(deleted_record_response[creatable_module_api_name].details['id']).to eql(created_record[creatable_module_api_name][0].entity_id)
#       expect(deleted_records_response[creatable_module_api_name][0].details['id']).to eql(created_record[creatable_module_api_name][1].entity_id)
#       expect(deleted_records_response[creatable_module_api_name][1].details['id']).to eql(created_record[creatable_module_api_name][2].entity_id)
#     end
#   end
#   it 'all_deleted_records' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       all_deleted_records[creatable_module_api_name].each do |trash_record_ins|
#         expect(trash_record_ins).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTrashRecord)
#         expect(trash_record_ins.id).to be_a_kind_of(String)
#         expect(trash_record_ins.type).to eql('recycle').or eql('permanent')
#         expect(trash_record_ins.module_api_name).to eql(creatable_module_api_name)
#         expect(trash_record_ins.display_name).to be_a_kind_of(String).or be(nil)
#         expect(trash_record_ins.deleted_time).to be_a_kind_of(String)
#         unless trash_record_ins.created_by.nil?
#           expect(trash_record_ins.created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#           expect(trash_record_ins.created_by.id).to be_a_kind_of(String)
#           expect(trash_record_ins.created_by.name).to be_a_kind_of(String)
#         end
#         next if trash_record_ins.deleted_by.nil?

#         expect(trash_record_ins.deleted_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(trash_record_ins.deleted_by.id).to be_a_kind_of(String)
#         expect(trash_record_ins.deleted_by.name).to be_a_kind_of(String)
#       end
#     end
#   end
#   it 'recycle_bin_records' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       recyclebin_records[creatable_module_api_name].each do |trash_record_ins|
#         expect(trash_record_ins).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTrashRecord)
#         expect(trash_record_ins.id).to be_a_kind_of(String)
#         expect(trash_record_ins.type).to eql('recycle')
#         expect(trash_record_ins.module_api_name).to eql(creatable_module_api_name)
#         expect(trash_record_ins.display_name).to be_a_kind_of(String)
#         expect(trash_record_ins.deleted_time).to be_a_kind_of(String)
#         unless trash_record_ins.created_by.nil?
#           expect(trash_record_ins.created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#           expect(trash_record_ins.created_by.id).to be_a_kind_of(String)
#           expect(trash_record_ins.created_by.name).to be_a_kind_of(String)
#         end
#         next if trash_record_ins.deleted_by.nil?

#         expect(trash_record_ins.deleted_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(trash_record_ins.deleted_by.id).to be_a_kind_of(String)
#         expect(trash_record_ins.deleted_by.name).to be_a_kind_of(String)
#       end
#     end
#   end
#   it 'permanently_deleted_records' do
#     creatable_module_api_names.each do |creatable_module_api_name|
#       permanently_deleted_records[creatable_module_api_name].each do |trash_record_ins|
#         expect(trash_record_ins).to be_an_instance_of(ZCRMSDK::Operations::ZCRMTrashRecord)
#         expect(trash_record_ins.id).to be_a_kind_of(String)
#         expect(trash_record_ins.type).to eql('permanent')
#         expect(trash_record_ins.module_api_name).to eql(creatable_module_api_name)
#         expect(trash_record_ins.display_name).to be_a_kind_of(String).or be(nil)
#         expect(trash_record_ins.deleted_time).to be_a_kind_of(String)
#         unless trash_record_ins.created_by.nil?
#           expect(trash_record_ins.created_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#           expect(trash_record_ins.created_by.id).to be_a_kind_of(String)
#           expect(trash_record_ins.created_by.name).to be_a_kind_of(String)
#         end
#         next if trash_record_ins.deleted_by.nil?

#         expect(trash_record_ins.deleted_by).to be_an_instance_of(ZCRMSDK::Operations::ZCRMUser)
#         expect(trash_record_ins.deleted_by.id).to be_a_kind_of(String)
#         expect(trash_record_ins.deleted_by.name).to be_a_kind_of(String)
#       end
#     end
#   end
# end
