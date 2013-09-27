require 'rubygems'
require 'aws-sdk'
require 'clint'

c = Clint.new
c.usage do
  $stderr.puts "Usage: raws [-h|--help]"
end
c.help do
  $stderr.puts "  -h, --help\tshow this help message"
end
c.options :help => false, :h => :help
c.parse ARGV
if c.options[:help]
  c.help
  exit 1
end

access_key_id = ENV['AWS_ACCESS_KEY_ID']
secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

AWS.config(
  access_key_id: access_key_id,
  secret_access_key: secret_access_key,
  region: 'us-east-1'
)

ec2 = AWS::EC2.new()
puts ec2.instances.inject({}) { |m, i| m[i.id] = i.status; m }
