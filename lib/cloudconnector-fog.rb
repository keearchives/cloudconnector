#!/usr/bin/ruby

require 'rubygems'
require 'logger'
require 'yaml'
require 'fog'
require 'pry'
require 'json'

#
# The cloud connector is a software component, which runs as an agent 
# and acts as a reverse API proxy between the conductor and the provider 
# 
module Logging
  def logger
    @logger ||= Logging.logger_for(self.class.name)
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  class << self
    def logger_for(classname)
      @loggers[classname] ||= configure_logger_for(classname)
    end

    def configure_logger_for(classname)
      logger = Logger.new(STDOUT)
      logger.progname = classname
      logger
    end
  end
end

class CloudConnector
   # Mix in the ability to log stuff ...
   include Logging

   def initialize(provider='AWS', region='us-west-2')
      @provider=provider
      @region=region
      @server=nil 
      @config={}
      @connector={} 
      logger.debug "debugging info"
      logger.info "general logs"
      logger.warn "oh my…this isn't good"
      logger.error "boom!"
      logger.fatal "oh crap…"
   end

   def cloud_connect()
      logger.debug "Enter"
      @config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

      logger.info @config[:aws_access_key_id]
      logger.info @config[:aws_secret_access_key]

      @connector = Fog::Compute.new ({
           :provider => @provider,
           :region => @region
      })
#binding.pry
      logger.debug "Exit"
   end

   def cloud_instance_list_all()
      logger.debug "Enter"
# binding.pry
      instance_list = @connector.servers.all
      # logger.info instance_list.to_json
      num_instances = instance_list.length
      logger.info "We have " + num_instances.to_s()  + " servers"
      # puts instance_list.inspect
      my_hash = JSON.parse( instance_list.to_json )
      puts JSON.pretty_generate(my_hash)
      logger.debug "Exit"
   end
   
   def cloud_instance_get(instance_id)
      logger.debug "Enter"
      @server = @connector.servers.get(instance_id)
      if @server == nil then
         logger.error instance_id + "instance not found"
      else
         # logger.info @server.to_json
         # logger.info @server.inspect.to_json
         logger.info "Flavor: #{@server.flavor_id}"
         logger.info "Public IP Address: #{@server.public_ip_address}"
         logger.info "Private IP Address: #{@server.private_ip_address}"
         my_hash = JSON.parse( @server.to_json )
         puts JSON.pretty_generate(my_hash)
      end
      logger.debug "Exit"
   end

   def cloud_instance_start(instance_id)
      logger.debug "Enter"
      @server.start_instances(instance_id)
      logger.debug "Exit"
   end 

   def cloud_instance_stop(instance_id)
      logger.debug "Enter"
      @server.stop_instances(instance_id)
      logger.debug "Exit"
   end 

   def cloud_instance_destroy(instance_id)
      logger.debug "Enter"
      @server.destroy
      logger.debug "Exit"
   end 
 
   def cloud_instance_create(ami_id='ami-506e8d63', vpc_id, key_name)
      logger.debug "Enter"
      # start a server
      @server = @connector.servers.create(
        :image_id=>ami_id,
        :flavor_id=>'t1.micro',
        :key_name => key_name
      )

      # wait for it to get online
      @server.wait_for { print "."; ready? }

      # public address -> ec2-79-125-45-252.eu- west-1.compute.amazonaws.com -> ssh into it
      logger.info server.dns_name

      # instance id -> find it again
      @connector.servers.get(@server.id)
      logger.debug "Exit"
   end

   def cloud_vpc_create()
# https://github.com/fog/fog/issues/713
# http://stackoverflow.com/questions/14282825/fog-hangs-on-fogcompute-servers-bootstrap

# https://github.com/fog/fog-aws/blob/master/lib/fog/aws/requests/compute/create_network_interface.rb
# https://github.com/fog/fog/commit/de03761f3439001d6bff205888bf535149c201c4
      Fog.credential = waffles
      @connector = EC2.servers.bootstrap 
       (
          image_id:   AMI_ID,
          flavor_id:  FLAVOR_ID,
          private_key_path: '~/.ssh/id_rsa',
          public_key_path: '~/.ssh/id_rsa.pub',
          tags:       { Name: TAGGED_NAME },
          username: ROOT_USER
      )
      EC2.delete_key_pair("fog_waffles")
      @connector.servers.create
      (
      :vpc_id             => config[:vpc_id],
      :subnet_id          => config[:subnet_id],
      :availability_zone  => config[:availability_zone],
      :security_group_ids => config[:security_group_ids],
      :tags               => config[:tags],
      :flavor_id          => config[:flavor_id],
      :ebs_optimized      => config[:ebs_optimized],
      :image_id           => config[:image_id],
      :key_name           => config[:aws_ssh_key_id]
      )
   end
   
   def deploy(j, y)
      logger.debug "Enter"
      logger.debug "Exit"
   end
end


if __FILE__ == $0
  puts "Hello"
  cc = CloudConnector.new('AWS', 'us-west-2')
  cc.cloud_connect()
  cc.cloud_instance_list_all()
  cc.cloud_instance_get('i-04085fc2')
end

exit

