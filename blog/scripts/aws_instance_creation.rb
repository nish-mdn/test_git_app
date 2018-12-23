puts "inside ruby program"
puts ENV['TRAVIS_BRANCH']
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'base64'

class AwsInstanceCreation

  def initialize
    Aws.config.update({region: 'us-east-1',credentials: Aws::Credentials.new("#{ENV['AWS_ACCESS_KEY']}", "#{ENV['AWS_SECRET_ACCESS_KEY']}")})
    @ec2 = Aws::EC2::Resource.new(region: 'us-east-1')
    @list = {}
  end

  def get_existing_instances_list
    
    # Get all instances with tag key 'Group'
    # and tag value 'MyGroovyGroup':
    @ec2.instances.each do |instance|
      #list <<  i.tags.select{|tag| tag.key == "developers-group"}.first.try(:value)
      puts "instance public ip address #{instance.public_ip_address}"
      tags = instance.tags
      tags.each do |tag|
        if tag.key == "developers-group"
          @list[tag.value] = {ins_status: instance.state.name,pub_address: instance.public_ip_address }
        end  
      end
    end
    @list
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

    instance.first.create_tags({ tags: [{ key: 'developers-group', value: "#{ENV['TRAVIS_BRANCH']}"}]})

    puts instance.first.id
    i = @ec2.instance("#{instance.first.id}") 
    @list["#{ENV['TRAVIS_BRANCH']}"] = {ins_status: i.state.name,pub_address: i.public_ip_address }
    @list
  end

  def get_instance_ip
    puts "get_instance_ip inspect #{@list}"
    @list["#{ENV['TRAVIS_BRANCH']}"][:pub_address]
  end


end

infra = AwsInstanceCreation.new
existing_list = infra.get_existing_instances_list
if !existing_list.nil? && existing_list.keys.include?("#{ENV['TRAVIS_BRANCH']}")
  puts "existing_list #{existing_list.inspect}"
  public_ip_address = existing_list["#{ENV['TRAVIS_BRANCH']}"][:pub_address]
  puts "for #{ENV['TRAVIS_BRANCH']} branch instance available already and IP address of the instance is #{public_ip_address}"  
  infra.create_instance if existing_list["#{ENV['TRAVIS_BRANCH']}"][:ins_status] != "running"
else
  puts "Going to create a new instance for a branch #{ENV['TRAVIS_BRANCH']}"
  infra.create_instance
end
ip_address_for_target_machine = infra.get_instance_ip
puts "infra ip #{ip_address_for_target_machine}"
system("chmod +x deploy.sh")
system("./deploy.sh '#{ip_address_for_target_machine}' ")
