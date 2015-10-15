#################################################################
#
# File: lib/couldconnector.rb
#
#################################################################

# http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html

class CloudConnector
    # region

    def self.connect()
	ec2 = Aws::EC2::Client.new(region: 'us-west-1')
    end

    def self.create()
	# ami id
	
	@ec2   = Aws::Ec2.new(aws_access_key_id, aws_secret_access_key)

	# Create a new SSH key pair:

	@key   = 'right_ec2_awesome_test_key'
	new_key = @ec2.create_key_pair(@key)
	keys = @ec2.describe_key_pairs

	# Create a security group:

	@group = 'right_ec2_awesome_test_security_group'
	@ec2.create_security_group(@group,'My awesome test group')
	group = @ec2.describe_security_groups([@group])[0]

	# Configure a security group:

	@ec2.authorize_security_group_named_ingress(@group, account_number, 'default')
	@ec2.authorize_security_group_IP_ingress(@group, 80,80,'udp','192.168.1.0/8')

	# Describe the available images:

	images = @ec2.describe_images
	
	# Launch an instance:

	ec2.run_instances('ami-9a9e7bf3', 1, 1, ['default'], @key, 'SomeImportantUserData', 'public')
	
	# Describe running instances:

	@ec2.describe_instances

	
    end
end

