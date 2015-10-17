#################################################################
#
# File: lib/api.rb
#
#################################################################
# dispatch restful calls to enable provider connector  and return 
# json responses
# require 'cloudconnector'  # Service Provider Instance Wrapper

class Api
# roouters and needed variables to service the rest interface
  def self.routes
    [
      { method: "GET",  		path: %r{^/v1/instance/listall}, 			api_method: 	:listall	},
      { method: "GET",  		path: %r{^/v1/instance/(?<id>\d+)/find}, 		api_method: 	:find		},
      { method: "PUT",  		path: %r{^/v1/instance/(?<id>\d+)/create}, 		api_method: 	:create		},
      { method: "DELETE",		path: %r{^/v1/instance/(?<id>\d+)/remove}, 		api_method: 	:remove		},
      { method: "POST",			path: %r{^/v1/instance/(?<id>\d+)/stop}, 		api_method: 	:stop		},
      { method: "POST",			path: %r{^/v1/instance/(?<id>\d+)/start}, 		api_method: 	:start		},
      { method: "POST",			path: %r{^/v1/instance/(?<id>\d+)/save}, 		api_method: 	:save		},
      { method: "PUT",  		path: %r{^/v1/connect/}, 				api_method: 	:connect	},
      { method: "GET",  		path: %r{^/v1/deploy}, 					api_method: 	:deploy		}
    ]    
  end

# Modeling based on this nice little aws broker
# https://github.com/cloudfoundry-samples/go_service_broker/blob/master/client/aws.go
#
# implement is small so perhaps we can evaluate and test aws ec2 v2 or fog-aws 
# https://github.com/fog/fog-aws/blob/master/tests/requests/compute/instance_attrib_tests.rb
#
# http://docs.aws.amazon.com/sdkforruby/api/index.html
#
# Get all instances

# list all instance
  def self.listall(params)
# make connectors to providers with focus on aws and rackspace
    puts "CloudConnector.listall(params[:id])"
  end

# Get handle to an instance
  def self.find(params)
    puts "CloudConnector.find(params[:id])"
  end
  
# Create an instance
  def self.create(params)
    puts "CloudConnector.create(params[:id])"
  end
  
  def self.remove(params)
    puts "CloudConnector.create!(params[:id])"
  end
  
  def self.start(params)
    puts "CloudConnector.start(params[:id])"
  end

  def self.stop(params)
    puts "CloudConnector.stop(params[:id])"
  end

# Test or init a connection to AWS (cloud provider)
  def self.connect(params)
    puts "CloudConnector.connect(params[:id])"
  end


# cloudfoundation interface - there are alot of vpc work to set up an instance: json template and parameter file are inputs
# http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html
  def self.deploy(params)
    puts "CloudConnector.stack_create(params[:id])"
  end

end

