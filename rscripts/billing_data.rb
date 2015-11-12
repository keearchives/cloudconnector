#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

# Returns contents of the billing data file for the given year and month.
#
# Example:
#   csv_str = read_billing_file 2011, 1
#   csv_str = read_billing_file 2013, 12
#
def read_billing_file(year, month)
  connection = Fog::Storage.new(provider: 'AWS') # credentials in fog.yml
  month = "0#{month}" if month.to_s.size == 1
  regex = /aws-cost-allocation-#{year}-#{month}\.csv$/
  cost_file = connection.directories.get(S3_BUCKET).files.detect do|file|
    file.key =~ regex
  end
  return nil unless cost_file
  cost_file.body
end

config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]
csv_str = read_billing_file 2015, 10
print csv_str
