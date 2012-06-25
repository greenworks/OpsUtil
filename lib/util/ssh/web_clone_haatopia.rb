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
#require_relative 'ssh'
#require_relative 'ssh_wrap'

#ssh = SSHWrap.new("c:\\myprojects\\nodes\\\lab-1-haatopia-node\\") do |session|
  Net::SSH.start( '192.168.2.20', 'nandus', :port => 2200, :password=>'nandus',
                        :keys => [],
                        :config => false, :paranoid => false,
                        :global_known_hosts_file => ['C:\Users\nandus\.ssh\known_hosts'],
                        :user_known_hosts_file => ['C:\Users\nandus\.ssh\known_hosts']) do |ssh|
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
     channel.exec("cd /home/nandus/test-git/; ls; pwd; git push origin master");
     channel.wait
     # Will reflect a valid status in both cases
     puts $exit_status
  end
end

