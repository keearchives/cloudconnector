#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

# rackspace_server.rb

connection = Fog::Compute.new(provider: 'Rackspace')

server = connection.servers.bootstrap(
  private_key_path: ENV['HOME'] + '/.ssh/fog',
  public_key_path: ENV['HOME'] + '/.ssh/fog.pub',
  username: 'ubuntu'
)
