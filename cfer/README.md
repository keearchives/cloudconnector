Configure the ec2-keypair

```aws configure```


Workflow to tnw.deploy(stack) where stack=tnw-baseline

```cfer converge tnw-baseline --profile default --region us-west-2 --parameters KeyName:id-rsa.pub```

```aws cloudformation delete-stack --stack-name tnw-baseline```

Use -t to locate the ruby source file

```cfer converge tnw-baseline -t tnw-baseline.rb --profile default --region us-west-2 --parameters KeyName:id-rsa.pub```

Export to native  AWS CloudFormation json format

```cfer generate tnw-baseline.rb --profile default --region us-west-2 --parameters KeyName:id-rsa.pub```

create  all
```
cfer converge tnw-vpc 		--profile default --region us-west-2 --parameters KeyName:id-rsa.pub
cfer converge tnw-conductor 	--profile default --region us-west-2 --parameters KeyName:id-rsa.pub
cfer converge tnw-hipswitch 	--profile default --region us-west-2 --parameters KeyName:id-rsa.pub
cfer converge tnw-ln 		--profile default --region us-west-2 --parameters KeyName:id-rsa.pub
cfer converge tnw-splunk 	--profile default --region us-west-2 --parameters KeyName:id-rsa.pub
cfer converge tnw-baseline 	--profile default --region us-west-2 --parameters KeyName:id-rsa.pub
```

delete all
```
aws cloudformation delete-stack --stack-name tnw-baseline
aws cloudformation delete-stack --stack-name tnw-splunk
aws cloudformation delete-stack --stack-name tnw-ln
aws cloudformation delete-stack --stack-name tnw-hipstack
aws cloudformation delete-stack --stack-name tnw-conductor
aws cloudformation delete-stack --stack-name tnw-vpc
```
