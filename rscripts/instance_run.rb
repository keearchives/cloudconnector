#!/usr/bin/ruby
require 'rubygems'
require 'fog'

# Set up a connection
connection = Fog::AWS::EC2.new(
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

server = connection.servers.create(
  :image_id => 'ami-52e00261',
  :flavor_id => 't1.micro')

# wait for it to be ready to do stuff
server.wait_for { print '.'; ready? }

puts "Public IP Address: #{server.ip_address}"
puts "Private IP Address: #{server.private_ip_address}"

# This may take a while so please be patient.
# You could obviously spin up a number of these instances
# without waiting for any of them to be available then use
# connection.servers.all to get a list of running instances.
