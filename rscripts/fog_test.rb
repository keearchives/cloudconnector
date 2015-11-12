#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

fog = Fog::Compute.new(
  :provider => 'AWS',
  :region => 'us-west-1',
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

# start a server
server = fog.servers.create(
  :image_id => 'ami-52e00261',
  :flavor_id => 't1.micro',
  :key_name => 'tk.pem'
)

# wait for it to get online
server.wait_for { print '.'; ready? }

# public address -> ec2-79-125-45-252.eu- west-1.compute.amazonaws.com -> ssh into it
server.dns_name

# instance id -> find it again
fog.servers.get(server.id)

# shutdown
server.destroy
