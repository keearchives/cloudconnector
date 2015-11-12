#!/usr/bin/ruby

require 'rubygems'
require 'yaml'
require 'fog'

iam = Fog::AWS::IAM.new
iam.create_instance_profile('app_server')
iam.create_role('app_server', Fog::AWS::IAM::EC2_ASSUME_ROLE_POLICY)

iam.put_role_policy('app_server', 's3_access',   'Version' => '2008-10-17',
                    'Statement' => [
                    {
                       'Effect' => 'Allow',
                       'Action' => ['s3:*'],
                       'Resource' => ['arn:aws:s3:::somebucket/*']
                    }
                 ])

# This you’d run somewhere where you have existing credentials (I’ve assumed they’re in your .fog file).
# Obviously you could restrict that policy further, for example code that makes backups to s3 might
# have the right to put files in an s3 bucket but not to delete existing files.

# Once you’ve created a profile, you can start instances that use it. With fog you’d do

compute = Fog::Compute::AWS.new
compute.servers.create( 
			:flavor_id => 't1.micro', 
			:image_id => 'ami-ed65ba84',
                        :iam_instance_profile_name => 'app_server'
		      )

# To launch an amazon linux t1.micro instance using that iam profile.
# You can’t currently add a profile to an instance once it has been started
# although you can change the policies associated with the profile as much as
# you want. In your app code, rather than providing a full set of credentials just do

Fog::Storage::AWS.new :use_iam_profile => true
