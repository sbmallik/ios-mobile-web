#!/usr/bin/ruby
require 'net/http'
require 'uri'
require 'json'
require 'pp'
require 'aws-sdk'

class SchemaParser
    def initialize
        @propertySection = []
        @propertySubsection = []
        @searchedName = nil
    end

    # dumps Sections portion of S3 bucket
    def read_json(propertyName)
        # constructs S3 client and retrieves bucket information
        s3 = Aws::S3::Client.new(
            region: 'us-east-1'
        )
        resp = s3.get_object(bucket: 'ldsn-general', key: 'bonnie-configs/latest/active.json')
        versionInfo = JSON.parse(resp.body.string)
        versionNum = '/' + versionInfo[propertyName].first['configVersion']

        # property Information from S3
        propertyResp = s3.get_object(bucket: 'ldsn-general', key: 'bonnie-configs/latest/configurations/' + propertyName + versionNum + '/config.json')
        JSON.parse(propertyResp.body.string)
    end

    def check_for(object, propertyName)
      objectFound = false

    jsonBody = read_json(propertyName)

    jsonBody["sections"].each do |jsonObject|
      unless jsonObject.nil? || jsonObject["subsections"].nil?
        jsonObject["subsections"].each do |subsection|
          if(subsection["sectionType"] == object)
            set_propertySection(jsonObject["name"])
            @searchedName = subsection["name"];
            objectFound = true
          end
        end
      end
    end
    objectFound
    end

    def test_for(propertyName)
        jsonBody = read_json(propertyName)

        jsonBody['sections'].each do |jsonObject|
            if jsonObject['subsections'].nil? == true
                unless jsonObject.nil?
                    set_propertySection(jsonObject['name'])
                    @searchedName = jsonObject['name']
                end
            else
                unless jsonObject.nil? || jsonObject['subsections'].nil?
                    jsonObject['subsections'].each do |subsection|
                        set_propertySection(jsonObject['name'])
                        @searchedName = subsection['name']
                    end
                end
            end
        end
    end

    def card_front(object,propertyName)
      objectFound = false

      jsonBody = read_json(propertyName)

      jsonBody["sections"].each do |jsonObject|
        unless jsonObject.nil? || jsonObject["subsections"].nil?
          jsonObject["subsections"].each do |subsection|
            if(subsection["sectionType"] == "CardFront" && subsection["name"]== object)
              set_propertySection(jsonObject["name"])
              @searchedName = subsection["name"];
              objectFound = true
            end
          end
        end
      end
      objectFound
    end

    def webview_front(object,propertyName)
      objectFound = false

      jsonBody = read_json(propertyName)

      jsonBody["sections"].each do |jsonObject|
        unless jsonObject.nil? || jsonObject["subsections"].nil?
          jsonObject["subsections"].each do |subsection|
            if(subsection["sectionType"] == object)
              set_propertySection(jsonObject["name"])
              set_propertySubsection(subsection["name"])
              objectFound = true
            end
          end
        end
      end
      objectFound
    end

#********The code below is for future dev purpose***************

    # def schema_front(object,propertyName)
    #   objectFound = false
    #
    #   jsonBody = read_json(propertyName)
    #
    #   jsonBody["sections"].each do |jsonObject|
    #     if jsonObject['subsections'].nil? == true
    #       # unless jsonObject["subsections"].nil?
    #         # jsonObject["subsections"].each do |subsection|
    #           if(section["sectionType"] == object)
    #             set_propertySection(jsonObject["name"])
    #             set_propertySubsection(jsonObject["name"])
    #             objectFound = true
    #           end
    #         # end
    #       # end
    #     else
    #       unless jsonObject.nil? || jsonObject["subsections"].nil?
    #         jsonObject["subsections"].each do |subsection|
    #           if(subsection["sectionType"] == object)
    #             set_propertySection(jsonObject["name"])
    #             set_propertySubsection(subsection["name"])
    #             objectFound = true
    #           end
    #         end
    #       end
    #     end
    #   end
    #   objectFound
    # end

    def set_propertySection(object)
        @propertySection << object unless @propertySection.include? object
    end

    def set_propertySubsection(object)
        @propertySubsection << object unless @propertySubsection.include? object
    end

    def get_propertySection
        @propertySection
    end

    def get_propertySubsection
        @propertySubsection
    end

    def get_Searched_Name
        @searchedName
    end
end
