#!/usr/bin/ruby

require 'optparse'
require 'rubygems'
require 'yaml'
require 'fog'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} -n STACK_NAME -t TEMPLATE_FILE [options]"

  options[:name] = nil
  opts.on('-n', '--name NAME', 'Required name attribute') do |name|
    options[:name] = name
  end

  options[:parameters] = {}
  opts.on('-p', '--parameters KEY=VALUE', 'Set the parameters for a stack template',
          '(can be comma separated key value pairs)') do |params|
    params.split(',').each do |param|
      k, v = param.split('=')
      fail 'Invalid parameter definition' unless v
      options[:parameters][k] = v
    end
  end

  options[:template] = nil
  opts.on('-t', '--template FILE', 'Set the template file for this stack') do |file|
    options[:template] = file
  end
end

parser.parse!
[:name, :template].each do |p|
  fail "Missing required parameter: --#{p}" unless options[p]
end

config = YAML.load(File.open(ENV['HOME'] + '/.fog'))[:default]

template_body = ''
File.open(options[:template]) { |f| template_body << f.read }

cf = Fog::AWS::CloudFormation.new(
  :aws_access_key_id => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)

def aws_params(hash)
  r = {}
  c = 1
  hash.each do |k, v|
    r["Parameters.member.#{c}.ParameterKey"] = k
    r["Parameters.member.#{c}.ParameterValue"] = v
    c += 1
  end
  r
end

# ./create-stack.rb --name drupal --parameters KeyName=allan,InstanceType=m1.large --template drupal_dev.template
cf.create_stack(options[:name], { 'TemplateBody' => template_body }.merge!(aws_params(options[:parameters])))

