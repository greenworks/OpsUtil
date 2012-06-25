
#
# Created by JetBrains RubyMine.
# User: Simar Singh
# Date: 5/21/12
# Time: 3:14 PM
#
require 'net/http'
require 'net/ssh'
require 'rubygems'
require 'yaml'
require 'aws-sdk'
require 'find'
require 'fileutils'
require_relative 'ssh'

class SSHWrap
  def initialize(node_path, &block)
    @node_path = node_path
    @node_config = YAML.load (File.read(File.join(node_path,'config.yml')));
    @node_key_path = File.join(node_path, Dir.open(node_path).detect { |file| file =~ /pem$/ })
   # @session = Net::SSH.start(@node_config['host'], "ubuntu",
    #               :keys => [@node_key_path] , :config => false, :paranoid => false ,
     #              :global_known_hosts_file => ['C:\Users\ssimar\.ssh\known_hosts'],
      #             :user_known_hosts_file => ['C:\Users\ssimar\.ssh\known_hosts'])
    @session = Ssh::start(@node_config['host'], "ubuntu", :keys => [@node_key_path], &block)
  end

  def session
    @session
  end

end

ssh = SSHWrap.new("c:\\myprojects\\nodes\\\lab-1-haatopia-node\\").session
ssh.exec!("find /media/. -name 'configuration.php' -exec  grep -ln '$db' '{}' \\;") do |channel, stream, data|
          puts data if stream == :stdout
        end
