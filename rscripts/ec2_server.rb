#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

# ec2_server.rb
config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

connection = Fog::Compute.new(provider: 'AWS',
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

server = connection.servers.bootstrap(
  private_key_path: ENV['HOME'] + '/.ssh/fog',
  public_key_path: ENV['HOME'] + '/.ssh/fog.pub',
  username: 'ubuntu'
)
