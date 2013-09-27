require 'rubygems'
require 'aws-sdk'
require 'colorize'
# require 'choice'

# PROGRAM_VERSION = 0.1

# Choice.options do
#   option :help do
#     long '--help'
#     desc 'Show this message'
#   end

#   option :version do
#     short '-v'
#     long '--version'
#     desc 'Show version'
#     action do
#       puts "raws v#{PROGRAM_VERSION}"
#       exit
#     end
#   end
# end

access_key_id = ENV['AWS_ACCESS_KEY_ID']
secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

AWS.config(
  access_key_id: access_key_id,
  secret_access_key: secret_access_key,
  region: 'us-east-1'
)

ec2 = AWS::EC2.new()
puts ec2.instances.map{ |i|
  [
    i.instance_id.to_s.blue,
    i.status,
    i.ip_address,
    i.dns_name,
    i.image_id
  ]
}.join("\t")
