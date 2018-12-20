require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'base64'
Aws.config.update({
region: 'us-east-1',
credentials: Aws::Credentials.new('AKIAIS4NO65DF5KXCAXA', 'ivEn+MKOcqVLjRMd4MWm/lhYS20DyharT3Y2ZKyc')
})
# User code that's executed when the instance starts
script = ''

encoded_script = Base64.encode64(script)

ec2 = Aws::EC2::Resource.new(region: 'us-east-1')

instance = ec2.create_instances({
  image_id: 'ami-0923a19057859a3d0',
  min_count: 1,
  max_count: 1,
  key_name: 'mdn-mysql-own',
  security_group_ids: ['sg-19ef5951'],
  user_data: encoded_script,
  instance_type: 't2.micro',
  placement: {
    availability_zone: 'us-east-1a'
  },
  subnet_id: 'subnet-c00ecea7'
})

# Wait for the instance to be created, running, and passed status checks
ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance.first.id]})

# Name the instance 'MyGroovyInstance' and give it the Group tag 'MyGroovyGroup'
instance.first.create_tags({ tags: [{ key: 'Name', value: "auto-instance-#{Time.now}" }]})

puts instance.first.id
puts instance.first.public_ip_address
