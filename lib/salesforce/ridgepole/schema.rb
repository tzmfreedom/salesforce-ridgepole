
# create_table 'RidgePole__c', force: :cascade do |t|
#   t.string   'title'
#   t.text     'body'
# end

require 'erb'

module SalesforceRidgepole
  class Schema
    attr_accessor :tables

    def initialize(tables = [])
      @tables = tables
    end

    def create_table(object, options = {})
      table = Table.new(object, options)
      yield(table)
      tables << table
    end

    def dump
      file = File.read(File.join(__dir__, '_schema.erb'))
      result = ERB.new(file).result(binding)
      result.gsub(/^\s*\n/, '')
    end

    class << self
      def load_from_file(filepath)
        content = File.read(filepath)
        schema = Schema.new
        schema.instance_eval(content)
        schema
      end

      def load_from_salesforce(objects)
        @client ||= Restforce.new
        tables = objects.map do |object|
          describe_result = @client.describe(object)
          fields = describe_result[:fields].map do |field|
            type = field.type
            options = {
              length: field.length,
              precision: field.precision,
              label: field.label,
              name: field.name,
              custom: field.custom,
              inlineHelpText: field.inlineHelpText,
              externalId: field.externalId,
              defaultValue: field.defaultValue,
              calculated: field.calculated,
            }
            Schema::Field.new(type, options)
          end

          Schema::Table.new(object, {}, fields)
        end
        schema = Schema.new(tables)
      end
    end

    class Table
      attr_accessor :name
      attr_accessor :fields
      attr_accessor :options

      def initialize(name, options = {}, fields = [])
        @name = name
        @options = options
        @fields = fields
      end

      def string(name, options = {})
        fields << Field.new('string', options.merge(name: name))
      end

      def text(name, options = {})
        fields << Field.new('text', options.merge(name: name))
      end
    end

    class Field
      attr_accessor :type
      attr_accessor :name
      attr_accessor :options

      def initialize(type, options)
        @type = type
        @name = options.delete(:name)
        @options = options
      end
    end
  end
end