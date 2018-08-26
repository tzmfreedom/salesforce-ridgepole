require 'thor'
require 'salesforce/ridgepole/commands/apply'

module SalesforceRidgepole
  class Cli < Thor
    desc 'apply', 'Apply Schema to Salesforce'
    method_option :file, type: :string, aliases: ['-f']
    def apply
      command = Commands::Apply.new
      command.call(options[:file])
    end
  end
end