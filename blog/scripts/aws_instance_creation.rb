puts "inside ruby program"
puts ENV['TRAVIS_BRANCH']
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'base64'

class AwsInstanceCreation

  def initialize
    Aws.config.update({region: 'us-east-1',credentials: Aws::Credentials.new("#{ENV['AWS_ACCESS_KEY']}", "#{ENV['AWS_SECRET_ACCESS_KEY']}")})
    @ec2 = Aws::EC2::Resource.new(region: 'us-east-1')
  end

  def get_existing_instances_list
    list = []
    # Get all instances with tag key 'Group'
    # and tag value 'MyGroovyGroup':
    @ec2.instances({filters: [{name: 'tag:developers-group'}]}).each do |i|
      puts 'ID:    ' + i.id
      puts 'State: ' + i.state.name
      list << i.state.name
    end
    puts list.inspect
    list
  end

  def is_this_instance_available?(given_instance)
  end

  def create_instance
    # User code that's executed when the instance starts
    script = ''
    encoded_script = Base64.encode64(script)

    instance = @ec2.create_instances({
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
    @ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance.first.id]})

    # Name the instance 'MyGroovyInstance' and give it the Group tag 'MyGroovyGroup'
    instance.first.create_tags({ tags: [{ key: 'developers-group', value: "#{ENV['TRAVIS_BRANCH']}"}]})

    puts instance.first.id
    puts instance.first.public_ip_address    
  end


end

infra = AwsInstanceCreation.new
if infra.get_existing_instances_list.include?("#{ENV['TRAVIS_BRANCH']}")

else
  infra.create_instance
end  