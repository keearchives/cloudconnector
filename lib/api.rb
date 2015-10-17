#################################################################
#
# File: lib/api.rb
#
#################################################################

# require 'cloudconnector'  # Service Provider Instance Wrapper

class Api
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

# https://github.com/cloudfoundry-samples/go_service_broker/blob/master/client/aws.go
# :
# Get all instances
  def self.listall(params)
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

# cloudfoundation
# http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html
  def self.deploy(params)
    puts "CloudConnector.stack_create(params[:id])"
  end

end

