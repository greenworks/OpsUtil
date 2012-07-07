#
# Created by JetBrains RubyMine.
# User: Simar Singh
# Date: 6/24/12
# Time: 8:40 PM
#

require 'net/http'
require 'net/ssh'
require 'rubygems'
require 'yaml'
require 'find'
require 'fileutils'
require_relative 'ssh'
#require_relative 'ssh_wrap'

#ssh = SSHWrap.new("c:\\myprojects\\nodes\\\lab-1-haatopia-node\\") do |session|

  @profile = YAML.load (File.read('profile.yml'));
  @default = YAML.load (File.read('default.yml'));
  @options = @default.merge(@profile)
  @ssh_opts = @options['ssh']
  @git_opts = @options['git']
  unless @ssh_opts['password'] || @ssh_opts['keyfile']
    puts "Please Enter SSH Password for User #{@ssh_opts['user']}"
    @ssh_opts['password'] = $stdin.readline.chomp
  end

  COMMAND = "cd /home/ssimar/test-git/; ls; pwd; git push origin master";

  Ssh.start( @ssh_opts['host'], @ssh_opts['user'], :port => 2200, :password=>@ssh_opts['password'],
                        :keys => [],
                        :config => false, :paranoid => false,
                        :global_known_hosts_file => ["#{@ssh_opts['knownhost']}"],
                        :user_known_hosts_file => ["#{@ssh_opts['knownhost']}"]) do |ssh|

  ssh.open_channel do |channel|
     channel.on_request "exit-status" do |channel, data|
        $exit_status = data.read_long
     end
     channel.on_data do |channel, data|
        puts data.inspect
        if data.inspect.include? "password"
                channel.send_data($stdin.readline);
        end
     end
     channel.request_pty
     # This will just safely fail if we have already a password prompt on
     channel.exec(COMMAND);
     channel.wait
     # Will reflect a valid status in both cases
     puts $exit_status
  end
end

