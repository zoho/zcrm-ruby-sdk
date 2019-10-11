# frozen_string_literal: true

require_relative 'utility'
require_relative 'handler'
module ZCRMSDK
  module Operations
    # THIS CLASS IS USED TO STORE AND EXECTUTE MODULE RELATED FUNCTIONS
    class ZCRMModule
      attr_accessor :is_inventory_template_supported, :layouts, :visibility, :is_feeds_required, :is_quick_create, :is_email_template_support, :is_webform_supported, :is_filter_supported, :is_kanban_view_supported, :generated_type, :arguments, :parent_module, :is_filter_status, :is_kanban_view, :is_presence_sub_menu, :api_name, :is_convertable, :is_creatable, :is_editable, :is_deletable, :web_link, :singular_label, :plural_label, :modified_by, :modified_time, :is_viewable, :is_api_supported, :is_custom_module, :is_scoring_supported, :id, :module_name, :business_card_field_limit, :business_card_fields, :profiles, :display_field_name, :display_field_id, :related_lists, :fields, :related_list_properties, :properties, :per_page, :search_layout_fields, :default_territory_name, :default_territory_id, :default_custom_view_id, :default_custom_view, :is_global_search_supported, :sequence_number
      def initialize(module_apiname)
        @api_name = module_apiname
        @visibility = nil
        @fields = nil
        @layouts = nil
        @is_convertable = nil
        @is_feeds_required = nil
        @is_creatable = nil
        @is_editable = nil
        @is_deletable = nil
        @web_link = nil
        @singular_label = nil
        @plural_label = nil
        @modified_by = nil
        @modified_time = nil
        @is_viewable = nil
        @is_api_supported = nil
        @is_custom_module = nil
        @is_scoring_supported = nil
        @is_webform_supported = nil
        @is_email_template_support = nil
        @is_inventory_template_supported = nil
        @id = nil
        @module_name = nil
        @business_card_field_limit = nil
        @business_card_fields = []
        @profiles = []
        @display_field_name = nil
        @related_lists = nil
        @related_list_properties = nil
        @properties = nil
        @per_page = nil
        @search_layout_fields = nil
        @default_territory_name = nil
        @default_territory_id = nil
        @default_custom_view_id = nil
        @default_custom_view = nil
        @is_global_search_supported = nil
        @sequence_number = nil
        @is_kanban_view = nil
        @is_filter_status = nil
        @parent_module = nil
        @is_presence_sub_menu = nil
        @arguments = []
        @generated_type = nil
        @is_quick_create = nil
        @is_kanban_view_supported = nil
        @is_filter_supported = nil
      end

      def self.get_instance(module_apiname)
        ZCRMModule.new(module_apiname)
      end

      def get_record(entity_id)
        record = ZCRMRecord.get_instance(@api_name, entity_id)
        Handler::EntityAPIHandler.get_instance(record).get_record
      end

      def get_records(cvid = nil, sort_by = nil, sort_order = nil, page = 1, per_page = 200, headers = nil)
        Handler::MassEntityAPIHandler.get_instance(self).get_records(cvid, sort_by, sort_order, page, per_page, headers)
      end

      def get_all_deleted_records(page = 1, per_page = 200)
        Handler::MassEntityAPIHandler.get_instance(self).get_deleted_records('all', page, per_page)
      end

      def get_recyclebin_records(page = 1, per_page = 200)
        Handler::MassEntityAPIHandler.get_instance(self).get_deleted_records('recycle', page, per_page)
      end

      def get_permanently_deleted_records(page = 1, per_page = 200)
        Handler::MassEntityAPIHandler.get_instance(self).get_deleted_records('permanent', page, per_page)
      end

      def get_all_fields
        Handler::ModuleAPIHandler.get_instance(self).get_all_fields
      end

      def get_field(field_id)
        Handler::ModuleAPIHandler.get_instance(self).get_field(field_id)
      end

      def get_all_layouts
        Handler::ModuleAPIHandler.get_instance(self).get_all_layouts
      end

      def get_layout(layout_id)
        Handler::ModuleAPIHandler.get_instance(self).get_layout(layout_id)
      end

      def get_all_customviews
        Handler::ModuleAPIHandler.get_instance(self).get_all_customviews
      end

      def get_customview(customview_id)
        Handler::ModuleAPIHandler.get_instance(self).get_customview(customview_id)
      end

      def get_all_relatedlists
        Handler::ModuleAPIHandler.get_instance(self).get_all_relatedlists
      end

      def get_relatedlist(relatedlist_id)
        Handler::ModuleAPIHandler.get_instance(self).get_relatedlist(relatedlist_id)
      end

      def create_records(record_ins_list, lar_id = nil)
        Handler::MassEntityAPIHandler.get_instance(self).create_records(record_ins_list, lar_id)
      end

      def upsert_records(record_ins_list, duplicate_check_fields = nil, lar_id = nil)
        Handler::MassEntityAPIHandler.get_instance(self).upsert_records(record_ins_list, duplicate_check_fields, lar_id)
      end

      def update_records(record_ins_list)
        Handler::MassEntityAPIHandler.get_instance(self).update_records(record_ins_list)
      end

      def update_customview(customview_instance)
        Handler::ModuleAPIHandler.get_instance(self).update_customview(customview_instance)
      end

      def mass_update_records(entityid_list, field_api_name, value)
        Handler::MassEntityAPIHandler.get_instance(self).mass_update_records(entityid_list, field_api_name, value)
      end

      def delete_records(entityid_list)
        Handler::MassEntityAPIHandler.get_instance(self).delete_records(entityid_list)
      end

      def search_records(search_word, page = 1, per_page = 200)
        Handler::MassEntityAPIHandler.get_instance(self).search_records(search_word, page, per_page, 'word')
      end

      def search_records_by_phone(phone, page = 1, per_page = 200)
        Handler::MassEntityAPIHandler.get_instance(self).search_records(phone, page, per_page, 'phone')
      end

      def search_records_by_email(email, page = 1, per_page = 200)
        Handler::MassEntityAPIHandler.get_instance(self).search_records(email, page, per_page, 'email')
      end

      def search_records_by_criteria(criteria, page = 1, per_page = 200)
        Handler::MassEntityAPIHandler.get_instance(self).search_records(criteria, page, per_page, 'criteria')
      end

      def get_tags
        Handler::TagAPIHandler.get_instance(self).get_tags
      end

      def get_tag_count(tag_id)
        Handler::TagAPIHandler.get_instance(self).get_tag_count(tag_id)
      end

      def create_tags(tags_list)
        Handler::TagAPIHandler.get_instance(self).create_tags(tags_list)
      end

      def update_tags(tags_list)
        Handler::TagAPIHandler.get_instance(self).update_tags(tags_list)
      end

      def add_tags_to_multiple_records(tags_list, record_list)
        Handler::TagAPIHandler.get_instance(self).add_tags_to_multiple_records(tags_list, record_list)
      end

      def remove_tags_from_multiple_records(tags_list, record_list)
        Handler::TagAPIHandler.get_instance(self).remove_tags_from_multiple_records(tags_list, record_list)
      end
    end
    # THIS CLASS IS USED TO STORE SUBFORM RELATED DATA
    class ZCRMSubForm
      attr_accessor :id, :name, :owner, :created_time, :modified_time, :layout, :field_data, :properties
      def initialize(id = nil)
        @id = id
        @name = nil
        @owner = nil
        @created_time = nil
        @modified_time = nil
        @layout = nil
        @field_data = {}
        @properties = {}
      end

      def self.get_instance(id = nil)
        ZCRMSubForm.new(id)
      end
    end
    # THIS CLASS IS USED TO STORE AND EXECTUTE TAG RELATED FUNCTIONS
    class ZCRMTag
      attr_accessor :id, :module_apiname, :name, :created_by, :modified_by, :created_time, :modified_time, :count
      def initialize(id = nil, name = nil)
        @id = id
        @module_apiname = nil
        @name = name
        @created_by = nil
        @modified_by = nil
        @created_time = nil
        @modified_time = nil
        @count = nil
      end

      def self.get_instance(id = nil, name = nil)
        ZCRMTag.new(id, name)
      end

      def delete
        Handler::TagAPIHandler.get_instance.delete(@id)
      end

      def merge(merge_tag)
        Handler::TagAPIHandler.get_instance.merge(@id, merge_tag.id)
      end

      def update
        Handler::TagAPIHandler.get_instance.update(self)
      end
    end
    # THIS CLASS IS USED TO STORE AND EXECTUTE RECORD RELATED FUNCTIONS
    class ZCRMRecord
      attr_accessor :tag_list, :name, :module_api_name, :entity_id, :line_items, :lookup_label, :owner, :created_by, :modified_by, :created_time, :modified_time, :field_data, :properties, :participants, :price_details, :layout, :tax_list, :last_activity_time
      def initialize(module_apiname, entity_id = nil)
        @module_api_name = module_apiname
        @entity_id = entity_id
        @line_items = []
        @lookup_label = nil
        @name = nil
        @owner = nil
        @created_by = nil
        @modified_by = nil
        @created_time = nil
        @modified_time = nil
        @field_data = {}
        @properties = {}
        @participants = []
        @price_details = []
        @layout = nil
        @tax_list = []
        @tag_list = []
      end

      def self.get_instance(module_api_name, entity_id = nil)
        ZCRMRecord.new(module_api_name, entity_id)
      end

      def get
        Handler::EntityAPIHandler.get_instance(self).get_record
      end

      def create
        Handler::EntityAPIHandler.get_instance(self).create_record
      end

      def update
        Handler::EntityAPIHandler.get_instance(self).update_record
      end

      def delete
        Handler::EntityAPIHandler.get_instance(self).delete_record
      end

      def convert(potential_record = nil, details = nil)
        Handler::EntityAPIHandler.get_instance(self).convert_record(potential_record, details)
      end

      def upload_attachment(file_path)
        ZCRMModuleRelation.get_instance(self, 'Attachments').upload_attachment(file_path)
      end

      def upload_link_as_attachment(link_url)
        ZCRMModuleRelation.get_instance(self, 'Attachments').upload_link_as_attachment(link_url)
      end

      def download_attachment(attachment_id)
        ZCRMModuleRelation.get_instance(self, 'Attachments').download_attachment(attachment_id)
      end

      def delete_attachment(attachment_id)
        ZCRMModuleRelation.get_instance(self, 'Attachments').delete_attachment(attachment_id)
      end

      def upload_photo(file_path)
        Handler::EntityAPIHandler.get_instance(self).upload_photo(file_path)
      end

      def download_photo
        Handler::EntityAPIHandler.get_instance(self).download_photo
      end

      def delete_photo
        Handler::EntityAPIHandler.get_instance(self).delete_photo
      end

      def add_relation(junction_record)
        ZCRMModuleRelation.get_instance(self, junction_record).add_relation
      end

      def remove_relation(junction_record)
        ZCRMModuleRelation.get_instance(self, junction_record).remove_relation
      end

      def add_note(note_ins)
        ZCRMModuleRelation.get_instance(self, 'Notes').add_note(note_ins)
      end

      def update_note(note_ins)
        ZCRMModuleRelation.get_instance(self, 'Notes').update_note(note_ins)
      end

      def delete_note(note_ins)
        ZCRMModuleRelation.get_instance(self, 'Notes').delete_note(note_ins)
      end

      def get_notes(sort_by = nil, sort_order = nil, page = 1, per_page = 20)
        ZCRMModuleRelation.get_instance(self, 'Notes').get_notes(sort_by, sort_order, page, per_page)
      end

      def get_attachments(page = 1, per_page = 20)
        ZCRMModuleRelation.get_instance(self, 'Attachments').get_attachments(page, per_page)
      end

      def get_relatedlist_records(relatedlist_api_name, sort_by = nil, sort_order = nil, page = 1, per_page = 20)
        ZCRMModuleRelation.get_instance(self, relatedlist_api_name).get_records(sort_by, sort_order, page, per_page)
      end

      def add_tags(tagnames)
        Handler::TagAPIHandler.get_instance.add_tags(self, tagnames)
      end

      def remove_tags(tagnames)
        Handler::TagAPIHandler.get_instance.remove_tags(self, tagnames)
      end
    end
    # THIS CLASS IS USED TO STORE LINE ITEM RELATED DATA
    class ZCRMInventoryLineItem
      attr_accessor :product, :id, :discount_percentage, :list_price, :quantity, :description, :total, :discount, :total_after_discount, :tax_amount, :net_total, :delete_flag, :line_tax
      def initialize(param = nil)
        if param.is_a?(Operations::ZCRMRecord)
          @product = param
          @id = nil
        else
          @id = param
          @product = nil
          @list_price = nil
          @quantity = nil
          @description = nil
          @total = nil
          @discount = nil
          @discount_percentage = nil
          @total_after_discount = nil
          @tax_amount = nil
          @net_total = nil
          @delete_flag = false
          @line_tax = []
        end
      end

      def self.get_instance(param = nil)
        ZCRMInventoryLineItem.new(param)
      end
    end
    # THIS CLASS IS USED TO STORE TAX RELATED DATA
    class ZCRMTax
      attr_accessor :name, :percentage, :value
      def initialize(name)
        @name = name
        @percentage = nil
        @value = nil
      end

      def self.get_instance(name)
        ZCRMTax.new(name)
      end
    end
    # THIS CLASS IS USED TO STORE ORG TAX RELATED DATA
    class ZCRMOrgTax
      attr_accessor :id, :name, :display_label, :value, :sequence_number
      def initialize(id = nil, name = nil)
        @id = id
        @name = name
        @display_label = nil
        @value = nil
        @sequence_number = nil
      end

      def self.get_instance(id = nil, name = nil)
        ZCRMOrgTax.new(id, name)
      end
    end
    # THIS CLASS IS USED TO STORE EVENT PARTICIPANT RELATED DATA
    class ZCRMEventParticipant
      attr_accessor :id, :type, :email, :name, :is_invited, :status
      def initialize(participant_type, participant_id)
        @id = participant_id
        @type = participant_type
        @email = nil
        @name = nil
        @is_invited = nil
        @status = nil
      end

      def self.get_instance(participant_type, participant_id)
        ZCRMEventParticipant.new(participant_type, participant_id)
      end
    end
    # THIS CLASS IS USED TO STORE PRICING BOOK RELATED DATA
    class ZCRMPriceBookPricing
      attr_accessor :id, :to_range, :from_range, :discount
      def initialize(price_book_id = nil)
        @id = price_book_id
        @to_range = nil
        @from_range = nil
        @discount = nil
      end

      def self.get_instance(price_book_id = nil)
        ZCRMPriceBookPricing.new(price_book_id)
      end
    end
    # THIS CLASS IS USED TO STORE USER RELATED DATA
    class ZCRMUser
      attr_accessor :id, :is_microsoft, :offset, :name, :field_apiname_vs_value, :signature, :country, :role, :customize_info, :city, :name_format, :language, :locale, :is_personal_account, :default_tab_group, :street, :alias_aka, :theme, :state, :country_locale, :fax, :first_name, :email, :zip, :decimal_separator, :website, :time_format, :profile, :mobile, :last_name, :time_zone, :zuid, :is_confirm, :full_name, :phone, :dob, :date_format, :status, :created_by, :modified_by, :territories, :reporting_to, :is_online, :currency, :created_time, :modified_time
      def initialize(user_id = nil, name = nil)
        @id = user_id
        @name = name
        @offset = nil
        @is_microsoft = nil
        @signature = nil
        @country = nil
        @role = nil
        @customize_info = nil
        @city = nil
        @name_format = nil
        @language = nil
        @locale = nil
        @is_personal_account = nil
        @default_tab_group = nil
        @street = nil
        @alias_aka = nil
        @theme = nil
        @state = nil
        @country_locale = nil
        @fax = nil
        @first_name = nil
        @email = nil
        @zip = nil
        @decimal_separator = nil
        @website = nil
        @time_format = nil
        @profile = nil
        @mobile = nil
        @last_name = nil
        @time_zone = nil
        @zuid = nil
        @is_confirm = nil
        @full_name = nil
        @phone = nil
        @dob = nil
        @date_format = nil
        @status = nil
        @created_by = nil
        @modified_by = nil
        @territories = nil
        @reporting_to = nil
        @is_online = nil
        @currency = nil
        @created_time = nil
        @modified_time = nil
        @field_apiname_vs_value = nil
      end

      def self.get_instance(user_id = nil, name = nil)
        ZCRMUser.new(user_id, name)
      end
    end
    # THIS CLASS IS USED TO STORE USER CUSTOM INFO RELATED DATA
    class ZCRMUserCustomizeInfo
      attr_accessor :notes_desc, :is_to_show_right_panel, :is_bc_view, :is_to_show_home, :is_to_show_detail_view, :unpin_recent_item
      def initialize
        @notes_desc = nil
        @is_to_show_right_panel = nil
        @is_bc_view = nil
        @is_to_show_home = nil
        @is_to_show_detail_view = nil
        @unpin_recent_item = nil
      end

      def self.get_instance
        ZCRMUserCustomizeInfo.new
      end
    end
    # THIS CLASS IS USED TO STORE USER THEME RELATED DATA
    class ZCRMUserTheme
      attr_accessor :normal_tab_font_color, :normal_tab_background, :selected_tab_font_color, :selected_tab_background, :new_background, :background, :screen, :type
      def initialize
        @normal_tab_font_color = nil
        @normal_tab_background = nil
        @selected_tab_font_color = nil
        @selected_tab_background = nil
        @new_background = nil
        @background = nil
        @screen = nil
        @type = nil
      end

      def self.get_instance
        ZCRMUserTheme.new
      end
    end
    # THIS CLASS IS USED TO STORE ROLE RELATED DATA
    class ZCRMRole
      attr_accessor :name, :id, :reporting_to, :display_label, :is_admin, :forecast_manager, :is_share_with_peers, :description
      def initialize(role_id, role_name = nil)
        @name = role_name
        @id = role_id
        @reporting_to = nil
        @display_label = nil
        @is_admin = nil
        @forecast_manager = nil
        @is_share_with_peers = nil
        @description = nil
      end

      def self.get_instance(role_id, role_name = nil)
        ZCRMRole.new(role_id, role_name)
      end
    end
    # THIS CLASS IS USED TO STORE LAYOUT RELATED DATA
    class ZCRMLayout
      attr_accessor :created_for, :id, :name, :created_time, :modified_time, :is_visible, :modified_by, :accessible_profiles, :created_by, :sections, :status, :convert_mapping
      def initialize(layout_id)
        @id = layout_id
        @name = nil
        @created_time = nil
        @modified_time = nil
        @is_visible = nil
        @modified_by = nil
        @accessible_profiles = nil
        @created_by = nil
        @sections = nil
        @status = nil
        @convert_mapping = {}
        @created_for = nil
      end

      def self.get_instance(layout_id)
        ZCRMLayout.new(layout_id)
      end
    end
    # THIS CLASS IS USED TO STORE ATTACHMENT RELATED DATA
    class ZCRMAttachment
      attr_accessor :is_editable, :link_url, :file_id, :id, :parent_record, :file_name, :type, :size, :owner, :created_by, :created_time, :modified_by, :modified_time, :parent_module, :attachment_type, :parent_name, :parent_id
      def initialize(parent_record, attachment_id = nil)
        @id = attachment_id
        @parent_record = parent_record
        @file_name = nil
        @type = nil
        @size = nil
        @owner = nil
        @created_by = nil
        @created_time = nil
        @modified_by = nil
        @modified_time = nil
        @parent_module = nil
        @attachment_type = nil
        @parent_name = nil
        @parent_id = nil
        @file_id = nil
        @link_url = nil
        @is_editable = nil
      end

      def self.get_instance(parent_record, attachment_id = nil)
        ZCRMAttachment.new(parent_record, attachment_id)
      end
    end
    # THIS CLASS IS USED TO STORE CUSTOM VIEW RELATED DATA
    class ZCRMCustomView
      attr_accessor :is_system_defined, :shared_details, :criteria_pattern, :criteria_condition, :id, :module_api_name, :display_value, :is_default, :name, :system_name, :sort_by, :category, :fields, :favorite, :sort_order, :criteria, :categories, :is_off_line
      def initialize(custom_view_id, module_api_name = nil)
        @id = custom_view_id
        @module_api_name = module_api_name
        @display_value = nil
        @is_default = nil
        @name = nil
        @system_name = nil
        @sort_by = nil
        @category = nil
        @fields = []
        @favorite = nil
        @sort_order = nil
        @criteria = nil
        @criteria_pattern = nil
        @criteria_condition = nil
        @categories = []
        @is_off_line = nil
        @shared_details = nil
        @is_system_defined = nil
      end

      def self.get_instance(custom_view_id, module_api_name = nil)
        ZCRMCustomView.new(custom_view_id, module_api_name)
      end

      def get_records(sort_by = nil, sort_order = nil, page = 1, per_page = 200, headers = nil)
        Operations::ZCRMModule.get_instance(module_api_name).get_records(id, sort_by, sort_order, page, per_page, headers)
      end
    end
    # THIS CLASS IS USED TO STORE CUSTOMVIEW CATEGORY RELATED DATA
    class ZCRMCustomViewCategory
      attr_accessor :display_value, :actual_value
      def initialize
        @display_value = nil
        @actual_value = nil
      end

      def self.get_instance
        ZCRMCustomViewCategory.new
      end
    end
    # THIS CLASS IS USED TO STORE CUSTOMVIEW CATEGORY CRITERIA RELATED DATA
    class ZCRMCustomViewCriteria
      attr_accessor :comparator, :field, :value, :group, :group_operator, :pattern, :index, :criteria
      def initialize
        @comparator = nil
        @field = nil
        @value = nil
        @group = nil
        @group_operator = nil
        @pattern = nil
        @index = nil
        @criteria = nil
      end

      def self.get_instance
        ZCRMCustomViewCriteria.new
      end
    end
    # THIS CLASS IS USED TO STORE FIELD RELATED DATA
    class ZCRMField
      attr_accessor :is_webhook, :crypt, :tooltip, :is_field_read_only, :association_details, :subform, :is_mass_update, :multiselectlookup, :api_name, :is_custom_field, :lookup_field, :convert_mapping, :is_visible, :field_label, :length, :created_source, :default_value, :is_mandatory, :sequence_number, :is_read_only, :is_unique_field, :is_case_sensitive, :data_type, :is_formula_field, :is_currency_field, :id, :picklist_values, :is_auto_number, :is_business_card_supported, :field_layout_permissions, :decimal_place, :precision, :rounding_option, :formula_return_type, :formula_expression, :prefix, :suffix, :start_number, :json_type
      def initialize(api_name, id = nil)
        @api_name = api_name
        @is_webhook = nil
        @crypt = nil
        @tooltip = nil
        @is_field_read_only = nil
        @association_details = nil
        @subform = nil
        @is_mass_update = nil
        @multiselectlookup = {}
        @is_custom_field = nil
        @lookup_field = {}
        @convert_mapping = nil
        @is_visible = nil
        @field_label = nil
        @length = nil
        @created_source = nil
        @default_value = nil
        @is_mandatory = nil
        @sequence_number = nil
        @is_read_only = nil
        @is_unique_field = nil
        @is_case_sensitive = nil
        @data_type = nil
        @is_formula_field = nil
        @is_currency_field = nil
        @id = id
        @picklist_values = []
        @is_auto_number = nil
        @is_business_card_supported = nil
        @field_layout_permissions = nil
        @decimal_place = nil
        @precision = nil
        @rounding_option = nil
        @formula_return_type = nil
        @formula_expression = nil
        @prefix = nil
        @suffix = nil
        @start_number = nil
        @json_type = nil
      end

      def self.get_instance(api_name, id = nil)
        ZCRMField.new(api_name, id)
      end
    end
    # THIS CLASS IS USED TO STORE JUNCTION RECORD RELATED DATA
    class ZCRMJunctionRecord
      attr_accessor :id, :api_name, :related_data
      def initialize(api_name, record_id)
        @id = record_id
        @api_name = api_name
        @related_data = {}
      end

      def self.get_instance(api_name, record_id)
        ZCRMJunctionRecord.new(api_name, record_id)
      end
    end
    # THIS CLASS IS USED TO STORE LEAD CONVERT MAPPING RELATED DATA
    class ZCRMLeadConvertMapping
      attr_accessor :id, :name, :fields
      def initialize(name, converted_id)
        @id = converted_id
        @name = name
        @fields = []
      end

      def self.get_instance(name, converted_id)
        ZCRMLeadConvertMapping.new(name, converted_id)
      end
    end
    # THIS CLASS IS USED TO STORE LEAD CONVERT MAPPING FIELD RELATED DATA
    class ZCRMLeadConvertMappingField
      attr_accessor :id, :api_name, :field_label, :is_required
      def initialize(api_name, field_id)
        @id = field_id
        @api_name = api_name
        @field_label = nil
        @is_required = nil
      end

      def self.get_instance(api_name, field_id)
        ZCRMLeadConvertMappingField.new(api_name, field_id)
      end
    end
    # THIS CLASS IS USED TO STORE LOOKUP FIELD RELATED DATA
    class ZCRMLookupField
      attr_accessor :api_name, :display_label, :module_apiname, :id
      def initialize(api_name)
        @api_name = api_name
        @display_label = nil
        @module_apiname = nil
        @id = nil
      end

      def self.get_instance(api_name)
        ZCRMLookupField.new(api_name)
      end
    end
    # THIS CLASS IS USED TO STORE MODULE RELATED LIST RELATED DATA
    class ZCRMModuleRelatedList
      attr_accessor :api_name, :module_apiname, :display_label, :is_visible, :name, :id, :href, :type, :action, :sequence_number
      def initialize(api_name)
        @api_name = api_name
        @module_apiname = nil
        @display_label = nil
        @is_visible = nil
        @name = nil
        @id = nil
        @href = nil
        @type = nil
        @action = nil
        @sequence_number = nil
      end

      def self.get_instance(api_name)
        ZCRMModuleRelatedList.new(api_name)
      end
    end
    # THIS CLASS IS USED TO STORE MODULE RELATION RELATED DATA
    class ZCRMModuleRelation
      attr_accessor :parent_record, :parent_module_api_name, :junction_record, :api_name, :label, :id, :is_visible
      def initialize(parentmodule_apiname_or_parentrecord, related_list_apiname_or_junction_record = nil)
        if parentmodule_apiname_or_parentrecord.is_a?(Operations::ZCRMRecord)
          @parent_record = parentmodule_apiname_or_parentrecord
          @parent_module_api_name = nil
        else
          @parent_module_api_name = parentmodule_apiname_or_parentrecord
          @parent_record = nil
        end
        if related_list_apiname_or_junction_record.is_a?(Operations::ZCRMJunctionRecord)
          @junction_record = related_list_apiname_or_junction_record
          @api_name = nil
        else
          @api_name = related_list_apiname_or_junction_record
          @junction_record = nil
        end
        @label = nil
        @id = nil
        @is_visible = nil
      end

      def self.get_instance(parentmodule_apiname_or_parentrecord, related_list_apiname_or_junction_record)
        ZCRMModuleRelation.new(parentmodule_apiname_or_parentrecord, related_list_apiname_or_junction_record)
      end

      def get_records(sort_by_field = nil, sort_order = nil, page = 1, per_page = 20)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).get_records(sort_by_field, sort_order, page, per_page)
      end

      def upload_attachment(file_path)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).upload_attachment(file_path)
      end

      def upload_link_as_attachment(link_url)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).upload_link_as_attachment(link_url)
      end

      def download_attachment(attachment_id)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).download_attachment(attachment_id)
      end

      def delete_attachment(attachment_id)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).delete_attachment(attachment_id)
      end

      def add_relation
        Handler::RelatedListAPIHandler.get_instance(@parent_record, @junction_record).add_relation
      end

      def remove_relation
        Handler::RelatedListAPIHandler.get_instance(@parent_record, @junction_record).remove_relation
      end

      def add_note(zcrm_note_ins)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).add_note(zcrm_note_ins)
      end

      def update_note(zcrm_note_ins)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).update_note(zcrm_note_ins)
      end

      def delete_note(zcrm_note_ins)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).delete_note(zcrm_note_ins)
      end

      def get_notes(sort_by = nil, sort_order = nil, page = 1, per_page = 20)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).get_notes(sort_by, sort_order, page, per_page)
      end

      def get_attachments(page = 1, per_page = 20)
        Handler::RelatedListAPIHandler.get_instance(@parent_record, self).get_attachments(page, per_page)
      end
    end
    # THIS CLASS IS USED TO STORE AND EXECUTE NOTES RELATED FUNCTIONALITY
    class ZCRMNote
      attr_accessor :is_editable, :id, :parent_record, :title, :content, :owner, :created_by, :created_time, :modified_by, :modified_time, :attachments, :size, :is_voice_note, :parent_module, :parent_name, :parent_id
      def initialize(parent_record = nil, note_id = nil)
        @id = note_id
        @parent_record = parent_record
        @title = nil
        @content = nil
        @owner = nil
        @created_by = nil
        @created_time = nil
        @modified_by = nil
        @modified_time = nil
        @attachments = nil
        @size = nil
        @is_voice_note = nil
        @parent_module = nil
        @parent_name = nil
        @parent_id = nil
        @is_editable = nil
      end

      def upload_attachment(file_path)
        ZCRMModuleRelation.get_instance(ZCRMRecord.get_instance('Notes', @id), 'Attachments').upload_attachment(file_path)
      end

      def download_attachment(attachment_id)
        ZCRMModuleRelation.get_instance(ZCRMRecord.get_instance('Notes', @id), 'Attachments').download_attachment(attachment_id)
      end

      def get_attachments(page = 1, per_page = 20)
        ZCRMModuleRelation.get_instance(ZCRMRecord.get_instance('Notes', @id), 'Attachments').get_attachments(page, per_page)
      end

      def delete_attachment(attachment_id)
        ZCRMModuleRelation.get_instance(ZCRMRecord.get_instance('Notes', @id), 'Attachments').delete_attachment(attachment_id)
      end

      def self.get_instance(parent_record = nil, note_id = nil)
        ZCRMNote.new(parent_record = nil, note_id)
      end
    end
    # THIS CLASS IS USED TO STORE PROFILE PERMISSIONS RELATED DATA
    class ZCRMPermission
      attr_accessor :id, :name, :display_label, :module_api_name, :is_enabled
      def initialize(permission_name, permission_id)
        @id = permission_id
        @name = permission_name
        @display_label = nil
        @module_api_name = nil
        @is_enabled = nil
      end

      def self.get_instance(permission_name, permission_id)
        ZCRMPermission.new(permission_name, permission_id)
      end
    end
    # THIS CLASS IS USED TO STORE PICK LIST VALUE RELATED DATA
    class ZCRMPickListValue
      attr_accessor :display_value, :sequence_number, :actual_value, :maps
      def initialize
        @display_value = nil
        @sequence_number = nil
        @actual_value = nil
        @maps = nil
      end

      def self.get_instance
        ZCRMPickListValue.new
      end
    end
    # THIS CLASS IS USED TO STORE MULTI SELECT LOOKUP RELATED DATA
    class ZCRMMultiSelectLookupField
      attr_accessor :display_label, :linking_module, :connected_module, :api_name, :id
      def initialize(api_name)
        @display_label = nil
        @linking_module = nil
        @connected_module = nil
        @api_name = api_name
        @id = nil
      end

      def self.get_instance(api_name)
        ZCRMMultiSelectLookupField.new(api_name)
      end
    end
    # THIS CLASS IS USED TO STORE PROFILE RELATED DATA
    class ZCRMProfile
      attr_accessor :name, :id, :is_default, :created_time, :modified_time, :modified_by, :description, :created_by, :category, :permissions, :sections
      def initialize(profile_id, profile_name = nil)
        @name = profile_name
        @id = profile_id
        @is_default = nil
        @created_time = nil
        @modified_time = nil
        @modified_by = nil
        @description = nil
        @created_by = nil
        @category = nil
        @permissions = []
        @sections = []
      end

      def self.get_instance(profile_id, profile_name = nil)
        ZCRMProfile.new(profile_id, profile_name)
      end
    end
    # THIS CLASS IS USED TO STORE PROFILE CATEGORY DATA
    class ZCRMProfileCategory
      attr_accessor :name, :module_api_name, :display_label, :permission_ids
      def initialize(profile_category_name)
        @name = profile_category_name
        @module_api_name = nil
        @display_label = nil
        @permission_ids = []
      end

      def self.get_instance(profile_category_name)
        ZCRMProfileCategory.new(profile_category_name)
      end
    end
    # THIS CLASS IS USED TO STORE PROFILE SECTION DATA
    class ZCRMProfileSection
      attr_accessor :name, :categories
      def initialize(section_name)
        @name = section_name
        @categories = []
      end

      def self.get_instance(section_name)
        ZCRMProfileSection.new(section_name)
      end
    end
    # THIS CLASS IS USED TO STORE RELATED LIST PROPERTIES RELATED DATA
    class ZCRMRelatedListProperties
      attr_accessor :sort_by, :sort_order, :fields
      def initialize
        @sort_by = nil
        @sort_order = nil
        @fields = nil
      end

      def self.get_instance
        ZCRMRelatedListProperties.new
      end
    end
    # THIS CLASS IS USED TO STORE SECTIONS RELATED DATA
    class ZCRMSection
      attr_accessor :properties, :api_name, :name, :display_label, :column_count, :sequence_number, :fields, :is_subform_section, :tab_traversal
      def initialize(section_name)
        @name = section_name
        @display_label = nil
        @column_count = nil
        @sequence_number = nil
        @fields = nil
        @is_subform_section = nil
        @tab_traversal = nil
        @api_name = nil
        @properties = nil
      end

      def self.get_instance(section_name)
        ZCRMSection.new(section_name)
      end
    end
    # THIS CLASS IS USED TO STORE SECTION PROPERTIES RELATED DATA
    class ZCRMSectionProperties
      attr_accessor :reorder_rows, :tooltip, :maximum_rows
      def initialize
        @reorder_rows = nil
        @tooltip = nil
        @maximum_rows = nil
      end

      def self.get_instance
        ZCRMSectionProperties.new
      end
    end
    # THIS CLASS IS USED TO STORE TRASH RECORD RELATED DATA
    class ZCRMTrashRecord
      attr_accessor :id, :type, :display_name, :deleted_time, :created_by, :deleted_by, :module_api_name
      def initialize(module_api_name, entity_type, entity_id = nil)
        @id = entity_id
        @module_api_name = module_api_name
        @type = entity_type
        @display_name = nil
        @deleted_time = nil
        @created_by = nil
        @deleted_by = nil
      end

      def self.get_instance(module_api_name, entity_type, entity_id = nil)
        ZCRMTrashRecord.new(module_api_name, entity_type, entity_id)
      end
    end
  end
end
