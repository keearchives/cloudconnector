#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

# It's probably worth noting that prefix is actually suffix, at least structurally speaking.
# If the path to your nested bucket is 'foo/bar', then your method call would be: .get('foo', prefix: 'bar')
#
# Use the prefix option on the directory.get method. Example:

def get_files(path, options)
  connection = Fog::Storage.new(
    :provider => 'AWS',
    :aws_access_key_i =>  options[:key],
    :aws_secret_access_ke =>  options[:secret]
  )
  connection.directories.get(options[:bucket], prefix: path).files.map(&:key)
end

# But it looks to me as though this requires 2 API calls:
# connection.directories.create
# directory.files.create
# If I already have the directory (an S3 bucket) created,
# how do I create an file (an S3 object) with only one Fog call?

config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

connection = Fog::Storage.new(
  :provider => 'AWS',
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

directory = connection.directories.create(
  :key => "fog-demo-#{Time.now.to_i}",	# globally unique name
  :public => true
)

file = directory.files.create(
  :key =>  'index.html',
  :body =>  File.open('./index.html'),
  :public =>  true
)

# dir = connection.directories.new(:key => 'foo')   # no request made
# dir.files.create(...)

options = {
  :key    => config[:aws_access_key_id],
  :secret => config[:aws_secret_access_key],
  :bucket => '20151021-1031'
}

path = ''

get_files(path, options)
