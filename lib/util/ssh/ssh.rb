#
# Created by JetBrains RubyMine.
# User: Simar Singh
# Date: 5/22/12
# Time: 1:44 AM
#

require 'net/ssh'

class Ssh

  def start(host, user, options={}, &block)
    Ssh.start(host, user, options={}, &block)
  end

  def default_options
    Ssh.default_options
  end

  def self.start(host, user, options={}, &block)
    @@SSH_CONFIG.each_key {|k| options[k] = @@SSH_CONFIG[k] unless options.has_key?(k)}
    Net::SSH.start(host, user, options, &block)
  end

  def self.default_options=(options={})
    @@SSH_CONFIG = options
  end

  def self.default_options
    @@SSH_CONFIG
  end

  @@SSH_CONFIG =
    {
        :config => false, :paranoid => false,
        :global_known_hosts_file => [File.join(File.join(Dir.home, '.ssh'), 'known_hosts')],
        :user_known_hosts_file => [File.join(File.join(Dir.home, '.ssh'), 'known_hosts')]
    }


end