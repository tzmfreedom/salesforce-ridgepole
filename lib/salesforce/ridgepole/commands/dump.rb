require 'salesforce/ridgepole/schema'
require 'restforce'

module SalesforceRidgepole
  module Commands
    class Dump
      def call
        salesforce_schema = Schema.load_from_salesforce(['Account'])
        puts salesforce_schema.dump
      end
    end
  end
end