
#################################################################
#
# File: config.ru
#
#################################################################

require "rubygems"
require "bundler/setup"

require "json"
require "pry"

$: << File.join(File.dirname(__FILE__), "lib")
require "api"

# Simplistic router based on path and request method
class Router
  def self.find_match(request_method, path, routes)
    routes.each do |route|
      if match = match_route(request_method, path, route)
        return match
      end
    end
    return nil
  end

  def self.match_route(request_method, path, route)
    if route[:method] == request_method && match_data = route[:path].match(path)
      #route_match = route[:api_method].slice
      #binding.pry
      route_match = {}
      route_match[:api_method] = route[:api_method]
      if match_data.names.length > 0
        route_match[:params] = match_data.names.inject({}) { |params, name| params[name] = match_data[name] ; params }
      else
        route_match[:params] = {}
      end
#       binding.pry
       route_match	
#        Api.send(route_match, params)
    else
      nil
    end
  end
end

run(->(env) {
  request = Rack::Request.new(env)  
  if route_match = Router.find_match(request.request_method, request.path, Api.routes)
    begin
#      binding.pry
# not activerecord rails stuff.  ensure it is a hash
#      api_params = HashWithIndifferentAccess.new(request.params.merge(route_match[:params]))
      api_params = request.params.merge(route_match[:params]).to_h
      response_data = Api.send(route_match[:api_method], api_params)

      [200, {'Content-Type' => 'application/json'}, StringIO.new(response_data.to_json)]
#      [404, {'Content-Type' => 'text/plain'}, StringIO.new(e.message)]
#      [422, {'Content-Type' => 'text/plain'}, StringIO.new(e.record.full_error_messages)]
    end
  else
    [404, {'Content-Type' => 'text/plain'}, StringIO.new('method not defined')]
  end
})

