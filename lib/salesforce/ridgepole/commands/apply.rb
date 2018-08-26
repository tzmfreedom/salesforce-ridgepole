require 'salesforce/ridgepole/schema'
require 'restforce'

module SalesforceRidgepole
  module Commands
    class Apply
      def call(filepath)
        local_schema = Schema.load_from_file(filepath)
        salesforce_objects = local_schema.tables.map(&:name)
        salesforce_schema = Schema.load_from_salesforce(salesforce_objects)

        # apply
        # client = Restforce.tooling
        # client.create!('CustomObject', {
        #   DeveloperName: 'Ridgepole__c',
        #   Description: 'ほげほげー'
        # })
      end
    end
  end
end