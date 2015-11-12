#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

# require "#{ENV['HOME']}/projects/fog/lib/fog"

if ARGV.size != 1
  puts "Usage: #{$PROGRAM_NAME} <stack name>"
  exit 1
end

config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

cf = Fog::AWS::CloudFormation.new(
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

events = cf.describe_stack_events('StackName' => ARGV[0]).body['Events']
events.each do |event|
  puts "Timestamp: #{event['Timestamp']}"
  puts "LogicalResourceId: #{event['LogicalResourceId']}"
  puts "ResourceType: #{event['ResourceType']}"
  puts "ResourceStatus: #{event['ResourceStatus']}"
  puts "ResourceStatusReason: #{event['ResourceStatusReason']}" if event['ResourceStatusReason']
  puts '--'
end
