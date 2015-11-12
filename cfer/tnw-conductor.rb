description 'This stack template for a Conductor EC2 instance'

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
parameter :SubnetId, default: '@tnw-vpc.subnetid1'

# This is the AMI in us-west-2 for a HIPswitch
# parameter :ImageId, default: 'ami-8f8492ee'
parameter :ImageId, default: 'ami-d08363e3'
parameter :InstanceType, default: 't1.micro'

# Define a security group to be applied to an instance.
# This one will allow SSH access from anywhere, and no other inbound traffic.
resource :instancesg, "AWS::EC2::SecurityGroup" do
  group_description 'Conductor SG'
  vpc_id Fn::ref(:VpcId)

  # Parameter values can be Ruby arrays and hashes. These will be transformed to JSON.
  # You could write your own functions to make stuff like this easier, too.
  security_group_ingress [
    {
      CidrIp: '0.0.0.0/0',
      IpProtocol: 'tcp',
      FromPort: 22,
      ToPort: 22
    },
    {
      CidrIp: '0.0.0.0/0',
      IpProtocol: 'tcp',
      FromPort: 8090,
      ToPort: 8090
    },
    {
      CidrIp: '0.0.0.0/0',
      IpProtocol: 'tcp',
      FromPort: 443,
      ToPort: 443
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

resource :instance, "AWS::EC2::Instance" do
  # Using the extension defined above, we can have the instance write a simple
  # file to show that it's working. 
  # here there should be a `welcome.txt` file sitting in the `ubuntu` user's home directory.
  # boot_script "echo 'Welcome to Cfer!' > /home/ubuntu/welcome.txt"
  # Conductor does not need any cloud-init injection

  image_id Fn::ref(:ImageId)
  instance_type Fn::ref(:InstanceType)
  key_name Fn::ref(:KeyName)

    
  network_interfaces [ 
    {
      AssociatePublicIpAddress: "true",
      DeviceIndex: "0",
      GroupSet: [ Fn::ref(:instancesg) ],
      SubnetId: Fn::ref(:SubnetId)
    } 
  ]
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html#d0e33428
  block_device_mappings [
    {
      DeviceName: "/dev/sdb",
      Ebs: 
        {
          VolumeType: "io1",
          Iops: "200",
          DeleteOnTermination: "false",
          VolumeSize: "20"
        }
    }
    #,{
    #   DeviceName: "/dev/sdk",
    #   NoDevice: {}
    #}
  ]
end

output :instance, Fn::ref(:instance)

# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-ebs-volume.html

#resource :instancevol, "AWS::EC2::Volume" do
  # The size of the volume, in GiBs.
#  size "5"
#  availability_zone Fn::get_att( :instance, "AvailabilityZone" )
#  encrypted false
  # deletion_policy "Snapshot"
  # You can specify standard, io1, or gp2. If you set the type to io1, you must also set the Iops property
  #volume_type "io1"
  #iops 100
#end

#output :instancevol, Fn::ref(:instancevol)

# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-ebs-volumeattachment.html

#resource :instancevolattach, "AWS::EC2::VolumeAttachment" do
#   device  '/dev/sdb'
#   instance_id Fn::ref(:instance)
#   volume_id Fn::ref(:instancevol)
#end

#output :instancevolattach, Fn::ref(:instancevolattach)
