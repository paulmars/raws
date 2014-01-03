require 'rubygems'
require 'aws-sdk'
require 'colorize'
require 'awesome_print'
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

module PrettyDate
  def to_pretty
    a = (Time.now-self).to_i

    case a
      when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then a.to_s+' seconds ago'
      when 60..119 then 'a minute ago' #120 = 2 minutes
      when 120..3540 then (a/60).to_i.to_s+' minutes ago'
      when 3541..7100 then 'an hour ago' # 3600 = 1 hour
      when 7101..82800 then ((a+99)/3600).to_i.to_s+' hours ago'
      when 82801..172000 then 'a day ago' # 86400 = 1 day
      when 172001..518400 then ((a+800)/(60*60*24)).to_i.to_s+' days ago'
      when 518400..1036800 then 'a week ago'
      else ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
    end
  end
end

Time.send :include, PrettyDate

access_key_id = ENV['AWS_ACCESS_KEY_ID']
secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

AWS.config(
  access_key_id: access_key_id,
  secret_access_key: secret_access_key,
  region: 'us-east-1'
)

ec2 = AWS::EC2.new()
ec2.instances.map{ |i|
  info = [
    i.instance_id.to_s.blue,
    i.status,
    i.ip_address,
    i.dns_name,
    i.image_id,
    i.launch_time.to_pretty,
  ].join("\t")

  if i.dns_name
    sshline = "ssh -i ~/.ec2/#{i.key_name}.pem ec2-user@#{i.dns_name}"
  else
    sshline = ""
  end

  puts ["====", info, sshline].join("\n") + "\n"
}
