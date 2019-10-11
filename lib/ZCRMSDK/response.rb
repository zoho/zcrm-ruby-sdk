# frozen_string_literal: true

require_relative 'utility'
require 'json'
module ZCRMSDK
  module Response
    # THIS CLASS IS USED TO STORE DETAILS ABOUT THE API RESPONSE , PROCESS JSON AND HANDLE FAULTY RESPONSES
    class CommonAPIResponse
      attr_accessor :response_json, :response_headers, :response, :status_code, :api_key, :url, :data, :status, :code, :message, :details
      def initialize(response, status_code, url, api_key = nil)
        @response_json = nil
        @response_headers = nil
        @response = response
        @status_code = status_code
        @api_key = api_key
        @url = url
        @data = nil
        @status = nil
        @code = nil
        @message = nil
        @details = nil
        set_response_json
        process_response
      end

      def self.get_instance(response, status_code, url, api_key = nil)
        CommonAPIResponse.new(response, status_code, url, api_key)
      end

      def set_response_json
        if (@status_code != Utility::APIConstants::RESPONSECODE_NO_CONTENT) && (@status_code != Utility::APIConstants::RESPONSECODE_NOT_MODIFIED)
          @response_json = JSON.parse(@response.body)
        else
          @response_json = {}
          @response_headers = {}
          return
        end
        @response_headers = @response.to_hash
      end

      def process_response
        if Utility::APIConstants::FAULTY_RESPONSE_CODES.include?(@status_code)
          handle_faulty_responses
        elsif (@status_code == Utility::APIConstants::RESPONSECODE_ACCEPTED) || (@status_code == Utility::APIConstants::RESPONSECODE_OK) || (@status_code == Utility::APIConstants::RESPONSECODE_CREATED)
          process_response_data
        end
      end

      def handle_faulty_responses
        nil
      end

      def process_response_data
        nil
      end
    end
    # THIS CLASS IS USED TO HANDLE API RESPONSE
    class APIResponse < CommonAPIResponse
      def initialize(response, status_code, url, api_key)
        super
      end

      def self.get_instance(response, status_code, url, api_key)
        APIResponse.new(response, status_code, url, api_key)
      end

      def handle_faulty_responses
        if @status_code == Utility::APIConstants::RESPONSECODE_NO_CONTENT
          error_msg = Utility::APIConstants::NO_CONTENT
          exception = Utility::ZCRMException.get_instance(@url, @status_code, error_msg, Utility::APIConstants::NO_CONTENT, nil, error_msg)
        else
          response_json = @response_json
          exception = Utility::ZCRMException.get_instance(@url, @status_code, response_json[Utility::APIConstants::MESSAGE], response_json[Utility::APIConstants::CODE], response_json[Utility::APIConstants::DETAILS], response_json[Utility::APIConstants::MESSAGE])
        end
        raise exception
      end

      def process_response_data
        resp_json = @response_json
        if resp_json.include?(api_key)
          resp_json = @response_json[api_key]
          resp_json = resp_json[0] if resp_json.instance_of?(Array)
        end
        if resp_json.include?(Utility::APIConstants::STATUS) && (resp_json[Utility::APIConstants::STATUS] == Utility::APIConstants::STATUS_ERROR)
          exception = Utility::ZCRMException.get_instance(@url, @status_code, resp_json[Utility::APIConstants::MESSAGE], resp_json[Utility::APIConstants::CODE], resp_json[Utility::APIConstants::DETAILS], resp_json[Utility::APIConstants::STATUS])
          raise exception
        elsif resp_json.include?(Utility::APIConstants::STATUS) && (resp_json[Utility::APIConstants::STATUS] == Utility::APIConstants::STATUS_SUCCESS)
          @status = resp_json[Utility::APIConstants::STATUS]
          @code = resp_json[Utility::APIConstants::CODE]
          @message = resp_json[Utility::APIConstants::MESSAGE]
          @details = resp_json[Utility::APIConstants::DETAILS]
        end
      end
    end
    # THIS CLASS IS USED TO BULK API RESPONSE
    class BulkAPIResponse < CommonAPIResponse
      attr_accessor :bulk_entity_response, :info
      def initialize(response, status_code, url, api_key)
        @bulk_entity_response = []
        super
        if @response_json.include?(Utility::APIConstants::INFO)
          @info = ResponseInfo.get_instance(@response_json[Utility::APIConstants::INFO])
        end
      end

      def self.get_instance(response, status_code, url, api_key)
        BulkAPIResponse.new(response, status_code, url, api_key)
      end

      def handle_faulty_responses
        if @status_code == Utility::APIConstants::RESPONSECODE_NO_CONTENT
          error_msg = Utility::APIConstants::NO_CONTENT
          exception = Utility::ZCRMException.get_instance(@url, @status_code, error_msg, Utility::APIConstants::NO_CONTENT, nil, error_msg)
        else
          response_json = @response_json
          exception = Utility::ZCRMException.get_instance(@url, @status_code, response_json[Utility::APIConstants::MESSAGE], response_json[Utility::APIConstants::CODE], response_json[Utility::APIConstants::DETAILS], response_json[Utility::APIConstants::MESSAGE])
        end
        raise exception
      end

      def process_response_data
        responses_json = @response_json
        if responses_json.include?(@api_key)
          records_data = @response_json[api_key]
          records_data.each do |record_data|
            if !record_data.nil? && record_data.key?(Utility::APIConstants::STATUS)
              @bulk_entity_response.push(EntityResponse.get_instance(record_data))
            end
          end
        end
      end
    end
    # THIS CLASS IS USED TO HANDLE FILE API RESPONSE
    class FileAPIResponse
      attr_accessor :filename, :response_json, :response_headers, :response, :status_code, :url, :data, :status, :code, :message, :details
      def initialize(response, status_code, url)
        @response_json = nil
        @response_headers = nil
        @response = response
        @status_code = status_code
        @url = url
        @data = nil
        @status = nil
        @code = nil
        @message = nil
        @details = nil
        @filename = nil
      end

      def self.get_instance(response, status_code, url)
        FileAPIResponse.new(response, status_code, url)
      end

      def set_file_content
        if @status_code == Utility::APIConstants::RESPONSECODE_NO_CONTENT
          error_msg = Utility::APIConstants::NO_CONTENT
          exception = Utility::ZCRMException.get_instance(@url, @status_code, error_msg, Utility::APIConstants::NO_CONTENT, nil, error_msg)
          raise exception
        end
        if Utility::APIConstants::FAULTY_RESPONSE_CODES.include?(@status_code)
          content = JSON.parse(@response.body)
          exception = Utility::ZCRMException.get_instance(@url, @status_code, content[Utility::APIConstants::MESSAGE], content[Utility::APIConstants::CODE], content[Utility::APIConstants::DETAILS], content[Utility::APIConstants::MESSAGE])
          raise exception
        elsif @status_code == Utility::APIConstants::RESPONSECODE_OK
          @response_headers = @response.to_hash
          @status = Utility::APIConstants::STATUS_SUCCESS
          @filename = @response_headers['content-disposition'][0]
          @filename = @filename[@filename.rindex("'") + 1..@filename.length]
          @response = @response.body
        end
        @response_headers = @response.to_hash if @response_headers.nil?
      end
    end
    # THIS CLASS IS USED TO HANDLE ENTITY  API RESPONSE
    class EntityResponse
      attr_accessor :response_json, :code, :message, :status, :details, :data, :upsert_action, :upsert_duplicate_field
      def initialize(entity_response)
        @response_json = entity_response
        @code = entity_response[Utility::APIConstants::CODE]
        @message = entity_response[Utility::APIConstants::MESSAGE]
        @status = entity_response[Utility::APIConstants::STATUS]
        @details = nil
        @data = nil
        @upsert_action = nil
        @upsert_duplicate_field = nil
        if entity_response.key?(Utility::APIConstants::DETAILS)
          @details = entity_response[Utility::APIConstants::DETAILS]
        end
        if entity_response.key?(Utility::APIConstants::ACTION)
          @upsert_action = entity_response[Utility::APIConstants::ACTION]
        end
        if entity_response.key?(Utility::APIConstants::DUPLICATE_FIELD)
          @upsert_duplicate_field = entity_response[Utility::APIConstants::DUPLICATE_FIELD]
        end
      end

      def self.get_instance(entity_response)
        EntityResponse.new(entity_response)
      end
    end
    # THIS CLASS IS USED TO STORE RESPONSE INFO
    class ResponseInfo
      attr_reader :is_more_records, :page, :per_page, :count
      def initialize(response_info_json)
        @is_more_records = (response_info_json['more_records']) == true
        @page = (response_info_json['page']).to_i
        @per_page = (response_info_json['per_page']).to_i
        @count = (response_info_json['count']).to_i
      end

      def self.get_instance(response_info_json)
        ResponseInfo.new(response_info_json)
      end
    end
  end
end
