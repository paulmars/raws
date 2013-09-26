require 'rubygems'
require 'aws-sdk'

access_key_id = ENV['AWS_ACCESS_KEY_ID']
secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

AWS.config(
  access_key_id: access_key_id,
  secret_access_key: secret_access_key,
  region: 'us-east-1'
)

ec2 = AWS::EC2.new()
puts "instances",ec2.instances.inject({}) { |m, i| m[i.id] = i.status; m }
