#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'
require 'pp'

# Import EC2 credentials e.g. @aws_access_key_id and @aws_access_key_id
config = YAML::load(File.open(ENV['HOME']+'/.fog'))[:default]

# Set up a connection
connection = Fog::AWS::EC2.new( 
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

# Get a list of all the running servers/instances
instance_list = connection.servers.all

num_instances = instance_list.length 
puts “We have “ + num_instances.to_s()  + “ servers”

# Print out a table of instances with choice columns
instance_list.table([:id, :flavor_id, :ip_address, :private_ip_address, :image_id ])

