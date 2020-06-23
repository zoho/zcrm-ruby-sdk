# frozen_string_literal: true

require_relative 'utility'
require_relative 'operations'
require_relative 'request'
require_relative 'org'
require 'json'
module ZCRMSDK
  module Handler
    # THIS CLASS SERVES AS A PARENT CLASS TO OTHER HANDLER CLASSES
    class APIHandler
      attr_accessor :request_url_path, :request_body, :request_headers, :request_params, :request_method, :request_api_key
      def initialize
        @request_url_path = nil
        @request_body = nil
        @request_headers = nil
        @request_params = nil
        @request_method = nil
        @request_api_key = nil
      end

      def self.get_instance
        APIHandler.new
      end

      def add_param(key, value)
        @request_params = {} if @request_params.nil?
        @request_params.store(key, value)
      end

      def add_header(key, value)
        @request_headers = {} if @request_headers.nil?
        @request_headers.store(key, value)
      end
    end
    # THIS CLASS IS USED TO HANDLE SINGLE ENTITY RELATED FUNCTIONALITY
    class EntityAPIHandler < APIHandler
      def initialize(zcrm_record)
        @zcrmrecord = zcrm_record
      end

      def self.get_instance(zcrm_record)
        EntityAPIHandler.new(zcrm_record)
      end

      def get_record
        if @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('get_record', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the record', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name + '/' + @zcrmrecord.entity_id.to_s
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        obj = EntityAPIHandlerHelper.get_instance
        obj.set_record_properties(@zcrmrecord, api_response.response_json.dig(Utility::APIConstants::DATA, 0))
        api_response.data = @zcrmrecord
        api_response
      end

      def create_record
        unless @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('create_record', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should not be set for the record', 'ID PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        helper_obj = EntityAPIHandlerHelper.get_instance
        input_json = helper_obj.get_zcrmrecord_as_json(@zcrmrecord)
        handler_ins.request_body = Utility::CommonUtil.create_api_supported_input_json(input_json, Utility::APIConstants::DATA)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::DATA, 0, 'details')
        @zcrmrecord.entity_id = response_details['id']
        @zcrmrecord.created_time = response_details['Created_Time']
        created_by = response_details['Created_By']
        @zcrmrecord.created_by = Operations::ZCRMUser.get_instance(created_by['id'], created_by['name'])
        api_response.data = @zcrmrecord
        api_response
      end

      def update_record
        if @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('update_record', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the record', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name + '/' + @zcrmrecord.entity_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = Utility::APIConstants::DATA
        helper_obj = EntityAPIHandlerHelper.get_instance
        input_json = helper_obj.get_zcrmrecord_as_json(@zcrmrecord)
        handler_ins.request_body = Utility::CommonUtil.create_api_supported_input_json(input_json, Utility::APIConstants::DATA)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::DATA, 0, 'details')
        @zcrmrecord.entity_id = response_details['id']
        @zcrmrecord.created_time = response_details['Created_Time']
        @zcrmrecord.modified_time = response_details['Modified_Time']
        created_by = response_details['Created_By']
        @zcrmrecord.created_by = Operations::ZCRMUser.get_instance(created_by['id'], created_by['name'])
        modified_by = response_details['Modified_By']
        @zcrmrecord.modified_by = Operations::ZCRMUser.get_instance(modified_by['id'], modified_by['name'])
        api_response.data = @zcrmrecord
        api_response
      end

      def delete_record
        if @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('delete_record', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the record', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name + '/' + @zcrmrecord.entity_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def convert_record(potential_record, details)
        if @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('convert_record', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the record', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name + '/' + @zcrmrecord.entity_id.to_s + '/actions/convert'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        input_json = {}
        unless details.nil?
          details.each do |key, value|
            input_json[key] = value
          end
        end
        unless potential_record.nil?
          entity_helper = EntityAPIHandlerHelper.get_instance
          input_json['Deals'] = entity_helper.get_zcrmrecord_as_json(potential_record)
        end
        unless details.nil? && potential_record.nil?
          input_json_arr = []
          input_json_arr.push(input_json)
          req_body_json = {}
          req_body_json.store(Utility::APIConstants::DATA, input_json_arr)
          handler_ins.request_body = req_body_json
        end
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        converted_dict = {}
        converted_ids_json = api_response.response_json.dig(Utility::APIConstants::DATA, 0)
        if converted_ids_json.key?(Utility::APIConstants::CONTACTS) && !converted_ids_json.dig(Utility::APIConstants::CONTACTS).nil?
          converted_dict.store(Utility::APIConstants::CONTACTS, converted_ids_json.dig(Utility::APIConstants::CONTACTS))
        end
        if converted_ids_json.key?(Utility::APIConstants::ACCOUNTS) && !converted_ids_json.dig(Utility::APIConstants::ACCOUNTS).nil?
          converted_dict.store(Utility::APIConstants::ACCOUNTS, converted_ids_json.dig(Utility::APIConstants::ACCOUNTS))
        end
        if converted_ids_json.key?(Utility::APIConstants::DEALS) && !converted_ids_json.dig(Utility::APIConstants::DEALS).nil?
          converted_dict.store(Utility::APIConstants::DEALS, converted_ids_json.dig(Utility::APIConstants::DEALS))
        end
        converted_dict
      end

      def upload_photo(file_path)
        if file_path.nil?
          raise Utility::ZCRMException.get_instance('upload_photo', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'file path must be given', 'FILEPATH NOT PROVIDED')
        end
        if @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('upload_photo', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the record for uploading', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name + '/' + @zcrmrecord.entity_id.to_s + '/photo'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).upload_file(file_path)
        api_response
      end

      def download_photo
        if @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('download_photo', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the record for uploading', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name + '/' + @zcrmrecord.entity_id.to_s + '/photo'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::DATA
        Request::APIRequest.get_instance(handler_ins).download_file
      end

      def delete_photo
        if @zcrmrecord.entity_id.nil?
          raise Utility::ZCRMException.get_instance('delete_photo', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the record for uploading', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @zcrmrecord.module_api_name + '/' + @zcrmrecord.entity_id.to_s + '/photo'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::DATA
        Request::APIRequest.get_instance(handler_ins).get_api_response
      end
    end
    # THIS CLASS IS USED TO HANDLE MASS ENTITY RELATED FUNCTIONALITY
    class MassEntityAPIHandler < APIHandler
      def initialize(module_ins)
        @module_instance = module_ins
      end

      def self.get_instance(module_ins)
        MassEntityAPIHandler.new(module_ins)
      end

      def get_records(cvid, sort_by, sort_order, page, per_page, headers)
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path += @module_instance.api_name
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.add_param('cvid', cvid) unless cvid.nil?
        handler_ins.add_param('sort_by', sort_by) unless sort_by.nil?
        handler_ins.add_param('sort_order', sort_order) unless sort_order.nil?
        unless headers.nil?
          headers.each do |key, value|
            handler_ins.add_header(key, value)
          end
        end
        handler_ins.add_param('page', page)
        handler_ins.add_param('per_page', per_page)
        handler_ins.request_api_key = Utility::APIConstants::DATA
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        data_arr = bulk_api_response.response_json[Utility::APIConstants::DATA]
        entity_helper = EntityAPIHandlerHelper.get_instance
        record_ins_list = []
        unless data_arr.nil?
          data_arr.each do |record_data|
            zcrm_record = Operations::ZCRMRecord.get_instance(@module_instance.api_name, record_data['id'])
            entity_helper.set_record_properties(zcrm_record, record_data)
            record_ins_list.push(zcrm_record)
          end
        end
        bulk_api_response.data = record_ins_list
        bulk_api_response
      end

      def create_records(record_ins_array, lar_id)
        if record_ins_array.length > 100
          raise Utility::ZCRMException.get_instance('create_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be less than or equals to 100', 'MORE RECORDS PROVIDED')
        end

        if record_ins_array.length < 1
          raise Utility::ZCRMException.get_instance('create_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be at least 1', 'NO RECORDS PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path += @module_instance.api_name
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        helper_obj = EntityAPIHandlerHelper.get_instance
        data_array = []
        record_ins_array.each do |zcrm_record|
          if zcrm_record.entity_id.nil?
            data_array.push(helper_obj.get_zcrmrecord_as_json(zcrm_record))
          else
            raise Utility::ZCRMException.get_instance('Records_Create', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'record id must be nil', 'ID IS PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::DATA] = data_array
        request_json['lar_id'] = lar_id unless lar_id.nil?
        handler_ins.request_body = request_json
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        created_records = []
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length
        length -= 1
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS

          record_create_details = entity_response_ins.details
          new_record = record_ins_array[i]
          entity_helper = EntityAPIHandlerHelper.get_instance
          entity_helper.set_record_properties(new_record, record_create_details)
          created_records.push(new_record)
          entity_response_ins.data = new_record
        end
        bulk_api_response.data = created_records
        bulk_api_response
      end

      def upsert_records(record_ins_array, duplicate_check_fields, lar_id)
        if record_ins_array.length > 100
          raise Utility::ZCRMException.get_instance('upsert_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be less than or equals to 100', 'MORE RECORDS PROVIDED')
        end

        if record_ins_array.length < 1
          raise Utility::ZCRMException.get_instance('upsert_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be at least 1', 'NO RECORDS PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @module_instance.api_name + '/upsert'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        helper_obj = EntityAPIHandlerHelper.get_instance
        data_array = []
        record_ins_array.each do |zcrm_record|
          input_json = helper_obj.get_zcrmrecord_as_json(zcrm_record)
          unless zcrm_record.entity_id.nil?
            input_json['id'] = zcrm_record.entity_id.to_s
          end
          data_array.push(input_json)
        end
        request_json['lar_id'] = lar_id unless lar_id.nil?
        unless duplicate_check_fields.nil?
          ids_as_string = ''
          duplicate_check_fields.each do |duplicate_check_field|
            ids_as_string += duplicate_check_field.to_s + ','
          end
          handler_ins.add_param('duplicate_check_fields', ids_as_string)
        end

        request_json = {}
        request_json[Utility::APIConstants::DATA] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        upsert_records = []
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length
        length -= 1
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS

          record_upsert_details = entity_response_ins.details
          new_record = record_ins_array[i]
          entity_helper = EntityAPIHandlerHelper.get_instance
          entity_helper.set_record_properties(new_record, record_upsert_details)
          upsert_records.push(new_record)
          entity_response_ins.data = new_record
        end
        bulk_api_response.data = upsert_records
        bulk_api_response
      end

      def update_records(record_ins_array)
        if record_ins_array.length > 100
          raise Utility::ZCRMException.get_instance('update_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be less than or equals to 100', 'MORE RECORDS PROVIDED')
        end

        if record_ins_array.length < 1
          raise Utility::ZCRMException.get_instance('update_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be at least 1', 'NO RECORDS PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path += @module_instance.api_name
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = Utility::APIConstants::DATA
        helper_obj = EntityAPIHandlerHelper.get_instance
        data_array = []
        record_ins_array.each do |zcrm_record|
          input_json = helper_obj.get_zcrmrecord_as_json(zcrm_record)
          if !zcrm_record.entity_id.nil?
            input_json['id'] = zcrm_record.entity_id.to_s
          else
            raise Utility::ZCRMException.get_instance('Records_Update', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'record id must not be nil', 'RECORD ID NOT PROVIDED')
          end
          data_array.push(input_json)
        end
        request_json = {}
        request_json[Utility::APIConstants::DATA] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        updated_records = []
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length
        length -= 1
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS

          record_update_details = entity_response_ins.details
          new_record = record_ins_array[i]
          entity_helper = EntityAPIHandlerHelper.get_instance
          entity_helper.set_record_properties(new_record, record_update_details)
          updated_records.push(new_record)
          entity_response_ins.data = new_record
        end
        bulk_api_response.data = updated_records
        bulk_api_response
      end

      def mass_update_records(entityid_list, field_api_name, value)
        if entityid_list.length > 100
          raise Utility::ZCRMException.get_instance('mass_update_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be less than or equals to 100', 'MORE RECORDS PROVIDED')
        end

        if entityid_list.length < 1
          raise Utility::ZCRMException.get_instance('mass_update_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be at least 1', 'NO RECORDS PROVIDED')
        end

        if field_api_name.nil?
          raise Utility::ZCRMException.get_instance('mass_update_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'field api name must be provided', 'NO FIELD APINAME PROVIDED')
        end

        if value.nil?
          raise Utility::ZCRMException.get_instance('mass_update_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'value must be provided', 'NO VALUE PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path += @module_instance.api_name
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = Utility::APIConstants::DATA
        massentity_helper = MassEntityAPIHandlerHelper.get_instance
        handler_ins.request_body = massentity_helper.construct_json_for_massupdate(entityid_list, field_api_name, value)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        updated_records = []
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length - 1
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS

          record_update_details = entity_response_ins.details
          new_record = Operations::ZCRMRecord.get_instance(@module_instance.api_name, record_update_details['id'])
          updated_records.push(new_record)
          entity_response_ins.data = new_record
        end
        bulk_api_response.data = updated_records
        bulk_api_response
      end

      def delete_records(entityid_list)
        if entityid_list.length > 100
          raise Utility::ZCRMException.get_instance('delete_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be less than or equals to 100', 'MORE RECORDS PROVIDED')
        end

        if entityid_list.length < 1
          raise Utility::ZCRMException.get_instance('delete_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be at least 1', 'NO RECORDS PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path += @module_instance.api_name
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::DATA
        ids_as_string = ''
        entityid_list.each do |entity_id|
          ids_as_string += entity_id.to_s + ','
        end
        handler_ins.add_param('ids', ids_as_string)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length - 1
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          record_delete_details = entity_response_ins.details
          entity_response_ins.data = Operations::ZCRMRecord.get_instance(@module_instance.api_name, record_delete_details['id'])
        end
        bulk_api_response
      end

      def search_records(search_word, page, per_page, type)
        if search_word.nil?
          raise Utility::ZCRMException.get_instance('search_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'search word must be given', 'SEARCH WORD NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_url_path = @module_instance.api_name + '/search'
        case type
        when 'word'
          handler_ins.add_param('word', search_word)
        when 'phone'
          handler_ins.add_param('phone', search_word)
        when 'email'
          handler_ins.add_param('email', search_word)
        when 'criteria'
          handler_ins.add_param('criteria', search_word)
        end
        handler_ins.add_param('page', page)
        handler_ins.add_param('per_page', per_page)
        handler_ins.request_api_key = Utility::APIConstants::DATA
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        data_arr = bulk_api_response.response_json[Utility::APIConstants::DATA]
        entity_helper = EntityAPIHandlerHelper.get_instance
        record_ins_list = []
        data_arr.each do |record_data|
          zcrm_record = Operations::ZCRMRecord.get_instance(@module_instance.api_name, record_data['id'])
          entity_helper.set_record_properties(zcrm_record, record_data)
          record_ins_list.push(zcrm_record)
        end
        bulk_api_response.data = record_ins_list
        bulk_api_response
      end

      def get_deleted_records(trashed_type, page, per_page)
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @module_instance.api_name + '/deleted'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::DATA
        handler_ins.add_param('page', page)
        handler_ins.add_param('per_page', per_page)
        handler_ins.add_param('type', trashed_type) unless trashed_type.nil?
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        data_arr = bulk_api_response.response_json[Utility::APIConstants::DATA]
        record_ins_list = []
        massentity_helper = MassEntityAPIHandlerHelper.get_instance
        data_arr.each do |record_data|
          trash_record = Operations::ZCRMTrashRecord.get_instance(@module_instance.api_name, record_data['type'], record_data['id'])
          massentity_helper.set_trash_record_properties(trash_record, record_data)
          record_ins_list.push(trash_record)
        end
        bulk_api_response.data = record_ins_list
        bulk_api_response
      end
    end
    # THIS CLASS IS USED TO HANDLE MODULE RELATED FUNCTIONALITY
    class ModuleAPIHandler < APIHandler
      def initialize(module_instance)
        @module_instance = module_instance
      end

      def self.get_instance(module_ins)
        ModuleAPIHandler.new(module_ins)
      end

      def get_field(field_id)
        if field_id.nil?
          raise Utility::ZCRMException.get_instance('get_field', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'field id must be given', 'FIELD ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/fields/' + field_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::FIELDS
        handler_ins.add_param('module', @module_instance.api_name)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        module_api_helper = ModuleAPIHandlerHelper.get_instance
        api_response.data = module_api_helper.get_zcrmfield(api_response.response_json[Utility::APIConstants::FIELDS][0])
        api_response
      end

      def get_all_fields
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/fields'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::FIELDS
        handler_ins.add_param('module', @module_instance.api_name)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        fields = bulk_api_response.response_json[Utility::APIConstants::FIELDS]
        field_instance_arr = []
        module_api_helper = ModuleAPIHandlerHelper.get_instance
        fields.each do |field|
          field_instance_arr.push(module_api_helper.get_zcrmfield(field))
        end
        bulk_api_response.data = field_instance_arr
        bulk_api_response
      end

      def get_all_layouts
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/layouts'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::LAYOUTS
        handler_ins.add_param('module', @module_instance.api_name)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        layouts = bulk_api_response.response_json[Utility::APIConstants::LAYOUTS]
        layout_instance_arr = []
        module_api_helper = ModuleAPIHandlerHelper.get_instance
        layouts.each do |layout|
          layout_instance_arr.push(module_api_helper.get_zcrmlayout(layout))
        end
        bulk_api_response.data = layout_instance_arr
        bulk_api_response
      end

      def get_layout(layout_id)
        if layout_id.nil?
          raise Utility::ZCRMException.get_instance('get_layout', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'layout id must be given', 'LAYOUT ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/layouts/' + layout_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::LAYOUTS
        handler_ins.add_param('module', @module_instance.api_name)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        module_api_helper = ModuleAPIHandlerHelper.get_instance
        api_response.data = module_api_helper.get_zcrmlayout(api_response.response_json[Utility::APIConstants::LAYOUTS][0])
        api_response
      end

      def get_all_customviews
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/custom_views'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::CUSTOM_VIEWS
        handler_ins.add_param('module', @module_instance.api_name)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        response_json = bulk_api_response.response_json
        categories = response_json['info'].key?('translation') ? response_json['info']['translation'] : nil
        customviews = response_json[Utility::APIConstants::CUSTOM_VIEWS]
        customview_instances = []
        meta_data_api_helper = MetaDataAPIHandlerHelper.get_instance
        customviews.each do |customview|
          customview_instances.push(meta_data_api_helper.get_zcrm_customview(customview, @module_instance.api_name, categories))
        end
        bulk_api_response.data = customview_instances
        bulk_api_response
      end

      def get_customview(customview_id)
        if customview_id.nil?
          raise Utility::ZCRMException.get_instance('get_customview', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'custom view id must be given', 'CUSTOM VIEW ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/custom_views/' + customview_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::CUSTOM_VIEWS
        handler_ins.add_param('module', @module_instance.api_name)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_json = api_response.response_json
        categories = response_json['info'].key?('translation') ? response_json['info']['translation'] : nil
        meta_data_api_helper = MetaDataAPIHandlerHelper.get_instance
        api_response.data = meta_data_api_helper.get_zcrm_customview(response_json[Utility::APIConstants::CUSTOM_VIEWS][0], @module_instance.api_name, categories)
        api_response
      end

      def update_customview(customview_instance)
        if customview_instance.nil?
          raise Utility::ZCRMException.get_instance('update_customview', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'custom view instance must be given', 'NO CUSTOM VIEW INSTANCE PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/custom_views/' + customview_instance.id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.add_param('module', @module_instance.api_name)
        module_api_helper = ModuleAPIHandlerHelper.get_instance
        handler_ins.request_body = module_api_helper.construct_json_for_cv_update(customview_instance)
        Request::APIRequest.get_instance(handler_ins).get_api_response
      end

      def get_all_relatedlists
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/related_lists'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.add_param('module', @module_instance.api_name)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        response_json = bulk_api_response.response_json
        related_lists = response_json[Utility::APIConstants::RELATED_LISTS]
        relatedlist_instances = []
        module_api_helper = ModuleAPIHandlerHelper.get_instance
        related_lists.each do |related_list|
          relatedlist_instances.push(module_api_helper.get_zcrm_module_related_list(related_list))
        end
        bulk_api_response.data = relatedlist_instances
        bulk_api_response
      end

      def get_relatedlist(relatedlist_id)
        if relatedlist_id.nil?
          raise Utility::ZCRMException.get_instance('get_relatedlist', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Related list id must be given', 'NO RELATED LIST ID PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/related_lists/' + relatedlist_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.add_param('module', @module_instance.api_name)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_json = api_response.response_json
        related_list = response_json[Utility::APIConstants::RELATED_LISTS][0]
        module_api_helper = ModuleAPIHandlerHelper.get_instance
        api_response.data = module_api_helper.get_zcrm_module_related_list(related_list)
        api_response
      end
    end
    # THIS CLASS SERVES THE MassEntityAPIHandler CLASS CONSTRUCTING JSON BODY AND INSTANCES
    class MassEntityAPIHandlerHelper
      def initialize; end

      def self.get_instance
        MassEntityAPIHandlerHelper.new
      end

      def set_trash_record_properties(trash_record_ins, record_data)
        if record_data.key?('display_name')
          trash_record_ins.display_name = record_data['display_name']
        end
        if record_data.key?('created_by')
          unless record_data['created_by'].nil?
            trash_record_ins.created_by = Operations::ZCRMUser.get_instance(record_data['created_by']['id'], record_data['created_by']['name'])
          end
        end
        if record_data.key?('deleted_by')
          unless record_data['deleted_by'].nil?
            trash_record_ins.deleted_by = Operations::ZCRMUser.get_instance(record_data['deleted_by']['id'], record_data['deleted_by']['name'])
          end
        end
        trash_record_ins.deleted_time = record_data['deleted_time']
      end

      def construct_json_for_massupdate(entityid_list, field_api_name, field_value)
        input_json_arr = []
        entityid_list.each do |entity_id|
          each_json = {}
          each_json['id'] = entity_id.to_s
          each_json[field_api_name] = field_value
          input_json_arr.push(each_json)
        end
        data_json = {}
        data_json[Utility::APIConstants::DATA] = input_json_arr
        data_json
      end
    end
    # THIS CLASS SERVES THE EntityAPIHandler CLASS CONSTRUCTING JSON BODY AND INSTANCES
    class EntityAPIHandlerHelper
      def initialize; end

      def self.get_instance
        EntityAPIHandlerHelper.new
      end
            
      def get_zcrmrecord_as_json(zcrmrecord)
        record_json = {}
        apiname_vs_values = zcrmrecord.field_data
        record_json['Owner'] = zcrmrecord.owner.id unless zcrmrecord.owner.nil?
        unless zcrmrecord.layout.nil?
          record_json['Layout'] = zcrmrecord.layout.id
        end
        unless zcrmrecord.line_items.empty?
          record_json['Product_Details'] = get_line_item_json(zcrmrecord.line_items)
        end
        unless zcrmrecord.participants.empty?
          record_json['Participants'] = get_participants_as_jsonarray(zcrmrecord)
        end
        unless zcrmrecord.price_details.empty?
          record_json['Pricing_Details'] = get_price_details_as_jsonarray(zcrmrecord)
        end
        unless zcrmrecord.tax_list.empty?
          record_json['Tax'] = get_tax_list_as_json(zcrmrecord)
        end
        unless zcrmrecord.tag_list.empty?
          record_json['Tag'] = get_tag_list_as_json(zcrmrecord)
        end
        unless apiname_vs_values.empty?
          apiname_vs_values.each do |key, value|
            if value.is_a?(Operations::ZCRMRecord)
              value = value.entity_id
            elsif value.is_a?(Operations::ZCRMUser)
              value = value.id
            end
            record_json.store(key, value)
          end
        end
        record_json
      end

      def get_tag_list_as_json(zcrmrecord)
        tag_list_json_arr = []
        tag_list = zcrmrecord.tag_list
        tag_list.each do |tag_ins|
          tag = {}
          tag['name'] = tag_ins.name unless tag_ins.name.nil?
          tag['id'] = tag_ins.id unless tag_ins.id.nil?
          tag_list_json_arr.push(tag)
        end
        tag_list_json_arr
      end

      def get_tax_list_as_json(zcrmrecord)
        tax_list_json_arr = []
        tax_list = zcrmrecord.tax_list
        tax_list.each do |tax_ins|
          tax_list_json_arr.push(tax_ins.name)
        end
        tax_list_json_arr
      end

      def get_price_details_as_jsonarray(zcrmrecord)
        price_details_arr = []
        price_details_list = zcrmrecord.price_details
        price_details_list.each do |price_book_pricing_ins|
          price_details_arr.push(get_zcrmprice_detail_as_json(price_book_pricing_ins))
        end
        price_details_arr
      end

      def get_zcrmprice_detail_as_json(price_book_pricing_ins)
        price_detail_json = {}
        unless price_book_pricing_ins.id.nil?
          price_detail_json['id'] = price_book_pricing_ins.id
        end
        price_detail_json['discount'] = price_book_pricing_ins.discount
        price_detail_json['to_range'] = price_book_pricing_ins.to_range
        price_detail_json['from_range'] = price_book_pricing_ins.from_range
        price_detail_json
      end

      def get_participants_as_jsonarray(zcrmrecord)
        participants_arr = []
        participants_list = zcrmrecord.participants
        participants_list.each do |participant_ins|
          participants_arr.push(get_zcrmparticipant_as_json(participant_ins))
        end
        participants_arr
      end

      def get_zcrmparticipant_as_json(participant_ins)
        participant_json = {}
        participant_json['participant'] = participant_ins.id
        participant_json['type'] = participant_ins.type
        participant_json['name'] = participant_ins.name
        participant_json['Email'] = participant_ins.email
        participant_json['invited'] = participant_ins.is_invited == true
        participant_json['status'] = participant_ins.status
        participant_json
      end

      def get_line_item_json(line_items_array)
        line_items_as_json_array = []
        line_items_array.each do |line_item|
          line_item_data = {}
          if line_item.quantity.nil?
            raise Utility::ZCRMException.get_instance(@request_url_path, Utility::APIConstants::RESPONSECODE_BAD_REQUEST, "Mandatory Field 'quantity' is missing.", nil)
          end

          line_item_data['id'] = line_item.id unless line_item.id.nil?
          unless line_item.product.nil?
            line_item_data['product'] = line_item.product.entity_id
          end
          unless line_item.description.nil?
            line_item_data['product_description'] = line_item.description
          end
          unless line_item.list_price.nil?
            line_item_data['list_price'] = line_item.list_price
          end
          line_item_data['quantity'] = line_item.quantity
          line_item_data['Discount'] = if line_item.discount_percentage.nil?
                                         line_item.discount
                                       else
                                         line_item.discount_percentage + '%'
                                       end

          unless line_item.line_tax.nil?
            line_taxes = line_item.line_tax
            line_tax_array = []
            line_taxes.each do |line_tax_instance|
              tax = {}
              tax['name'] = line_tax_instance.name
              tax['value'] = line_tax_instance.value
              tax['percentage'] = line_tax_instance.percentage
              line_tax_array.push(tax)
              line_item_data['line_tax'] = line_tax_array
            end
          end
          line_items_as_json_array.push(line_item_data)
        end
        line_items_as_json_array
      end

      def get_zcrm_pricebook_pricing(price_details)
        price_detail_ins = Operations::ZCRMPriceBookPricing.get_instance(price_details['id'])
        price_detail_ins.discount = price_details['discount'].to_f
        price_detail_ins.to_range = price_details['to_range'].to_f
        price_detail_ins.from_range = price_details['from_range'].to_f
        price_detail_ins
      end

      def get_zcrmparticipant(participant_details)
        type = participant_details['type']
        id = nil
        email = nil
        if participant_details.key?('Email')
          id = participant_details['participant']
          email = participant_details['Email']
        else
          email =  participant_details['participant']
        end
        participant = Operations::ZCRMEventParticipant.get_instance(participant_details['type'], id)
        participant.name = participant_details['name']
        participant.email = email
        participant.is_invited = participant_details['invited'] == true
        participant.status = participant_details['status']
        participant
      end

      def get_zcrminventory_line_item(line_item_details)
        product_details = line_item_details['product']
        line_item_instance = Operations::ZCRMInventoryLineItem.get_instance(line_item_details['id'])
        product = Operations::ZCRMRecord.get_instance('Products', product_details['id'])
        product.lookup_label = product_details['name']
        if product_details.key?('Product_Code')
          product.field_data['Product_Code'] = product_details['Product_Code']
        end
        line_item_instance.product = product
        line_item_instance.description = line_item_details['product_description']
        line_item_instance.quantity = line_item_details['quantity'].to_i
        line_item_instance.list_price = line_item_details['list_price'].to_f
        line_item_instance.total = line_item_details['total'].to_f
        line_item_instance.discount = line_item_details['Discount'].to_f
        line_item_instance.total_after_discount = line_item_details['total_after_discount'].to_f
        line_item_instance.tax_amount = line_item_details['Tax'].to_f
        line_taxes = line_item_details['line_tax']
        unless line_taxes.nil?
          line_taxes.each do |line_tax|
            tax_instance = Operations::ZCRMTax.get_instance(line_tax['name'])
            tax_instance.percentage = line_tax['percentage']
            tax_instance.value = line_tax['value'].to_f
            line_item_instance.line_tax.push(tax_instance)
          end
        end
        line_item_instance.net_total = line_item_details['net_total'].to_f
        line_item_instance
      end

      def get_zcrmsubform(sub_form_details)
        sub_form_instance = Operations::ZCRMSubForm.get_instance(sub_form_details['id'])
        sub_form_details.each do |key, value|
          if key == 'Created_Time'
            sub_form_instance.created_time = value
          elsif key == 'Modified_Time'
            sub_form_instance.modified_time = value
          elsif key == 'Owner'
            owner = Operations::ZCRMUser.get_instance(value['id'], value['name'])
            sub_form_instance.owner = owner
          elsif key == 'Layout'
            layout = nil
            unless value.nil?
              layout = Operations::ZCRMLayout.get_instance(value['id'])
              layout.name = value['name']
            end
            sub_form_instance.layout = layout
          elsif key.start_with?('$')
            sub_form_instance.properties.store(key.gsub('$', ''), value)
          elsif value.is_a?(Hash) && !value.empty?
            lookup_record = Operations::ZCRMRecord.get_instance(key, value.dig('id'))
            lookup_record.name = value.key?('name') ? value.dig('name') : nil
            sub_form_instance.field_data.store(key, lookup_record)
          elsif value.is_a?(Array) && !value.empty?
            arrayinstances = value
            fieldarray = []
            arrayinstances.each do |arrayinstance|
              if arrayinstance.is_a?(Hash) && !arrayinstance.empty?
                fieldarray.push(entity_api_handler_helper.get_zcrmsubform(arrayinstance))
              else
                fieldarray.push(arrayinstance)
              end
            end
            sub_form_instance.field_data.store(key, fieldarray)
          else
            sub_form_instance.field_data.store(key, value)
          end
        end
        sub_form_instance
      end

      def set_record_properties(zcrmrecord, response_hash)
        entity_api_handler_helper = EntityAPIHandlerHelper.get_instance
        response_hash.each do |key, value|
          next if value.nil?

          if key == 'id'
            zcrmrecord.entity_id = value
          elsif key == 'Product_Details' && Utility::APIConstants::INVENTORY_MODULES.include?(zcrmrecord.module_api_name) 
            line_items = value
            line_items.each do |line_item|
              zcrmrecord.line_items.push(entity_api_handler_helper.get_zcrminventory_line_item(line_item))
            end
          elsif key == 'Participants' && zcrmrecord.module_api_name == "Events"
            participants = value
            participants.each do |participant|
              zcrmrecord.participants.push(entity_api_handler_helper.get_zcrmparticipant(participant))
            end
          elsif key == 'Pricing_Details' && zcrmrecord.module_api_name == "Price_Books"
            price_details = value
            price_details.each do |price_detail|
              zcrmrecord.price_details.push(entity_api_handler_helper.get_zcrm_pricebook_pricing(price_detail))
            end
          elsif key == 'Created_By'
            created_by = Operations::ZCRMUser.get_instance(value['id'], value['name'])
            zcrmrecord.created_by = created_by
          elsif key == 'Modified_By'
            modified_by = Operations::ZCRMUser.get_instance(value['id'], value['name'])
            zcrmrecord.modified_by = modified_by
          elsif key == 'Created_Time'
            zcrmrecord.created_time = value
          elsif key == 'Modified_Time'
            zcrmrecord.modified_time = value
          elsif key == 'Owner'
            owner = Operations::ZCRMUser.get_instance(value['id'], value['name'])
            zcrmrecord.owner = owner
          elsif key == 'Layout'
            layout = nil
            unless value.nil?
              layout = Operations::ZCRMLayout.get_instance(value['id'])
              layout.name = value['name']
            end
            zcrmrecord.layout = layout
          elsif (key == 'Handler') && !value.nil?
            handler = Operations::ZCRMUser.get_instance(value['id'], value['name'])
            zcrmrecord.field_data.store(key, handler)
          elsif (key == 'Tax') && value.is_a?(Array) && !value.empty?
            if  value.is_a?(Array) && !value.empty?
              value.each do |tax_name|
                tax_ins = Operations::ZCRMTax.get_instance(tax_name)
                zcrmrecord.tax_list.push(tax_ins)
              end
            end
          elsif key == 'Tag'
            if value.is_a?(Array) && !value.empty?
              value.each do |tag|
                tag_ins = Operations::ZCRMTag.get_instance(tag['id'], tag['name'])
                zcrmrecord.tag_list.push(tag_ins)
              end
            end
          elsif (key == '$line_tax') && value.is_a?(Array) && !value.empty?
            value.each do |line_tax|
              tax_ins = Operations::ZCRMTax.get_instance(line_tax['name'])
              tax_ins.percentage = line_tax['percentage']
              tax_ins.value = line_tax['value']
              zcrmrecord.tax_list.push(tax_ins)
            end
          elsif key.start_with?('$')
            zcrmrecord.properties.store(key.gsub('$', ''), value)
          elsif key == 'Remind_At'
            zcrmrecord.field_data.store(key, value)
          elsif key == 'Recurring_Activity'
            zcrmrecord.field_data.store(key, value)
          elsif value.is_a?(Hash) && !value.empty?
            lookup_record = Operations::ZCRMRecord.get_instance(key, value.dig('id'))
            lookup_record.name = value.key?('name') ? value.dig('name') : nil
            zcrmrecord.field_data.store(key, lookup_record)
          elsif value.is_a?(Array) && !value.empty?
            arrayinstances = value
            fieldarray = []
            arrayinstances.each do |arrayinstance|
              if arrayinstance.is_a?(Hash) && !arrayinstance.empty?
                fieldarray.push(entity_api_handler_helper.get_zcrmsubform(arrayinstance))
              else
                fieldarray.push(arrayinstance)
              end
            end
            zcrmrecord.field_data.store(key, fieldarray)
          else
            zcrmrecord.field_data.store(key, value)
          end
        end
      end
    end
    # THIS CLASS SERVES THE ModuleAPIHandler CLASS CONSTRUCTING JSON BODY AND INSTANCES
    class ModuleAPIHandlerHelper
      def initialize; end

      def self.get_instance
        ModuleAPIHandlerHelper.new
      end

      def construct_json_for_cv_update(customview_instance)
        cv_settings = {}
        unless customview_instance.sort_by.nil?
          field_ins = customview_instance.sort_by
          field_details={}
          unless field_ins.id.nil?
            field_details['id']=field_ins.id
          end
          
          unless field_ins.api_name.nil?
            field_details['api_name']=field_ins.api_name
          end
          cv_settings['sort_by'] = field_details
        end
        unless customview_instance.sort_order.nil?
          cv_settings['sort_order'] = customview_instance.sort_order
        end
        input_json = {}
        input_json[Utility::APIConstants::CUSTOM_VIEWS] = [cv_settings]
        input_json
      end

      def get_zcrm_module_related_list(relatedlist_prop)
        relatedlist_ins = Operations::ZCRMModuleRelatedList.get_instance(relatedlist_prop['api_name'])
        relatedlist_ins.id = relatedlist_prop['id']
        relatedlist_ins.module_apiname = relatedlist_prop['module']
        relatedlist_ins.display_label = relatedlist_prop['display_label']
        relatedlist_ins.name = relatedlist_prop['name']
        relatedlist_ins.type = relatedlist_prop['type']
        relatedlist_ins.href = relatedlist_prop['href']
        relatedlist_ins.is_visible = relatedlist_prop.key?('visible') ? relatedlist_prop['visible'] == true : nil
        relatedlist_ins.action = relatedlist_prop['action']
        relatedlist_ins.sequence_number = relatedlist_prop['sequence_number']
        relatedlist_ins
      end

      def get_picklist_value_instance(picklist)
        picklist_ins = Operations::ZCRMPickListValue.get_instance
        picklist_ins.display_value = picklist['display_value']
        picklist_ins.actual_value = picklist['actual_value']
        if picklist.key?('sequence_number') && !picklist['sequence_number'].nil?
          picklist_ins.sequence_number = picklist['sequence_number']
        end
        picklist_ins.maps = picklist['maps'] if picklist.key?('maps')
        picklist_ins
      end

      def get_multiselect_lookup_field_instance(multi_select_lookup)
        multiselect_lookup_field_instance = Operations::ZCRMMultiSelectLookupField.get_instance(multi_select_lookup['api_name'])
        multiselect_lookup_field_instance.id = multi_select_lookup['id']
        multiselect_lookup_field_instance.connected_module = multi_select_lookup['connected_module']
        multiselect_lookup_field_instance.linking_module = multi_select_lookup['linking_module']
        multiselect_lookup_field_instance.display_label = multi_select_lookup['display_label']
        multiselect_lookup_field_instance
      end

      def get_lookup_field_instance(lookup_field_details)
        lookup_field_instance = Operations::ZCRMLookupField.get_instance(lookup_field_details['api_name'])
        lookup_field_instance.display_label = lookup_field_details['display_label']
        lookup_field_instance.id = lookup_field_details['id']
        lookup_field_instance.module_apiname = lookup_field_details['module']
        lookup_field_instance
      end

      def get_zcrmlayout(layout_details)
        layout_instance = Operations::ZCRMLayout.get_instance(layout_details['id'])
        layout_instance.created_time = layout_details['created_time']
        layout_instance.modified_time = layout_details['modified_time']
        layout_instance.name = layout_details['name']
        layout_instance.is_visible = layout_details['visible'] == true
        layout_instance.created_for = layout_details['created_for']
        unless layout_details['created_by'].nil?
          layout_instance.created_by = Operations::ZCRMUser.get_instance(layout_details['created_by']['id'], layout_details['created_by']['name'])
        end
        unless layout_details['modified_by'].nil?
          layout_instance.modified_by = Operations::ZCRMUser.get_instance(layout_details['modified_by']['id'], layout_details['modified_by']['name'])
        end
        accessible_profile_arr = layout_details['profiles']
        accessible_profile_instances = []
        unless accessible_profile_arr.nil?
          accessible_profile_arr.each do |profile|
            profile_ins = Operations::ZCRMProfile.get_instance(profile['id'], profile['name'])
            profile_ins.is_default = profile['default'] == true
            accessible_profile_instances.push(profile_ins)
          end
        end
        layout_instance.accessible_profiles = accessible_profile_instances
        layout_instance.sections = get_all_sections_of_layout(layout_details['sections'])
        layout_instance.status = layout_details['status']
        if layout_details.key?('convert_mapping')
          convert_modules = %w[Contacts Deals Accounts]

          convert_modules.each do |convert_module|
            next unless layout_details['convert_mapping'].key?(convert_module)

            convert_map = layout_details['convert_mapping'][convert_module]
            convert_map_ins = Operations::ZCRMLeadConvertMapping.get_instance(convert_map['name'], convert_map['id'])
            if convert_map.key?('fields')
              field_data = convert_map['fields']
              unless field_data.nil?
                field_data.each do |each_field_data|
                  convert_mapping_field_ins = Operations::ZCRMLeadConvertMappingField.get_instance(each_field_data['api_name'], each_field_data['id'])
                  convert_mapping_field_ins.field_label = each_field_data['field_label']
                  convert_mapping_field_ins.is_required = each_field_data['required'] == true
                  convert_map_ins.fields.push(convert_mapping_field_ins)
                end
              end
            end
            layout_instance.convert_mapping[convert_module] = convert_map_ins
          end
        end
        layout_instance
      end

      def get_all_sections_of_layout(all_section_details)
        section_instances = []
        unless all_section_details.nil?
          all_section_details.each do |section|
            section_ins = Operations::ZCRMSection.get_instance(section['name'])
            section_ins.display_label = section['display_label']
            section_ins.column_count = section['column_count']
            section_ins.sequence_number = section['sequence_number']
            section_ins.fields = get_section_fields(section['fields'])
            section_ins.tab_traversal = section['tab_traversal']
            section_ins.is_subform_section = section['isSubformSection']
            section_ins.api_name = section['api_name']
            section_ins.properties = get_section_properties(section['properties'])
            section_instances.push(section_ins)
          end
        end
        section_instances
      end

      def get_section_fields(fields)
        section_fields = []
        unless fields.nil?
          fields.each do |field|
            section_fields.push(get_zcrmfield(field))
          end
        end
        section_fields
      end

      def get_section_properties(properties)
        section_properties = Operations::ZCRMSectionProperties.get_instance
        unless properties.nil?
          section_properties.reorder_rows = properties['reorder_rows']
          section_properties.tooltip = properties['tooltip']
          section_properties.maximum_rows = properties['maximum_rows']
        end
        section_properties
      end

      def get_zcrmfield(field_details)
        field_instance = Operations::ZCRMField.get_instance(field_details['api_name'])
        field_instance.sequence_number = field_details.key?('sequence_number') ? field_details['sequence_number'].to_i : nil
        field_instance.id = field_details['id']
        field_instance.is_mandatory = field_details.key?('system_mandatory') ? field_details['system_mandatory'] == true : nil
        field_instance.default_value = field_details.key?('default_value') ? field_details['default_value'] : nil
        field_instance.is_custom_field = field_details.key?('custom_field') ? field_details['custom_field'] == true : nil
        field_instance.is_visible = field_details.key?('visible') ? field_details['visible'] == true : nil
        field_instance.field_label = field_details.key?('field_label') ? field_details['field_label'] : nil
        field_instance.length = field_details.key?('length') ? field_details['length'].to_i : nil
        field_instance.created_source = field_details.key?('created_source') ? field_details['created_source'] : nil
        field_instance.is_read_only = field_details.key?('read_only') ? field_details['read_only'] == true : nil
        field_instance.is_business_card_supported = field_details.key?('businesscard_supported') ? field_details['businesscard_supported'] == true : nil
        field_instance.data_type = field_details.key?('data_type') ? field_details['data_type'] : nil
        field_instance.convert_mapping = field_details.key?('convert_mapping') ? field_details['convert_mapping'] : nil
        field_instance.is_webhook = field_details.key?('webhook') ? field_details['webhook'] : nil
        field_instance.crypt = field_details.key?('crypt') ? field_details['crypt'] : nil
        field_instance.tooltip = field_details.key?('tooltip') ? field_details['tooltip'] : nil
        field_instance.is_field_read_only = field_details.key?('field_read_only') ? field_details['field_read_only'] : nil
        field_instance.association_details = field_details.key?('association_details') ? field_details['association_details'] : nil
        field_instance.subform = field_details.key?('subform') ? field_details['subform'] : nil
        field_instance.is_mass_update = field_details.key?('mass_update') ? field_details['mass_update'] : nil
        if field_details.key?('multiselectlookup') && !field_details['multiselectlookup'].empty?
          field_instance.multiselectlookup = get_multiselect_lookup_field_instance(field_details['multiselectlookup'])
        end
        if field_details.key?('view_type')
          viewtype_dict = field_details['view_type']
          field_layout_permissions = []
          field_layout_permissions.push('VIEW') if viewtype_dict['view']
          if viewtype_dict['quick_create']
            field_layout_permissions.push('QUICK_CREATE')
          end
          field_layout_permissions.push('CREATE') if viewtype_dict['create']
          field_layout_permissions.push('EDIT') if viewtype_dict['edit']
          field_instance.field_layout_permissions = field_layout_permissions
        end
        picklist_arr = field_details['pick_list_values']
        unless picklist_arr.empty?
          picklist_instance_arr = []
          picklist_arr.each do |picklist|
            picklist_instance_arr.push(get_picklist_value_instance(picklist))
          end
          field_instance.picklist_values = picklist_instance_arr
        end
        if field_details.key?('lookup') && !field_details['lookup'].empty?
          field_instance.lookup_field = get_lookup_field_instance(field_details['lookup'])
        end
        field_instance.is_unique_field = false
        field_instance.is_case_sensitive = false
        if field_details.key?('unique') && !field_details['unique'].empty?
          field_instance.is_unique_field = true
          field_instance.is_case_sensitive = field_details['unique']['casesensitive'] == true
        end
        if field_details.key?('decimal_place') && !field_details['decimal_place'].nil?
          field_instance.decimal_place = field_details['decimal_place']
        end
        if field_details.key?('json_type') && !field_details['json_type'].nil?
          field_instance.json_type = field_details['json_type']
        end
        field_instance.is_formula_field = false
        if field_details.key?('formula') && !field_details['formula'].empty?
          field_instance.is_formula_field = true
          field_instance.formula_return_type = field_details['formula']['return_type']
          field_instance.formula_expression = field_details['formula'].key?('expression') ? field_details['formula']['expression'] : nil
        end
        field_instance.is_currency_field = false
        if field_details.key?('currency') && !field_details['currency'].empty?
          field_instance.is_currency_field = true
          field_instance.precision = field_details['currency'].key?('precision') ? field_details['currency']['precision'].to_i : nil
          field_instance.rounding_option = field_details['currency'].key?('rounding_option') ? field_details['currency']['rounding_option'] : nil
        end
        field_instance.is_auto_number = false
        if field_details.key?('auto_number') && !field_details['auto_number'].empty?
          field_instance.is_auto_number = true
          field_instance.prefix = field_details['auto_number'].key?('prefix') ? field_details['auto_number']['prefix'] : nil
          field_instance.suffix = field_details['auto_number'].key?('suffix') ? field_details['auto_number']['suffix'] : nil
          field_instance.start_number = field_details['auto_number'].key?('start_number') ? field_details['auto_number']['start_number'] : nil
        end
        field_instance
      end
    end
    # THIS CLASS IS USED TO HANDLE META DATA RELATED FUNCTIONALITY
    class MetaDataAPIHandler < APIHandler
      def initialize; end

      def self.get_instance
        MetaDataAPIHandler.new
      end

      def get_all_modules
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/modules'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::MODULES
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        modules_json = bulk_api_response.response_json.dig(ZCRMSDK::Utility::APIConstants::MODULES)
        module_ins_list = []
        module_helper = MetaDataAPIHandlerHelper.get_instance
        modules_json.each do |module_json|
          module_ins_list.push(module_helper.get_zcrmmodule(module_json))
        end
        bulk_api_response.data = module_ins_list
        bulk_api_response
      end

      def get_module(module_api_name)
        if module_api_name.nil?
          raise Utility::ZCRMException.get_instance('get_module', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'module api name must be provided', 'NO MODULE API NAME PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/modules/' + module_api_name
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::MODULES
        api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_api_response
        module_helper = MetaDataAPIHandlerHelper.get_instance
        module_json = api_response.response_json.dig(ZCRMSDK::Utility::APIConstants::MODULES)[0]
        api_response.data = module_helper.get_zcrmmodule(module_json)
        api_response
      end
    end
    # THIS CLASS SERVES THE MetaDataAPIHandler CLASS CONSTRUCTING JSON BODY AND INSTANCES
    class MetaDataAPIHandlerHelper
      def initialize; end

      def self.get_instance
        MetaDataAPIHandlerHelper.new
      end

      def get_relatedlist_property_instance(relatedlist_property)
        reltedlist_property_instance = Operations::ZCRMRelatedListProperties.get_instance
        reltedlist_property_instance.sort_by = relatedlist_property.key?('sort_by') ? relatedlist_property['sort_by'] : nil
        reltedlist_property_instance.sort_order = relatedlist_property.key?('sort_order') ? relatedlist_property['sort_order'] : nil
        reltedlist_property_instance.fields = relatedlist_property.key?('fields') ? relatedlist_property['fields'] : nil
        reltedlist_property_instance
      end

      def get_zcrmmodule(module_details)
        crmmodule_instance = Operations::ZCRMModule.get_instance(module_details.dig(Utility::APIConstants::API_NAME))
        crmmodule_instance.is_viewable = module_details['viewable'] == true
        crmmodule_instance.is_creatable = module_details['creatable'] == true
        crmmodule_instance.is_convertable = module_details['convertable'] == true
        crmmodule_instance.is_editable = module_details['editable'] == true
        crmmodule_instance.is_deletable = module_details['deletable'] == true
        crmmodule_instance.web_link = module_details.key?('web_link') ? module_details['web_link'] : nil
        crmmodule_instance.singular_label = module_details['singular_label']
        crmmodule_instance.plural_label = module_details['plural_label']
        crmmodule_instance.id = module_details['id']
        crmmodule_instance.modified_time = module_details['modified_time']
        crmmodule_instance.is_inventory_template_supported = module_details['inventory_template_supported'] == true
        crmmodule_instance.is_api_supported = module_details['api_supported'] == true
        crmmodule_instance.is_scoring_supported = module_details['scoring_supported'] == true
        crmmodule_instance.module_name = module_details['module_name']
        crmmodule_instance.business_card_field_limit = module_details.key?('business_card_field_limit') ? module_details['business_card_field_limit'].to_i : nil
        crmmodule_instance.sequence_number = module_details.key?('sequence_number') ? module_details['sequence_number'] : nil
        crmmodule_instance.is_global_search_supported = module_details.key?('global_search_supported') ? module_details['global_search_supported'] == true : nil
        unless module_details['modified_by'].nil?
          crmmodule_instance.modified_by = Operations::ZCRMUser.get_instance(module_details['modified_by']['id'], module_details['modified_by']['name'])
        end

        crmmodule_instance.is_custom_module = module_details['generated_type'] == 'custom'

        if module_details.key?('business_card_fields')
          crmmodule_instance.business_card_fields = module_details['business_card_fields']
        end

        profiles = module_details['profiles']
        unless profiles.nil?
          profiles.each do |profile|
            crmmodule_instance.profiles.push(Operations::ZCRMProfile.get_instance(profile['id'], profile['name']))
          end
        end

        if module_details.key?('display_field') && !module_details['display_field'].nil?
          crmmodule_instance.display_field_name = module_details['display_field']
        end
        if module_details.key?('related_lists') && !module_details['related_lists'].nil?
          relatedlists = module_details['related_lists']
          relatedlist_instances = []
          unless relatedlists.nil?
            relatedlists.each do |relatedlist|
              module_relatedlist_ins = Operations::ZCRMModuleRelatedList.get_instance(relatedlist['api_name'])
              relatedlist_instances.push(module_relatedlist_ins.set_relatedlist_properties(relatedlist))
            end
          end
          crmmodule_instance.related_lists = relatedlist_instances
        end
        if module_details.key?('related_list_properties') && !module_details['related_list_properties'].nil?
          crmmodule_instance.related_list_properties = get_relatedlist_property_instance(module_details['related_list_properties'])
        end
        if module_details.key?('$properties') && !module_details['$properties'].nil?
          crmmodule_instance.properties = module_details['$properties']
        end
        if module_details.key?('per_page') && !module_details['per_page'].nil?
          crmmodule_instance.per_page = module_details['per_page'].to_i
        end
        if module_details.key?('search_layout_fields') && !module_details['search_layout_fields'].nil?
          crmmodule_instance.search_layout_fields = module_details['search_layout_fields']
        end
        if module_details.key?('custom_view') && !module_details['custom_view'].nil?
          meta_data_api_helper = MetaDataAPIHandlerHelper.get_instance
          crmmodule_instance.default_custom_view = meta_data_api_helper.get_zcrm_customview(module_details.dig('custom_view'), crmmodule_instance.api_name, nil)
          crmmodule_instance.default_custom_view_id = module_details['custom_view']['id']
        end
        if module_details.key?('territory') && !module_details['territory'].nil?
          crmmodule_instance.default_territory_id = module_details['territory']['id']
          crmmodule_instance.default_territory_name = module_details['territory']['name']
        end
        crmmodule_instance.is_kanban_view = module_details.key?('kanban_view') ? module_details['kanban_view'] == true : nil
        crmmodule_instance.is_filter_status = module_details.key?('filter_status') ? module_details['filter_status'] == true : nil
        crmmodule_instance.is_presence_sub_menu = module_details.key?('presence_sub_menu') ? module_details['presence_sub_menu_status'] == true : nil
        crmmodule_instance.arguments = module_details['arguments']
        crmmodule_instance.generated_type = module_details['generated_type']
        crmmodule_instance.is_quick_create = module_details['quick_create'] == true
        crmmodule_instance.is_kanban_view_supported = module_details.key?('kanban_view_supported') ? module_details['kanban_view_supported'] == true : nil
        crmmodule_instance.is_filter_supported = module_details.key?('filter_supported') ? module_details['filter_supported'] == true : nil
        unless module_details['parent_module'].nil?
          parent_module_instance = Operations::ZCRMModule.get_instance(module_details['parent_module']['api_name'])
          parent_module_instance.id = module_details['parent_module']['id']
          unless parent_module_instance.id.nil?
            crmmodule_instance.parent_module = parent_module_instance
          end
        end
        crmmodule_instance.is_feeds_required = module_details['feeds_required'] == true
        crmmodule_instance.is_email_template_support = module_details['emailTemplate_support'] == true
        crmmodule_instance.is_webform_supported = module_details['webform_supported'] == true
        crmmodule_instance.visibility = module_details['visibility']
        crmmodule_instance
      end

      def construct_criteria(criteria)
        criteria_instance = Operations::ZCRMCustomViewCriteria.get_instance
        criteria_instance.field = criteria.key?('field') ? criteria['field'] : nil
        criteria_instance.comparator = criteria.key?('comparator') ? criteria['comparator'] : nil
        unless criteria['value'].nil?
          criteria_instance.index = $index
          criteria_instance.value = criteria['value']
          criteria_instance.pattern = $index.to_s
          $index = $index + 1
          criteria_instance.criteria = ' (' + criteria_instance.field .to_s + ':' + criteria_instance.comparator.to_s + ':' + criteria_instance.value.to_s + ') '
        end
        group_criteria = []
        unless criteria['group'].nil?
          i = 0
          while i < criteria['group'].count
            group_criteria.push(construct_criteria(criteria['group'][i]))
            i += 1
          end
        end
        criteria_instance.group = group_criteria unless group_criteria.nil?
        unless criteria['group_operator'].nil?
          criteria_instance.group_operator = criteria['group_operator']
          criteria_instance.criteria = '(' + group_criteria[0].criteria + criteria_instance.group_operator + group_criteria[1].criteria + ')'
          criteria_instance.pattern = '{' + group_criteria[0].pattern + criteria_instance.group_operator + group_criteria[1].pattern + '}'
        end
        criteria_instance
      end

      def get_zcrm_customview(customview_details, module_api_name, categories = nil)
        customview_instance = Operations::ZCRMCustomView.get_instance(customview_details['id'], module_api_name)
        customview_instance.display_value = customview_details['display_value']
        customview_instance.is_default = customview_details['default'] == true
        customview_instance.name = customview_details['name']
        customview_instance.is_system_defined = customview_details['system_defined'] == true
        customview_instance.shared_details = customview_details['shared_details']
        customview_instance.system_name = customview_details['system_name']
        customview_instance.sort_by = customview_details.key?('sort_by') ? customview_details['sort_by'] : nil
        customview_instance.category = customview_details.key?('category') ? customview_details['category'] : nil
        customview_instance.fields = customview_details.key?('fields') ? customview_details['fields'] : nil
        customview_instance.favorite = customview_details.key?('favorite') ? customview_details['favorite'] : nil
        customview_instance.sort_order = customview_details.key?('sort_order') ? customview_details['sort_order'] : nil
        if customview_details.key?('criteria') && !customview_details['criteria'].nil?
          criteria = customview_details['criteria'] # entire criteria
          $index = 0
          customview_instance.criteria = construct_criteria(criteria)
          customview_instance.criteria_condition = customview_instance.criteria.criteria
          customview_instance.criteria_pattern = customview_instance.criteria.pattern
        end
        unless categories.nil?
          category_instances = []
          categories.each do |category|
            cv_category_instance = Operations::ZCRMCustomViewCategory.get_instance
            cv_category_instance.display_value = categories[category]
            cv_category_instance.actual_value = category
            category_instances.push(cv_category_instance)
          end
          customview_instance.categories = category_instances
        end
        if customview_details.key?('offline')
          customview_instance.is_off_line = customview_details['offline']
        end
        customview_instance
      end
    end
    # THIS CLASS IS USED TO HANDLE ORGANIZATION RELATED FUNCTIONALITY
    class OrganizationAPIHandler
      def initialize; end

      def self.get_instance
        OrganizationAPIHandler.new
      end
      
      def get_organization_details
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'org'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::ORG
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        org_json = api_response.response_json[Utility::APIConstants::ORG][0]
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        api_response.data = org_api_helper.get_zcrm_organization(org_json)
        api_response
      end

      def get_all_roles
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/roles'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::ROLES
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        roles = bulk_api_response.response_json[Utility::APIConstants::ROLES]
        role_instances = []
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        roles.each do |role|
          role_instances.push(org_api_helper.get_zcrm_role(role))
        end
        bulk_api_response.data = role_instances
        bulk_api_response
      end

      def get_role(role_id)
        if role_id.nil?
          raise Utility::ZCRMException.get_instance('get_role', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'role id must be given', 'ROLE ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/roles/' + role_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::ROLES
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        role = api_response.response_json[Utility::APIConstants::ROLES][0]
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        api_response.data = org_api_helper.get_zcrm_role(role)
        api_response
      end

      def get_all_profiles
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/profiles'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::PROFILES
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        profiles = bulk_api_response.response_json[handler_ins.request_api_key]
        profile_instances = []
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        profiles.each do |profile|
          profile_instances.push(org_api_helper.get_zcrm_profile(profile))
        end
        bulk_api_response.data = profile_instances
        bulk_api_response
      end

      def get_profile(profile_id)
        if profile_id.nil?
          raise Utility::ZCRMException.get_instance('get_profile', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'profile id must be given', 'PROFILE ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/profiles/' + profile_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::PROFILES
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        profile = api_response.response_json[handler_ins.request_api_key][0]
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        api_response.data = org_api_helper.get_zcrm_profile(profile)
        api_response
      end

      def create_user(user_instance)
        if user_instance.nil?
          raise Utility::ZCRMException.get_instance('create_user', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'user instance must be given', 'USER INSTANCE IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'users'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::USERS
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        handler_ins.request_body = org_api_helper.construct_json_from_user_instance(user_instance)
        Request::APIRequest.get_instance(handler_ins).get_api_response
      end

      def update_user(user_instance)
        if user_instance.nil? || user_instance.id.nil?
          raise Utility::ZCRMException.get_instance('update_user', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'user instance and id must be given', 'USER INSTANCE OR ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'users/' + user_instance.id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = Utility::APIConstants::USERS
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        handler_ins.request_body = org_api_helper.construct_json_from_user_instance(user_instance)
        Request::APIRequest.get_instance(handler_ins).get_api_response
      end

      def delete_user(user_id)
        if user_id.nil?
          raise Utility::ZCRMException.get_instance('delete_user', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'user id must be given', 'USER ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'users/' + user_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::USERS
        Request::APIRequest.get_instance(handler_ins).get_api_response
      end

      def get_user(user_id)
        if user_id.nil?
          raise Utility::ZCRMException.get_instance('get_user', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'user id must be given', 'USER ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'users/' + user_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::USERS
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        api_response.data = org_api_helper.get_zcrm_user(api_response.response_json[Utility::APIConstants::USERS][0])
        api_response
      end

      def get_all_users(page,per_page)
        get_users('AllUsers',page,per_page)
      end

      def get_all_deactive_users(page,per_page)
        get_users('DeactiveUsers',page,per_page)
      end

      def get_all_active_users(page,per_page)
        get_users('ActiveUsers',page,per_page)
      end

      def get_all_confirmed_users(page,per_page)
        get_users('ConfirmedUsers',page,per_page)
      end

      def get_all_not_confirmed_users(page,per_page)
        get_users('NotConfirmedUsers',page,per_page)
      end

      def get_all_deleted_users(page,per_page)
        get_users('DeletedUsers',page,per_page)
      end

      def get_all_active_confirmed_users(page,per_page)
        get_users('ActiveConfirmedUsers',page,per_page)
      end

      def get_all_admin_users(page,per_page)
        get_users('AdminUsers',page,per_page)
      end

      def get_all_active_confirmed_admin_users(page,per_page)
        get_users('ActiveConfirmedAdmins',page,per_page)
      end

      def get_current_user(page = nil, per_page = nil)
        get_users('CurrentUser',page,per_page)
      end

      def get_users(user_type = nil,page=1,per_page=200)
        handler_ins = APIHandler.get_instance
        handler_ins.add_param('type', user_type) unless user_type.nil?
        handler_ins.add_param('page', page) 
        handler_ins.add_param('per_page', per_page) 
        handler_ins.request_url_path = 'users'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::USERS
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        users_json = bulk_api_response.response_json[Utility::APIConstants::USERS]
        user_instances = []
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        users_json.each do |user_details|
          user_instances.push(org_api_helper.get_zcrm_user(user_details))
        end
        bulk_api_response.data = user_instances
        bulk_api_response
      end

      def search_users_by_criteria(criteria, type,page,per_page)
        if criteria.nil? 
          raise Utility::ZCRMException.get_instance('search_users_by_criteria', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'criteria must be provided', 'NO CRITERIA PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'users/search'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::USERS
        handler_ins.add_param('criteria', criteria)
        handler_ins.add_param('type', type) unless type.nil?
        handler_ins.add_param('page', page) 
        handler_ins.add_param('per_page', per_page)
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        users_json = bulk_api_response.response_json[Utility::APIConstants::USERS]
        user_instances = []
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        users_json.each do |user_details|
          user_instances.push(org_api_helper.get_zcrm_user(user_details))
        end
        bulk_api_response.data = user_instances
        bulk_api_response
      end

      def create_organization_taxes(org_tax_instances)
        if org_tax_instances.length > 100
          raise Utility::ZCRMException.get_instance('create_organization_taxes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax count must be less than or equals to 100', 'MORE ORG TAXES PROVIDED')
        end

        if org_tax_instances.length < 1
          raise Utility::ZCRMException.get_instance('create_organization_taxes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax count must be at least 1', 'NO ORG TAX PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'org/taxes'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::TAXES
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        data_array = []
        org_tax_instances.each do |org_tax_instance|
          if org_tax_instance.id.nil?
            data_array.push(org_api_helper.get_zcrmorgtax_as_json(org_tax_instance))
          else
            raise Utility::ZCRMException.get_instance('Org_tax_Create', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax id must be nil', 'ORG TAX ID PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::TAXES] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end

      def update_organization_taxes(org_tax_instances)
        if org_tax_instances.length > 100
          raise Utility::ZCRMException.get_instance('update_organization_taxes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax count must be less than or equals to 100', 'MORE ORG TAXES PROVIDED')
        end

        if org_tax_instances.length < 1
          raise Utility::ZCRMException.get_instance('update_organization_taxes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax count must be at least 1', 'NO ORG TAX PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'org/taxes'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = Utility::APIConstants::TAXES
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        data_array = []
        org_tax_instances.each do |org_tax_instance|
          if org_tax_instance.id.nil?
            raise Utility::ZCRMException.get_instance('Org_tax_update', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax id must not be nil', 'ORG TAX ID NOT PROVIDED')
          else
            data_array.push(org_api_helper.get_zcrmorgtax_as_json(org_tax_instance))
          end
        end

        request_json = {}
        request_json[Utility::APIConstants::TAXES] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end

      def delete_organization_taxes(org_tax_ids)
        if org_tax_ids.length > 100
          raise Utility::ZCRMException.get_instance('delete_organization_taxes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax count must be less than or equals to 100', 'MORE ORG TAX PROVIDED')
        end

        if org_tax_ids.length < 1
          raise Utility::ZCRMException.get_instance('delete_organization_taxes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax count must be at least 1', 'NO ORG TAX PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'org/taxes'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::TAXES
        ids_as_string = ''
        org_tax_ids.each do |org_tax_id|
          ids_as_string += org_tax_id.to_s + ','
        end

        handler_ins.add_param('ids', ids_as_string)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end

      def delete_organization_tax(orgtax_id)
        if orgtax_id.nil?
          raise Utility::ZCRMException.get_instance('delete_organization_tax', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax id must be given', 'NO ORG TAX ID PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'org/taxes/' + orgtax_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::TAXES
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def get_organization_taxes
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'org/taxes'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::TAXES
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        org_taxes_json = bulk_api_response.response_json[Utility::APIConstants::TAXES]
        org_taxes_instances = []
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        org_taxes_json.each do |org_tax|
          org_taxes_instances.push(org_api_helper.get_zcrm_org_tax_instance(org_tax))
        end
        bulk_api_response.data = org_taxes_instances
        bulk_api_response
      end

      def get_organization_tax(org_tax_id)
        if org_tax_id.nil?
          raise Utility::ZCRMException.get_instance('get_organization_tax', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'org tax id must be given', 'NO ORG TAX ID PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'org/taxes/' + org_tax_id.to_s
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        org_api_helper = OrganizationAPIHandlerHelper.get_instance
        api_response.data = org_api_helper.get_zcrm_org_tax_instance(api_response.response_json[Utility::APIConstants::TAXES][0])
        api_response
      end
      def get_notes(sort_by, sort_order, page, per_page)
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'Notes'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::DATA
        handler_ins.add_param('page', page)
        handler_ins.add_param('per_page', per_page)
        handler_ins.add_param('sort_by', sort_by)unless sort_by.nil?
        handler_ins.add_param('sort_order', sort_order)unless sort_order.nil?
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        notes_json = bulk_api_response.response_json.dig(ZCRMSDK::Utility::APIConstants::DATA)
        notes_list = []
        notes_helper = RelatedListAPIHandlerHelper.get_instance
        notes_json.each do |note_json|
          record_ins=Operations::ZCRMRecord.get_instance(note_json['$se_module'], note_json['Parent_Id']['id'])
          note_ins = Operations::ZCRMNote.get_instance(record_ins,note_json['id'])
          notes_list.push(notes_helper.get_zcrm_note(note_json,note_ins))
        end
        bulk_api_response.data = notes_list
        bulk_api_response
      end
      def create_notes(note_instances)
        if note_instances.length > 100
          raise Utility::ZCRMException.get_instance('create_notes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note count must be less than or equals to 100', 'MORE NOTES PROVIDED')
        end

        if note_instances.length < 1
          raise Utility::ZCRMException.get_instance('create_notes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note count must be at least 1', 'NO NOTES PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'Notes'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        notes_api_helper = RelatedListAPIHandlerHelper.get_instance
        data_array = []
        note_instances.each do |note_instance|
          if note_instance.id.nil?
            data_array.push(notes_api_helper.get_zcrmnote_as_json(note_instance))
          else
            raise Utility::ZCRMException.get_instance('notes_Create', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note id must be nil', 'NOTE ID PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::DATA] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end
      def delete_notes(note_ids)
        if note_ids.length > 100
          raise Utility::ZCRMException.get_instance('delete_notes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'notes count must be less than or equals to 100', 'MORE NOTES PROVIDED')
        end

        if note_ids.length < 1
          raise Utility::ZCRMException.get_instance('delete_notes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'notes  count must be at least 1', 'NO NOTES PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'Notes'
        handler_ins.request_method = Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::DATA
        ids_as_string = ''
        note_ids.each do |note_id|
          ids_as_string += note_id.to_s + ','
        end

        handler_ins.add_param('ids', ids_as_string)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end
    end
    # THIS CLASS SERVES THE OrganizationAPIHandler CLASS CONSTRUCTING JSON BODY AND INSTANCES
    class OrganizationAPIHandlerHelper
      def initialize; end

      def self.get_instance
        OrganizationAPIHandlerHelper.new
      end

      def get_zcrm_user_customizeinfo(customize_info)
        customize_info_instance = Operations::ZCRMUserCustomizeInfo.get_instance
        customize_info_instance.notes_desc = customize_info['notes_desc']
        customize_info_instance.is_to_show_right_panel = customize_info.key?('show_right_panel') ? customize_info['show_right_panel'] == true : nil
        customize_info_instance.is_bc_view = customize_info['bc_view']
        customize_info_instance.is_to_show_home = customize_info.key?('show_home') ? customize_info['show_home'] == true : nil
        customize_info_instance.is_to_show_detail_view = customize_info.key?('show_detail_view') ? customize_info['show_detail_view'] == true : nil
        customize_info_instance.unpin_recent_item = customize_info['unpin_recent_item']
        customize_info_instance
      end

      def get_zcrm_org_tax_instance(org_tax)
        org_tax_instance = Operations::ZCRMOrgTax.get_instance(org_tax['id'], org_tax['name'])
        org_tax_instance.display_label = org_tax['display_label']
        org_tax_instance.value = org_tax['value']
        org_tax_instance
      end

      def get_zcrm_user_theme(user_theme_info)
        user_theme_instance = Operations::ZCRMUserTheme.get_instance
        user_theme_instance.normal_tab_font_color = user_theme_info['normal_tab']['font_color']
        user_theme_instance.normal_tab_background = user_theme_info['normal_tab']['background']
        user_theme_instance.selected_tab_font_color = user_theme_info['selected_tab']['font_color']
        user_theme_instance.selected_tab_background = user_theme_info['selected_tab']['background']
        user_theme_instance.new_background = user_theme_info['new_background']
        user_theme_instance.background = user_theme_info['background']
        user_theme_instance.screen = user_theme_info['screen']
        user_theme_instance.type = user_theme_info['type']
        user_theme_instance
      end

      def get_zcrmorgtax_as_json(zcrmorgtax_instance)
        orgtax_as_json = {}
        unless zcrmorgtax_instance.id.nil?
          orgtax_as_json['id'] = zcrmorgtax_instance.id.to_s
        end
        unless zcrmorgtax_instance.name.nil?
          orgtax_as_json['name'] = zcrmorgtax_instance.name
        end
        unless zcrmorgtax_instance.display_label.nil?
          orgtax_as_json['display_label'] = zcrmorgtax_instance.display_label
        end
        unless zcrmorgtax_instance.value.nil?
          orgtax_as_json['value'] = zcrmorgtax_instance.value
        end
        unless zcrmorgtax_instance.sequence_number.nil?
          orgtax_as_json['sequence_number'] = zcrmorgtax_instance.sequence_number
        end
        orgtax_as_json
      end

      def construct_json_from_user_instance(user_instance)
        user_info_json = {}
        unless user_instance.role.nil?
          user_info_json['role'] = user_instance.role.id.to_s
        end
        unless user_instance.profile.nil?
          user_info_json['profile'] = user_instance.profile.id.to_s
        end
        unless user_instance.country.nil?
          user_info_json['country'] = user_instance.country
        end
        user_info_json['name'] = user_instance.name unless user_instance.name.nil?
        user_info_json['city'] = user_instance.city unless user_instance.city.nil?
        unless user_instance.signature.nil?
          user_info_json['signature'] = user_instance.signature
        end
        unless user_instance.name_format.nil?
          user_info_json['name_format'] = user_instance.name_format
        end
        unless user_instance.language.nil?
          user_info_json['language'] = user_instance.language
        end
        unless user_instance.locale.nil?
          user_info_json['locale'] = user_instance.locale
        end
        unless user_instance.is_personal_account.nil?
          user_info_json['personal_account'] = user_instance.is_personal_account == true
        end
        unless user_instance.default_tab_group.nil?
          user_info_json['default_tab_group'] = user_instance.default_tab_group
        end
        unless user_instance.street.nil?
          user_info_json['street'] = user_instance.street
        end
        unless user_instance.alias_aka.nil?
          user_info_json['alias'] = user_instance.alias_aka
        end
        unless user_instance.state.nil?
          user_info_json['state'] = user_instance.state
        end
        unless user_instance.country_locale.nil?
          user_info_json['country_locale'] = user_instance.country_locale
        end
        user_info_json['fax'] = user_instance.fax unless user_instance.fax.nil?
        unless user_instance.first_name.nil?
          user_info_json['first_name'] = user_instance.first_name
        end
        unless user_instance.email.nil?
          user_info_json['email'] = user_instance.email
        end
        user_info_json['zip'] = user_instance.zip unless user_instance.zip.nil?
        unless user_instance.decimal_separator.nil?
          user_info_json['decimal_separator'] = user_instance.decimal_separator
        end
        unless user_instance.reporting_to.nil?
          user_info_json['Reporting_To'] = get_reporting_to_as_json(user_instance.reporting_to)
        end
        unless user_instance.website.nil?
          user_info_json['website'] = user_instance.website
        end
        unless user_instance.time_format.nil?
          user_info_json['time_format'] = user_instance.time_format
        end
        unless user_instance.mobile.nil?
          user_info_json['mobile'] = user_instance.mobile
        end
        unless user_instance.last_name.nil?
          user_info_json['last_name'] = user_instance.last_name
        end
        unless user_instance.time_zone.nil?
          user_info_json['time_zone'] = user_instance.time_zone
        end
        unless user_instance.phone.nil?
          user_info_json['phone'] = user_instance.phone
        end
        user_info_json['dob'] = user_instance.dob unless user_instance.dob.nil?
        unless user_instance.date_format.nil?
          user_info_json['date_format'] = user_instance.date_format
        end
        unless user_instance.status.nil?
          user_info_json['status'] = user_instance.status
        end
        custom_fields_data = user_instance.field_apiname_vs_value
        unless custom_fields_data.nil?
          custom_fields_data.each do |key|
            user_info_json[key] = custom_fields_data[key]
          end
        end
        Utility::CommonUtil.create_api_supported_input_json(user_info_json, Utility::APIConstants::USERS)
      end

      def get_reporting_to_as_json(reporting_to_details)
        reporting_to = {}
        reporting_to['id'] = reporting_to_details.id
        reporting_to
      end

      def get_zcrm_role(role_details)
        role_instance = Operations::ZCRMRole.get_instance(role_details['id'], role_details['name'])
        role_instance.display_label = role_details['display_label']
        role_instance.description = role_details['description']
        unless role_details['forecast_manager'].nil?
          role_instance.forecast_manager = Operations::ZCRMUser.get_instance(role_details['forecast_manager']['id'], role_details['forecast_manager']['name'])
        end
        role_instance.is_admin = role_details['admin_user'] == true
        role_instance.is_share_with_peers = role_details['share_with_peers'] == true
        if role_details.key?('reporting_to') && !role_details['reporting_to'].nil?
          role_instance.reporting_to = Operations::ZCRMUser.get_instance(role_details['reporting_to']['id'], role_details['reporting_to']['name'])
        end
        role_instance
      end

      def get_zcrm_profile(profile_details)
        profile_instance = Operations::ZCRMProfile.get_instance(profile_details['id'], profile_details['name'])
        profile_instance.created_time = profile_details['created_time']
        profile_instance.modified_time = profile_details['modified_time']
        profile_instance.description = profile_details['description']
        profile_instance.category = profile_details['category']
        unless profile_details['modified_by'].nil?
          profile_instance.modified_by = Operations::ZCRMUser.get_instance(profile_details['modified_by']['id'], profile_details['modified_by']['name'])
        end
        unless profile_details['created_by'].nil?
          profile_instance.created_by = Operations::ZCRMUser.get_instance(profile_details['created_by']['id'], profile_details['created_by']['name'])
        end
        if profile_details.key?('permissions_details')
          permissions = profile_details['permissions_details']
          unless permissions.nil?
            permissions.each do |permission|
              permission_ins = Operations::ZCRMPermission.get_instance(permission['name'], permission['id'])
              permission_ins.display_label = permission['display_label']
              permission_ins.module_api_name = permission['module']
              permission_ins.is_enabled = permission['enabled'] == true
              profile_instance.permissions.push(permission_ins)
            end
          end
        end
        if profile_details.key?('sections')
          sections = profile_details['sections']
          unless sections.nil?
            sections.each do |section|
              profile_section_instance = Operations::ZCRMProfileSection.get_instance(section['name'])
              if section.key?('categories')
                categories = section['categories']
                unless categories.nil?
                  categories.each do |category|
                    category_ins = Operations::ZCRMProfileCategory.get_instance(category['name'])
                    category_ins.display_label = category['display_label']
                    category_ins.permission_ids = category['permissions_details']
                    category_ins.module_api_name = category.key?('module') ? category['module'] : nil
                    profile_section_instance.categories.push(category_ins)
                  end
                end
              end
              profile_instance.sections.push(profile_section_instance)
            end
          end
        end
        profile_instance
      end

      def get_zcrm_organization(org_details)
        org_instance = Org::ZCRMOrganization.get_instance(org_details['company_name'], org_details['id'])
        org_instance.alias_aka = org_details['alias']
        org_instance.city = org_details['city']
        org_instance.country = org_details['country']
        org_instance.country_code = org_details['country_code']
        org_instance.currency_locale = org_details['currency_locale']
        org_instance.currency_symbol = org_details['currency_symbol']
        org_instance.currency = org_details['currency']
        org_instance.description = org_details['description']
        org_instance.employee_count = org_details['employee_count']
        org_instance.zia_portal_id = org_details['zia_portal_id']
        org_instance.photo_id = org_details['photo_id']
        org_instance.fax = org_details['fax']
        org_instance.privacy_settings = org_details['privacy_settings']
        org_instance.is_gapps_enabled = org_details['gapps_enabled'] == true
        org_instance.iso_code = org_details['iso_code']
        org_instance.mc_status = org_details['mc_status']
        org_instance.mobile = org_details['mobile']
        org_instance.phone = org_details['phone']
        org_instance.primary_email = org_details['primary_email']
        org_instance.primary_zuid = org_details['primary_zuid']
        org_instance.state = org_details['state']
        org_instance.street = org_details['street']
        org_instance.time_zone = org_details['time_zone']
        org_instance.website = org_details['website']
        org_instance.zgid = org_details['zgid']
        org_instance.zip_code = org_details['zip']
        unless org_details['license_details'].nil?
          license_details = org_details['license_details']
          org_instance.is_paid_account = license_details['paid'] == true
          org_instance.paid_type = license_details['paid_type']
          org_instance.paid_expiry = license_details['paid_expiry']
          org_instance.trial_type = license_details['trial_type']
          org_instance.trial_expiry = license_details['trial_expiry']
          org_instance.users_license_purchased = license_details['users_license_purchased']
        end
        org_instance
      end

      def get_zcrm_user(user_details)
        user_instance = Operations::ZCRMUser.get_instance(user_details['id'], user_details.key?('name') ? user_details['name'] : nil)
        user_instance.is_microsoft = user_details['microsoft'] == true
        user_instance.country = user_details.key?('country') ? user_details['country'] : nil
        user_instance.role = Operations::ZCRMRole.get_instance(user_details['role']['id'], user_details['role']['name'])
        if user_details.key?('customize_info')
          user_instance.customize_info = get_zcrm_user_customizeinfo(user_details['customize_info'])
        end
        user_instance.city = user_details['city']
        user_instance.signature = user_details.key?('signature') ? user_details['signature'] : nil
        user_instance.name_format = user_details.key?('name_format') ? user_details['name_format'] : nil
        user_instance.language = user_details['language']
        user_instance.locale = user_details['locale']
        user_instance.is_personal_account = user_details.key?('personal_account') ? user_details['personal_account'] == true : nil
        user_instance.default_tab_group = user_details.key?('default_tab_group') ? user_details['default_tab_group'] : nil
        user_instance.alias_aka = user_details['alias']
        user_instance.street = user_details['street']
        user_instance.city = user_details['city']
        if user_details.key?('theme')
          user_instance.theme = get_zcrm_user_theme(user_details['theme'])
        end
        user_instance.state = user_details['state']
        user_instance.country_locale = user_details['country_locale']
        user_instance.fax = user_details['fax']
        user_instance.first_name = user_details['first_name']
        user_instance.email = user_details['email']
        user_instance.zip = user_details['zip']
        user_instance.decimal_separator = user_details.key?('decimal_separator') ? user_details['decimal_separator'] : nil
        user_instance.website = user_details['website']
        user_instance.time_format = user_details['time_format']
        user_instance.profile = Operations::ZCRMProfile.get_instance(user_details['profile']['id'], user_details['profile']['name'])
        user_instance.mobile = user_details['mobile']
        user_instance.last_name = user_details['last_name']
        user_instance.time_zone = user_details['time_zone']
        user_instance.zuid = user_details['zuid']
        user_instance.is_confirm = user_details['confirm'] == true
        user_instance.full_name = user_details['full_name']
        user_instance.phone = user_details['phone']
        user_instance.dob = user_details['dob']
        user_instance.offset = user_details['offset']
        user_instance.date_format = user_details['date_format']
        user_instance.status = user_details['status']
        if user_details.key?('territories')
          user_instance.territories = user_details['territories']
        end
        if user_details.key?('Reporting_To')
          unless user_details['Reporting_To'].nil?
            reporting_to = user_details['Reporting_To']
            user_instance.reporting_to = Operations::ZCRMUser.get_instance(reporting_to['id'], reporting_to['name'])
          end
        end
        if user_details.key?('Currency')
          user_instance.currency = user_details['Currency']
        end
        created_by = user_details['created_by']
        modified_by = user_details['Modified_By']
        user_instance.created_by = Operations::ZCRMUser.get_instance(created_by['id'], created_by['name'])
        user_instance.modified_by = Operations::ZCRMUser.get_instance(modified_by['id'], modified_by['name'])
        user_instance.is_online = user_details['Isonline']
        user_instance.created_time = user_details['created_time']
        user_instance.modified_time = user_details['Modified_Time']
        user_instance
      end
    end
    # THIS CLASS IS USED TO HANDLE TAG RELATED FUNCTIONALITY
    class TagAPIHandler < APIHandler
      def initialize(module_instance = nil)
        @module_instance = module_instance
      end

      def self.get_instance(module_ins = nil)
        TagAPIHandler.new(module_ins)
      end

      def get_tags
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/tags'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::TAG
        handler_ins.add_param('module', @module_instance.api_name)
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        tags_json = bulk_api_response.response_json.dig(ZCRMSDK::Utility::APIConstants::TAG)
        tag_list = []
        tag_helper = TagAPIHandlerHelper.get_instance
        tags_json.each do |tag_json|
          tag_ins = Operations::ZCRMTag.get_instance(tag_json['id'], tag_json['name'])
          tag_list.push(tag_helper.get_zcrmtag(tag_ins, tag_json))
        end
        bulk_api_response.data = tag_list
        bulk_api_response
      end

      def get_tag_count(tag_id)
        if tag_id.nil?
          raise Utility::ZCRMException.get_instance('get_tag_count', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag id must be given', 'NO TAG ID PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        tag_id = tag_id.to_s
        handler_ins.request_url_path = 'settings/tags/' + tag_id + '/actions/records_count'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::TAG
        handler_ins.add_param('module', @module_instance.api_name)
        api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_api_response
        tag_json = api_response.response_json
        tag_ins = Operations::ZCRMTag.get_instance(tag_id)
        tag_helper = TagAPIHandlerHelper.get_instance
        api_response.data = tag_helper.get_zcrmtag(tag_ins, tag_json)
        api_response
      end

      def create_tags(tag_list)
        if tag_list.length > 50
          raise Utility::ZCRMException.get_instance('create_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must be less than or equals to 50', 'MORE TAGS PROVIDED')
        end

        if tag_list.length < 1
          raise Utility::ZCRMException.get_instance('create_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must at least be 1', 'NO TAGS PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/tags'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::TAG
        handler_ins.add_param('module', @module_instance.api_name)
        data_array = []
        tag_helper = TagAPIHandlerHelper.get_instance
        tag_list.each do |tag|
          if tag.id.nil?
            data_array.push(tag_helper.construct_json_for_tag(tag))
          else
            raise Utility::ZCRMException.get_instance('Tags_Create', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'tag id must be nil', 'TAG ID PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::TAG] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        created_tags = []
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length
        length -= 1
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS

          tag_create_details = entity_response_ins.details
          new_tag = tag_list[i]
          tag_helper = TagAPIHandlerHelper.get_instance
          tag_helper.get_zcrmtag(new_tag, tag_create_details)
          created_tags.push(new_tag)
          entity_response_ins.data = new_tag
        end
        bulk_api_response.data = created_tags
        bulk_api_response
      end

      def update_tags(tag_list)
        if tag_list.length > 50
          raise Utility::ZCRMException.get_instance('update_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must be less than or equals to 50', 'MORE TAGS PROVIDED')
        end

        if tag_list.length < 1
          raise Utility::ZCRMException.get_instance('update_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must at least be 1', 'NO TAGS PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/tags'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::TAG
        handler_ins.add_param('module', @module_instance.api_name)
        data_array = []
        tag_helper = TagAPIHandlerHelper.get_instance
        tag_list.each do |tag|
          if !tag.id.nil?
            data_array.push(tag_helper.construct_json_for_tag(tag))
          else
            raise Utility::ZCRMException.get_instance('Tags_update', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'tag id must not be nil', 'TAG ID NOT PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::TAG] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        updated_tags = []
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length
        length -= 1
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS

          tag_update_details = entity_response_ins.details
          new_tag = tag_list[i]
          tag_helper = TagAPIHandlerHelper.get_instance
          tag_helper.get_zcrmtag(new_tag, tag_update_details)
          updated_tags.push(new_tag)
          entity_response_ins.data = new_tag
        end
        bulk_api_response.data = updated_tags
        bulk_api_response
      end

      def add_tags_to_multiple_records(tag_list, record_list)
        if tag_list.length > 50
          raise Utility::ZCRMException.get_instance('add_tags_to_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must be less than or equals to 50', 'MORE TAGS PROVIDED')
        end

        if tag_list.length < 1
          raise Utility::ZCRMException.get_instance('add_tags_to_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must at least be 1', 'NO TAGS PROVIDED')
        end

        if record_list.length > 100
          raise Utility::ZCRMException.get_instance('add_tags_to_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be less than or equals to 100', 'MORE RECORDS PROVIDED')
        end

        if record_list.length < 1
          raise Utility::ZCRMException.get_instance('add_tags_to_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records must at least be 1', 'NO RECORDS PROVIDED')
        end

        record_ids_as_string = ''
        record_list.each do |record_id|
          record_ids_as_string += record_id.to_s + ','
        end
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = @module_instance.api_name + '/actions/add_tags'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::DATA
        handler_ins.add_param('ids', record_ids_as_string)
        tag_names_as_string = ''
        tag_list.each do |tag_name|
          tag_names_as_string += tag_name.to_s + ','
        end
        handler_ins.add_param('tag_names', tag_names_as_string)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length
        length -= 1
        records = []
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS
          tag_added_details = entity_response_ins.details
          record = Operations::ZCRMRecord.get_instance(@module_instance.api_name, tag_added_details['id'])
          tag_added_details['tags'].each do |tag_name|
            record.tag_list.push(Operations::ZCRMTag.get_instance(nil, tag_name))
          end
          records.push(record)
          entity_response_ins.data = record
        end
        bulk_api_response.data = records
        bulk_api_response
      end

      def remove_tags_from_multiple_records(tag_list, record_list)
        if tag_list.length > 50
          raise Utility::ZCRMException.get_instance('remove_tags_from_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must be less than or equals to 50', 'MORE TAGS PROVIDED')
        end

        if tag_list.length < 1
          raise Utility::ZCRMException.get_instance('remove_tags_from_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must at least be 1', 'NO TAGS PROVIDED')
        end

        if record_list.length > 100
          raise Utility::ZCRMException.get_instance('remove_tags_from_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records count must be less than or equals to 100', 'MORE RECORDS PROVIDED')
        end

        if record_list.length < 1
          raise Utility::ZCRMException.get_instance('remove_tags_from_multiple_records', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'records must at least be 1', 'NO RECORDS PROVIDED')
        end

        record_ids_as_string = ''
        record_list.each do |record_id|
          record_ids_as_string += record_id.to_s + ','
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = @module_instance.api_name + '/actions/remove_tags'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::DATA
        handler_ins.add_param('ids', record_ids_as_string)
        tag_names_as_string = ''
        tag_list.each do |tag_name|
          tag_names_as_string += tag_name.to_s + ','
        end

        handler_ins.add_param('tag_names', tag_names_as_string)
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        entity_responses = bulk_api_response.bulk_entity_response
        length = entity_responses.length
        length -= 1
        records = []
        (0..length).each do |i|
          entity_response_ins = entity_responses[i]
          next unless entity_response_ins.status == Utility::APIConstants::STATUS_SUCCESS

          tag_added_details = entity_response_ins.details
          record = Operations::ZCRMRecord.get_instance(@module_instance.api_name, tag_added_details['id'])
          tag_added_details['tags'].each do |tag_name|
            record.tag_list.push(Operations::ZCRMTag.get_instance(nil, tag_name))
          end
          records.push(record)
          entity_response_ins.data = record
        end
        bulk_api_response.data = records
        bulk_api_response
      end

      def add_tags(record, tag_list)
        if tag_list.length > 10
          raise Utility::ZCRMException.get_instance('add_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must be less than or equals to 10', 'MORE TAGS PROVIDED')
        end

        if tag_list.length < 1
          raise Utility::ZCRMException.get_instance('add_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must at least be 1', 'NO TAGS PROVIDED')
        end

        if record.nil? || record.entity_id.nil?
          raise Utility::ZCRMException.get_instance('add_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, ' record instance and record id must be given', 'RECORD or RECORD ID NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = record.module_api_name + '/' + record.entity_id + '/actions/add_tags'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::DATA
        tag_names_as_string = ''
        tag_list.each do |tag_name|
          tag_names_as_string += tag_name.to_s + ','
        end
        handler_ins.add_param('tag_names', tag_names_as_string)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::DATA, 0, 'details')
        response_details['tags'].each do |tag_name|
          record.tag_list.push(Operations::ZCRMTag.get_instance(nil, tag_name))
        end
        api_response.data = record
        api_response
      end

      def remove_tags(record, tag_list)
        if tag_list.length > 10
          raise Utility::ZCRMException.get_instance('remove_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must be less than or equals to 10', 'MORE TAGS PROVIDED')
        end

        if tag_list.length < 1
          raise Utility::ZCRMException.get_instance('remove_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'Tag count must be at least 1', 'NO TAGS PROVIDED')
        end

        if record.nil? || record.entity_id.nil?
          raise Utility::ZCRMException.get_instance('remove_tags', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, ' record instance and record id must be given', 'RECORD or RECORD ID NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = record.module_api_name + '/' + record.entity_id + '/actions/remove_tags'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::DATA
        tag_names_as_string = ''
        tag_list.each do |tag_name|
          tag_names_as_string += tag_name.to_s + ','
        end
        handler_ins.add_param('tag_names', tag_names_as_string)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::DATA, 0, 'details')
        response_details['tags'].each do |tag_name|
          record.tag_list.push(Operations::ZCRMTag.get_instance(nil, tag_name))
        end
        api_response.data = record
        api_response
      end

      def delete(tag_id)
        if tag_id.nil?
          raise Utility::ZCRMException.get_instance('delete', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, ' tag id must be given', 'TAG ID NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/tags/' + tag_id.to_s
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::TAG
        api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def merge(tag_id, merge_tag_id)
        if tag_id.nil? || merge_tag_id.nil?
          raise Utility::ZCRMException.get_instance('merge', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, ' tag id and merge tag id must be given', 'TAG ID OR MERGE TAG ID NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/tags/' + merge_tag_id.to_s + '/actions/merge'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::TAG
        tag_json = {}
        tag_json['conflict_id'] = tag_id.to_s
        handler_ins.request_body = handler_ins.request_body = Utility::CommonUtil.create_api_supported_input_json(tag_json, Utility::APIConstants::TAG)
        api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::TAG, 0, 'details')
        tag = Operations::ZCRMTag.get_instance(response_details['id'])
        tag_helper = TagAPIHandlerHelper.get_instance
        tag_helper.get_zcrmtag(tag, response_details)
        api_response.data = tag
        api_response
      end

      def update(tag)
        if tag.nil? || tag.id.nil?
          raise Utility::ZCRMException.get_instance('update', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'tag instance and tag id must be given', 'TAG INSTANCE OR TAG ID NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/tags/' + tag.id.to_s
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::TAG
        handler_ins.add_param('module', tag.module_apiname)
        tag_json = {}
        tag_json['name'] = tag.name
        handler_ins.request_body = handler_ins.request_body = Utility::CommonUtil.create_api_supported_input_json(tag_json, Utility::APIConstants::TAG)
        api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::TAG, 0, 'details')
        tag_helper = TagAPIHandlerHelper.get_instance
        tag_helper.get_zcrmtag(tag, response_details)
        api_response.data = tag
        api_response
      end
    end
    # THIS CLASS SERVES THE TagAPIHandler CLASS CONSTRUCTING JSON BODY AND INSTANCES
    class TagAPIHandlerHelper
      def initialize; end

      def self.get_instance
        TagAPIHandlerHelper.new
      end

      def get_zcrmtag(tag_ins, tag_details)
        tag_details.each do |key, value|
          tag_ins.id = value if (key == 'id') && !value.nil?
          if (key == 'created_by') && !value.nil?
            tag_ins.created_by = Operations::ZCRMUser.get_instance(tag_details['created_by']['id'], tag_details['created_by']['name'])
          end
          if (key == 'modified_by') && !value.nil?
            tag_ins.created_by = Operations::ZCRMUser.get_instance(tag_details['modified_by']['id'], tag_details['modified_by']['name'])
          end
          if (key == 'created_time') && !value.nil?
            tag_ins.created_time = tag_details['created_time']
          end
          if (key == 'modified_time') && !value.nil?
            tag_ins.modified_time = tag_details['modified_time']
          end
          if (key == 'count') && !value.nil?
            tag_ins.count = tag_details['count']
          end
        end
        tag_ins
      end

      def construct_json_for_tag(zcrmtag)
        tag_json = {}
        tag_json['id'] = zcrmtag.id unless zcrmtag.id.nil?
        tag_json['name'] = zcrmtag.name unless zcrmtag.name.nil?
        tag_json
      end
    end
    # THIS CLASS IS USED TO HANDLE RELATED LIST RELATED FUNCTIONALITY
    class RelatedListAPIHandler < APIHandler
      def initialize(parentrecord, related_list)
        @parentrecord = parentrecord
        if related_list.instance_of?(Operations::ZCRMModuleRelation)
          @related_list = related_list
        else
          @junction_record = related_list
        end
      end

      def self.get_instance(parentrecord, related_list)
        RelatedListAPIHandler.new(parentrecord, related_list)
      end

      def get_records(sort_by_field, sort_order, page, per_page)
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        unless sort_by_field.nil?
          handler_ins.add_param('sort_by_field', sort_by_field)
        end

        handler_ins.add_param('sort_order', sort_order) unless sort_order.nil?
        handler_ins.add_param('page', page)
        handler_ins.add_param('per_page', per_page)
        handler_ins.request_api_key = Utility::APIConstants::DATA
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        data_arr = bulk_api_response.response_json[Utility::APIConstants::DATA]
        entity_helper = EntityAPIHandlerHelper.get_instance
        record_ins_list = []
        data_arr.each do |record_data|
          zcrm_record = Operations::ZCRMRecord.get_instance(@related_list.api_name, record_data['id'])
          entity_helper.set_record_properties(zcrm_record, record_data)
          record_ins_list.push(zcrm_record)
        end
        bulk_api_response.data = record_ins_list
        bulk_api_response
      end

      def upload_attachment(file_path)
        if file_path.nil?
          raise Utility::ZCRMException.get_instance('upload_attachment', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'file path must be given', 'FILEPATH NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).upload_file(file_path)
        response_details = api_response.response_json.dig(Utility::APIConstants::DATA, 0, 'details')
        api_response.data = Operations::ZCRMAttachment.get_instance(@parent_record, response_details['id'])
        api_response
      end

      def upload_link_as_attachment(link_url)
        if link_url.nil?
          raise Utility::ZCRMException.get_instance('upload_link_as_attachment', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'link URL must be given', 'URL_LINK NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).upload_link_as_attachment(link_url)
        response_details = api_response.response_json.dig(Utility::APIConstants::DATA, 0, 'details')
        api_response.data = Operations::ZCRMAttachment.get_instance(@parent_record, response_details['id'])
        api_response
      end

      def add_relation
        if @junction_record.nil?
          raise Utility::ZCRMException.get_instance('add_relation', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'junction_record must be given', 'JUNCTION RECORD NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @junction_record.api_name + '/' + @junction_record.id
        data_array = @junction_record.related_data
        handler_ins.request_body = Utility::CommonUtil.create_api_supported_input_json(data_array, Utility::APIConstants::DATA)
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def remove_relation
        if @junction_record.nil?
          raise Utility::ZCRMException.get_instance('remove_relation', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'junction_record must be given', 'JUNCTION RECORD NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @junction_record.api_name + '/' + @junction_record.id
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def delete_attachment(attachment_id)
        if attachment_id.nil?
          raise Utility::ZCRMException.get_instance('delete_attachment', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'attachment id must be given', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name + '/' + attachment_id
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def download_attachment(attachment_id)
        if attachment_id.nil?
          raise Utility::ZCRMException.get_instance('download_attachment', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'attachment id must be given', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name + '/' + attachment_id
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        api_response = Request::APIRequest.get_instance(handler_ins).download_file
        api_response
      end

      def add_notes(note_instances)
        if note_instances.length > 100
          raise Utility::ZCRMException.get_instance('create_notes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note count must be less than or equals to 100', 'MORE NOTES PROVIDED')
        end

        if note_instances.length < 1
          raise Utility::ZCRMException.get_instance('create_notes', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note count must be at least 1', 'NO NOTES PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name
        handler_ins.request_api_key = Utility::APIConstants::DATA
        notes_api_helper = RelatedListAPIHandlerHelper.get_instance
        data_array = []
        note_instances.each do |note_instance|
          if note_instance.id.nil?
            data_array.push(notes_api_helper.get_zcrmnote_as_json(note_instance))
          else
            raise Utility::ZCRMException.get_instance('notes_Create', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note id must be nil', 'NOTE ID PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::DATA] = data_array
        handler_ins.request_body = request_json
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end

      def update_note(note_ins)
        if note_ins.nil? || note_ins.id.nil?
          raise Utility::ZCRMException.get_instance('update_note', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note instance and note id must be given', 'NOTE INSTANCE OR NOTE ID NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name + '/' + note_ins.id
        handler_ins.request_api_key = Utility::APIConstants::DATA
        helper_obj = RelatedListAPIHandlerHelper.get_instance
        input_json = helper_obj.get_zcrmnote_as_json(note_ins)
        handler_ins.request_body = Utility::CommonUtil.create_api_supported_input_json(input_json, Utility::APIConstants::DATA)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::DATA, 0, 'details')
        api_response.data = helper_obj.get_zcrm_note(response_details, note_ins, @parentrecord)
        api_response
      end

      def delete_note(note_ins)
        if note_ins.nil? || note_ins.id.nil?
          raise Utility::ZCRMException.get_instance('delete_note', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'note instance and note id must be given', 'NOTE INSTANCE OR NOTE ID NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name + '/' + note_ins.id
        handler_ins.request_api_key = Utility::APIConstants::DATA
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def get_attachments(page, per_page)
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.add_param('page', page)
        handler_ins.add_param('per_page', per_page)
        handler_ins.request_api_key = Utility::APIConstants::DATA
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        data_arr = bulk_api_response.response_json[Utility::APIConstants::DATA]
        helper_obj = RelatedListAPIHandlerHelper.get_instance
        attachment_ins_list = []
        data_arr.each do |attachmentdetails|
          zcrm_attachment = helper_obj.get_zcrm_attachment(attachmentdetails, @parentrecord)
          attachment_ins_list.push(zcrm_attachment)
        end
        bulk_api_response.data = attachment_ins_list
        bulk_api_response
      end

      def get_notes(sort_by, sort_order, page, per_page)
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = @parentrecord.module_api_name + '/' + @parentrecord.entity_id + '/' + @related_list.api_name
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.add_param('sort_by', sort_by) unless sort_by.nil?
        handler_ins.add_param('sort_order', sort_order) unless sort_order.nil?
        handler_ins.add_param('page', page)
        handler_ins.add_param('per_page', per_page)
        handler_ins.request_api_key = Utility::APIConstants::DATA
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        data_arr = bulk_api_response.response_json[Utility::APIConstants::DATA]
        helper_obj = RelatedListAPIHandlerHelper.get_instance
        note_ins_list = []
        data_arr.each do |notedetails|
          zcrm_note = helper_obj.get_zcrm_note(notedetails, nil, @parentrecord)
          note_ins_list.push(zcrm_note)
        end
        bulk_api_response.data = note_ins_list
        bulk_api_response
      end
    end
    # THIS CLASS SERVES THE RelatedListAPIHandler CLASS CONSTRUCTING JSON BODY AND INSTANCES
    class RelatedListAPIHandlerHelper
      def initialize; end

      def self.get_instance
        RelatedListAPIHandlerHelper.new
      end

      def get_zcrmnote_as_json(note_ins)
        note = {}
        note['Note_Title'] = note_ins.title unless note_ins.title.nil?
        note['Note_Content'] = note_ins.content
        note['Parent_Id'] = note_ins.parent_id unless note_ins.parent_id.nil?
        note['se_module'] = note_ins.parent_module unless note_ins.parent_module.nil?
        note
      end

      def get_zcrm_note(note_details, zcrmnote_ins = nil, parentrecord = nil)
        if zcrmnote_ins.nil?
          zcrmnote_ins = ZCRMSDK::Operations::ZCRMNote.get_instance(parentrecord, note_details['id'])
        end
        zcrmnote_ins.id = note_details['id']
        if note_details.key?('Note_Title')
          zcrmnote_ins.title = note_details['Note_Title']
        end
        if note_details.key?('Note_Content')
          zcrmnote_ins.content = note_details['Note_Content']
        end
        if note_details.key?('Owner')
          unless note_details['Owner'].nil?
            owner = note_details['Owner']
            zcrmnote_ins.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(owner['id'], owner['name'])
          end
        end
        if note_details.key?('Created_By')
          unless note_details['Created_By'].nil?
            created_by = note_details['Created_By']
            zcrmnote_ins.created_by = ZCRMSDK::Operations::ZCRMUser.get_instance(created_by['id'], created_by['name'])
          end
        end
        if note_details.key?('Modified_By')
          unless note_details['Modified_By'].nil?
            modified_by = note_details['Modified_By']
            zcrmnote_ins.modified_by = ZCRMSDK::Operations::ZCRMUser.get_instance(modified_by['id'], modified_by['name'])
          end
        end
        zcrmnote_ins.size = note_details['$size'] if note_details.key?('$size')
        if note_details.key?('Created_Time')
          zcrmnote_ins.created_time = note_details['Created_Time']
        end
        if note_details.key?('$editable')
          zcrmnote_ins.is_editable = note_details['$editable'] == true
        end
        if note_details.key?('Modified_Time')
          zcrmnote_ins.modified_time = note_details['Modified_Time']
        end
        if note_details.key?('$voice_note')
          zcrmnote_ins.is_voice_note = note_details['$voice_note']
        end
        if note_details.key?('$se_module')
          zcrmnote_ins.parent_module = note_details['$se_module']
        end
        if note_details.key?('Parent_Id')
          unless note_details['Parent_Id'].nil?
            parent_details = note_details['Parent_Id']
            unless parent_details['id'].nil?
              zcrmnote_ins.parent_id = parent_details['id']
            end
            unless parent_details['name'].nil?
              zcrmnote_ins.parent_name = parent_details['name']
            end
          end
        end
        zcrmnote_ins.size = note_details['$size'] if note_details.key?('$size')
        if note_details.key?('$attachments')
          unless note_details['$attachments'].nil?
            attachments = note_details['$attachments']
            attachment_instants = []
            attachments.each do |attachment|
              attachment_instants.push(get_zcrm_attachment(attachment, parentrecord))
            end
            zcrmnote_ins.attachments = attachment_instants
          end
        end
        zcrmnote_ins
      end

      def get_zcrm_attachment(attachment_details, parent_record)
        attachment_ins = ZCRMSDK::Operations::ZCRMAttachment.get_instance(parent_record, attachment_details['id'])
        if attachment_details.key?('File_Name')
          attachment_ins.file_name = attachment_details['File_Name']
        end
        if attachment_details.key?('$editable')
          attachment_ins.is_editable = attachment_details['$editable'] == true
        end
        if attachment_details.key?('$file_id')
          attachment_ins.file_id = attachment_details['$file_id']
        end
        if attachment_details.key?('Owner')
          unless attachment_details['Owner'].nil?
            owner = attachment_details['Owner']
            attachment_ins.owner = ZCRMSDK::Operations::ZCRMUser.get_instance(owner['id'], owner['name'])
          end
        end
        if attachment_details.key?('Created_By')
          unless attachment_details['Created_By'].nil?
            created_by = attachment_details['Created_By']
            attachment_ins.created_by = ZCRMSDK::Operations::ZCRMUser.get_instance(created_by['id'], created_by['name'])
          end
        end
        if attachment_details.key?('Modified_By')
          unless attachment_details['Modified_By'].nil?
            modified_by = attachment_details['Modified_By']
            attachment_ins.modified_by = ZCRMSDK::Operations::ZCRMUser.get_instance(modified_by['id'], modified_by['name'])
          end
        end
        if attachment_details.key?('Created_Time')
          attachment_ins.created_time = attachment_details['Created_Time']
        end
        if attachment_details.key?('Modified_Time')
          attachment_ins.modified_time = attachment_details['Modified_Time']
        end
        if attachment_details.key?('$type')
          attachment_ins.type = attachment_details['$type']
        end
        if attachment_details.key?('$se_module')
          attachment_ins.parent_module = attachment_details['$se_module']
        end
        if attachment_details.key?('Parent_Id')
          unless attachment_details['Parent_Id'].nil?
            parent_details = attachment_details['Parent_Id']
            unless parent_details['id'].nil?
              attachment_ins.parent_id = parent_details['id']
            end
            unless parent_details['name'].nil?
              attachment_ins.parent_name = parent_details['name']
            end
          end
        end
        if attachment_details.key?('Size')
          attachment_ins.size = attachment_details['Size']
        end
        if attachment_details.key?('$link_url')
          attachment_ins.link_url = attachment_details['$link_url']
        end
        attachment_ins
      end
    end

    class VariableAPIHandler < APIHandler
      def initialize(variable_ins = nil)
        @zcrmvariable = variable_ins
      end

      def self.get_instance(variable_ins = nil)
        VariableAPIHandler.new(variable_ins)
      end

      def create_variables(variables)
        if variables.length > 100
          raise Utility::ZCRMException.get_instance('create_variables', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'variable count must be less than or equals to 100', 'MORE VARIABLES PROVIDED')
        end

        if variables.length < 1
          raise Utility::ZCRMException.get_instance('create_variables', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'variable count must at least be 1', 'NO VARIABLES PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/variables'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_POST
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::VARIABLE
        variable_array = []
        variable_helper = VariableAPIHandlerHelper.get_instance
        variables.each do |variable|
          if variable.id.nil?
            variable_array.push(variable_helper.get_zcrmvariable_as_json(variable))
          else
            raise Utility::ZCRMException.get_instance('create_variables', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'variable id must be nil', 'VARIABLE ID PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::VARIABLE] = variable_array
        handler_ins.request_body = request_json
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end

      def update_variables(variables)
        if variables.length > 100
          raise Utility::ZCRMException.get_instance('update_variables', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'variable count must be less than or equals to 100', 'MORE VARIABLES PROVIDED')
        end

        if variables.length < 1
          raise Utility::ZCRMException.get_instance('update_variables', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'variable count must at least be 1', 'NO VARIABLES PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/variables'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::VARIABLE
        variable_array = []
        variable_helper = VariableAPIHandlerHelper.get_instance
        variables.each do |variable|
          unless variable.id.nil?
            variable_array.push(variable_helper.get_zcrmvariable_as_json(variable))
          else
            raise Utility::ZCRMException.get_instance('update_variables', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'variable id must not be nil', 'VARIABLE ID NOT PROVIDED')
          end
        end
        request_json = {}
        request_json[Utility::APIConstants::VARIABLE] = variable_array
        handler_ins.request_body = request_json
        bulk_api_response = Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        bulk_api_response
      end

      def get_variable(group_id)
        if @zcrmvariable.id.nil?
          raise Utility::ZCRMException.get_instance('get_variable', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the variable', 'ID IS NOT PROVIDED')
        end

        if group_id.nil?
          raise Utility::ZCRMException.get_instance('get_variable', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'group should be set for the variable', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = 'settings/variables/' + @zcrmvariable.id.to_s
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::VARIABLE
        handler_ins.add_param('group',group_id)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        obj = VariableAPIHandlerHelper.get_instance
        obj.get_zcrmvariable(@zcrmvariable, api_response.response_json.dig(Utility::APIConstants::VARIABLE, 0))
        api_response.data = @zcrmvariable
        api_response
      end

      def update_variable
        if @zcrmvariable.id.nil?
          raise Utility::ZCRMException.get_instance('update_variable', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the variable', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = 'settings/variables/' + @zcrmvariable.id.to_s
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_PUT
        handler_ins.request_api_key = Utility::APIConstants::VARIABLE
        helper_obj = VariableAPIHandlerHelper.get_instance
        input_json = helper_obj.get_zcrmvariable_as_json(@zcrmvariable)
        handler_ins.request_body = Utility::CommonUtil.create_api_supported_input_json(input_json, Utility::APIConstants::VARIABLE)
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        response_details = api_response.response_json.dig(Utility::APIConstants::VARIABLE, 0, 'details')
        @zcrmvariable.id = response_details['id']
        api_response.data = @zcrmvariable
        api_response
      end

      def delete_variable
        if @zcrmvariable.id.nil?
          raise Utility::ZCRMException.get_instance('delete_variable', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the variable', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = 'settings/variables/' + @zcrmvariable.id.to_s
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_DELETE
        handler_ins.request_api_key = Utility::APIConstants::VARIABLE
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        api_response
      end

      def get_variables
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/variables'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::VARIABLE
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        variables_json = bulk_api_response.response_json.dig(ZCRMSDK::Utility::APIConstants::VARIABLE)
        variable_list = []
        variable_helper = VariableAPIHandlerHelper.get_instance
        variables_json.each do |variable_json|
          variable_ins = Operations::ZCRMVariable.get_instance(variable_json['api_name'], variable_json['id'])
          variable_list.push(variable_helper.get_zcrmvariable(variable_ins, variable_json))
        end
        bulk_api_response.data = variable_list
        bulk_api_response
      end
    end

    class VariableAPIHandlerHelper
      def initialize; end

      def self.get_instance
        VariableAPIHandlerHelper.new
      end

      def get_zcrmvariable(zcrm_variable_ins, variable_details)
        variable_details.each do |key, value|
          zcrm_variable_ins.id = value if (key == 'id') && !value.nil?
          if (key == 'variable_group') && !value.nil?
            zcrm_variable_ins.variable_group = Operations::ZCRMVariableGroup.get_instance(variable_details['variable_group']['api_name'], variable_details['variable_group']['id'])
          elsif (key == 'api_name') && !value.nil?
            zcrm_variable_ins.api_name = variable_details['api_name']
          elsif (key == 'name') && !value.nil?
            zcrm_variable_ins.name = variable_details['name']
          elsif (key == 'id') && !value.nil?
            zcrm_variable_ins.id = variable_details['id']
          elsif (key == 'type') && !value.nil?
            zcrm_variable_ins.type = variable_details['type']
          elsif (key == 'value') && !value.nil?
            zcrm_variable_ins.value = variable_details['value']
          elsif (key == 'description') && !value.nil?
            zcrm_variable_ins.description = variable_details['description']
          end
        end
        zcrm_variable_ins
      end

      def get_zcrmvariable_as_json(zcrm_variable_ins)
        variable_json = {}
        variable_json['id'] = zcrm_variable_ins.id unless zcrm_variable_ins.id.nil?
        variable_json['name'] = zcrm_variable_ins.name unless zcrm_variable_ins.name.nil?
        variable_json['api_name'] = zcrm_variable_ins.api_name unless zcrm_variable_ins.api_name.nil?
        variable_json['type'] = zcrm_variable_ins.type unless zcrm_variable_ins.type.nil?
        variable_json['value'] = zcrm_variable_ins.value unless zcrm_variable_ins.value.nil?
        variable_json['description'] = zcrm_variable_ins.description unless zcrm_variable_ins.description.nil?
        unless zcrm_variable_ins.variable_group.nil?
          variable_group_json = {}
          variable_group_json['id'] = zcrm_variable_ins.variable_group.id unless zcrm_variable_ins.variable_group.nil? || zcrm_variable_ins.variable_group.id.nil?
          variable_group_json['api_name'] = zcrm_variable_ins.variable_group.id unless zcrm_variable_ins.variable_group.nil? || zcrm_variable_ins.variable_group.id.nil?
          variable_json['variable_group']= variable_group_json
        end
        variable_json
      end
    end

    class VariableGroupAPIHandler < APIHandler
      def initialize(variable_group_ins = nil)
        @zcrmvariablegroup = variable_group_ins
      end

      def self.get_instance(variable_group_ins = nil)
        VariableGroupAPIHandler.new(variable_group_ins)
      end

      def get_variable_group
        if @zcrmvariablegroup.id.nil?
          raise Utility::ZCRMException.get_instance('get_variable', Utility::APIConstants::RESPONSECODE_BAD_REQUEST, 'id should be set for the variable', 'ID IS NOT PROVIDED')
        end

        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = ''
        handler_ins.request_url_path = 'settings/variable_groups/' + @zcrmvariablegroup.id.to_s
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = Utility::APIConstants::VARIABLE_GROUP
        api_response = Request::APIRequest.get_instance(handler_ins).get_api_response
        obj = VariableGroupAPIHandlerHelper.get_instance
        obj.get_zcrmvariablegroup(@zcrmvariablegroup, api_response.response_json.dig(Utility::APIConstants::VARIABLE_GROUP, 0))
        api_response.data = @zcrmvariablegroup
        api_response
      end

      def get_variable_groups
        handler_ins = APIHandler.get_instance
        handler_ins.request_url_path = 'settings/variable_groups'
        handler_ins.request_method = ZCRMSDK::Utility::APIConstants::REQUEST_METHOD_GET
        handler_ins.request_api_key = ZCRMSDK::Utility::APIConstants::VARIABLE_GROUP
        bulk_api_response = ZCRMSDK::Request::APIRequest.get_instance(handler_ins).get_bulk_api_response
        variable_groups_json = bulk_api_response.response_json.dig(ZCRMSDK::Utility::APIConstants::VARIABLE_GROUP)
        variable_group_list = []
        variable_group_helper = VariableGroupAPIHandlerHelper.get_instance
        variable_groups_json.each do |variable_group_json|
          variable_group_ins = Operations::ZCRMVariableGroup.get_instance(variable_group_json['api_name'], variable_group_json['id'])
          variable_group_list.push(variable_group_helper.get_zcrmvariablegroup(variable_group_ins, variable_group_json))
        end
        bulk_api_response.data = variable_group_list
        bulk_api_response
      end
    end

    class VariableGroupAPIHandlerHelper
      def initialize; end

      def self.get_instance
        VariableGroupAPIHandlerHelper.new
      end

      def get_zcrmvariablegroup(zcrm_variablegroup_ins, variable_group_details)
        variable_group_details.each do |key, value|
          zcrm_variablegroup_ins.id = value if (key == 'id') && !value.nil?
          if (key == 'api_name') && !value.nil?
            zcrm_variablegroup_ins.api_name = variable_group_details['api_name']
          elsif (key == 'name') && !value.nil?
            zcrm_variablegroup_ins.name = variable_group_details['name']
          elsif (key == 'id') && !value.nil?
            zcrm_variablegroup_ins.id = variable_group_details['id']
          elsif (key == 'display_label') && !value.nil?
            zcrm_variablegroup_ins.display_label = variable_group_details['display_label']
          elsif (key == 'description') && !value.nil?
            zcrm_variablegroup_ins.description = variable_group_details['description']
          end
        end
        zcrm_variablegroup_ins
      end
    end
  end
end
