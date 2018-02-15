#!/usr/bin/env ruby

require 'aws-sdk'

def inspec_attributes_file_for(profile, fqdn)
  File.join("project/#{[profile, fqdn].join('-')}.yml")
end

# Iterate through the given profiles and fqdns to get a list of inspec commands
def inspec_commands_for(profiles, fqdns, opts = {})
  commands = []

  Array(fqdns).each do |fqdn|
    Array(profiles).each do |profile|
      File.write(inspec_attributes_file_for(profile, fqdn), "target_host: #{fqdn}\n")
      commands << inspec_command(profile, fqdn, opts)
    end
  end

  commands
end

# Given a profile name and a fqdn, return the inspec exec command
def inspec_command(profile, fqdn, opts = {})
  sudo = opts.fetch(:sudo, false)
  user = opts.fetch(:user, 'ubuntu')

  inspec_command = []

  inspec_command << 'inspec'
  inspec_command << "exec project/inspec/#{profile}"
  inspec_command << '--sudo' if sudo
  inspec_command << "--target ssh://#{user}@#{fqdn}"
  inspec_command << "-i ~/.ssh/#{ENV['INSPEC_SSH_KEY']}"
  inspec_command << "--attrs #{inspec_attributes_file_for(profile, fqdn)}"
  inspec_command.join(' ')
end

ec2 = Aws::EC2::Client.new
response = ec2.describe_instances(filters: [
  { name: 'tag:X-Application', values: ENV['AWS_APPLICATION_TAGS'].split(/\s*,\s*/) },
  { name: 'tag:X-Environment', values: ENV['AWS_ENVIRONMENT_TAGS'].split(/\s*,\s*/) },
])

ips = response.reservations.map { |r| r.instances.map { |i| i.private_ip_address }}.flatten.compact.reject { |ip| ip.empty? }

inspec_commands = []
inspec_commands << inspec_commands_for(ENV['INSPEC_PROFILES'].split(/\s*,\s*/), ips)

File.write('project/parallel-commands', inspec_commands.flatten.uniq.join("\n") + "\n")
