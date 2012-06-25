
module SshUtil
  class << self
      attr_accessor  :ssh_default_options
    end
    attr_accessor  :ssh_default_options

    def ssh_start(host, user, options={}, &block)
      ssh_default_options.each_key {|k| options[k] = ssh_default_options[k] unless options.has_key?(k)}
      Net::SSH.start(host, user, options, &block)
    end

    def ssh_default_options
       Ssh.ssh_default_options
    end

    SshUtil.ssh_default_options =
    {
          :config => false, :paranoid => false, :keys =>[],
          :global_known_hosts_file => [File.join(File.join(Dir.home, '.ssh'), 'known_hosts')],
          :user_known_hosts_file => [File.join(File.join(Dir.home, '.ssh'), 'known_hosts')]
    }
  end