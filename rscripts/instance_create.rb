#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

# Import EC2 credentials e.g. @aws_access_key_id and @aws_access_key_id
config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

# Set up a connection
# connection = Fog::AWS::EC2.new(
connection = Fog::Compute.new(
  :provider => 'AWS',
  :region => 'us-west-1',
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key])

# Get a list of all the running servers/instances
instance_list = connection.servers.all

num_instances = instance_list.length
puts 'We have ' + num_instances.to_s + ' servers'

# Print out a table of instances with choice columns
instance_list.table([:id, :flavor_id, :ip_address, :private_ip_address, :image_id])

###################################################################
# Get a list of our images
###################################################################
my_images_raw = connection.describe_images('Owner' => 'self')
my_images = my_images_raw.body['imagesSet']

puts "\n###################################################################################"
puts 'Following images are available for deployment'
puts "\nImage ID\tArch\t\tImage Location"

#  List image ID, architecture and location
for key in 0...my_images.length
  print my_images[key]['imageId'], "\t", my_images[key]['architecture'], "\t\t", my_images[key]['imageLocation'], "\n"
end
