#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

# Import EC2 credentials e.g. @aws_access_key_id and @aws_access_key_id
config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

# Set up a connection
connection = Fog::AWS::EC2.new(
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

instance_id = 'i-8e4a5748'

server = connection.servers.get(instance_id)

puts "Flavor: #{server.flavor_id}"
puts "Public IP Address: #{server.ip_address}"
puts "Private IP Address: #{server.private_ip_address}"

server.destroy
