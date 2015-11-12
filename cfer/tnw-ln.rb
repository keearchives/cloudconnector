description 'This stack template for a Ubuntu legacy node EC2 instance'

# NOTE: This template depends on tnw-vpc.rb


# By not specifying a default value, a parameter becomes required.
# Specify this parameter by adding `--parameters KeyName:<ec2-keyname>` to your CLI options.
parameter :KeyName

# We define some more parameters the same way we did in the VPC template.
# Cfer will interpret the default value by looking up the stack output named `vpcid`
# on the stack named `vpc`.
#
# If you created the VPC stack with a different name, you can overwrite these default values
# by adding `VpcId:@<vpc-stack-name>.vpcid SubnetId:@<vpc-stack-name>.subnetid1`
# to your `--parameters` option
parameter :VpcId, default: '@tnw-vpc.vpcid'
parameter :SubnetId, default: '@tnw-vpc.subnetid3'

# This is the AMI in us-west-2 for a Ubuntu
parameter :ImageId, default: 'ami-5189a661'
parameter :InstanceType, default: 't2.micro'

# Define a security group to be applied to an instance.
# This one will allow SSH access from anywhere, and no other inbound traffic.
resource :instancesg, "AWS::EC2::SecurityGroup" do
  group_description 'Wide-open SSH'
  vpc_id Fn::ref(:VpcId)

  # Parameter values can be Ruby arrays and hashes. These will be transformed to JSON.
  # You could write your own functions to make stuff like this easier, too.
  security_group_ingress [
    {
      CidrIp: '0.0.0.0/0',
      IpProtocol: 'tcp',
      FromPort: 22,
      ToPort: 22
    }
  ]
end

# We can define extension objects, which extend the basic JSON-building
# functionality of Cfer. Cfer provides a few of these, but you're free
# to define your own by creating a class that matches the name of an
# CloudFormation resource type, inheriting from `Cfer::AWS::Resource`
# inside the `CferExt` module:
module CferExt::AWS::EC2
  # This class adds methods to resources with the type `AWS::EC2::Instance`
  # Remember, this class could go in your own gem to be shared between your templates
  # in a way that works with the rest of your infrastructure.
  class Instance < Cfer::Cfn::Resource
    def boot_script(data)
      # This function simply wraps a bash script in the little bit of extra
      # sugar (hashbang + base64 encoding) that EC2 requires for userdata boot scripts.
      # See the AWS docs here: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
      script = <<-EOS.strip_heredoc
      #!/bin/bash
      #{data}
      EOS

      user_data Base64.encode64(script)
    end
  end
end

(1..2).each do |i|
  resource "ln#{i}", "AWS::EC2::Instance" do
    # Using the extension defined above, we can have the instance write a simple
    # file to show that it's working. 
    #
    # here there should be a `welcome.txt` file sitting in the `ubuntu` user's home directory.
    boot_script "echo 'Welcome to Cfer!' > /home/ubuntu/welcome.txt"

    image_id Fn::ref(:ImageId)
    instance_type Fn::ref(:InstanceType)
    key_name Fn::ref(:KeyName)

    network_interfaces [ {
        AssociatePublicIpAddress: "true",
        DeviceIndex: "0",
        GroupSet: [ Fn::ref(:instancesg) ],
        SubnetId: Fn::ref(:SubnetId)
      } ]
  end
  output "ln#{i}", Fn::ref("ln#{i}")
end

