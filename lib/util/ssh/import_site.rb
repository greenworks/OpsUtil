require 'net/http'
require 'net/ssh'
require 'rubygems'
require 'yaml'
require 'find'
require 'fileutils'

class ImportSite
  def initialize(config=nil)
    config = YAML.load(File.read('nodes\lab-1-haatopia-node\config.yml')) unless config
    puts config.kind_of?(Hash)
    puts config
    puts OpenSSL::PKey::RSA.new(File.read('nodes\lab-1-haatopia-node\lab1-haatopia.pem'))
  end

  def connect
    #pem_key_data = OpenSSL::PKey::RSA.new(File.read('keys\lab1-haatopia.pem'))
    dirs = Dir.open('nodes')
    dirs = dirs.select { |path|  (path =~ /lab.*node$/)  }
    dirs.each do |node|
        node_path = File.join('nodes',node);
        node_config = YAML.load (File.read(File.join(node_path,'config.yml')));
        node_key_path = File.join(node_path, Dir.open(node_path).detect { |file| file =~ /pem$/ })
        puts node_path
        puts node_config
        puts node_key_path
        Net::SSH.start(node_config['host'], "ubuntu",
                   :keys => [node_key_path] , :config => false, :paranoid => false,
                   :global_known_hosts_file => ['C:\Users\ssimar\.ssh\known_hosts'],
                   :user_known_hosts_file => ['C:\Users\ssimar\.ssh\known_hosts']) do |ssh|
        puts "Running 'uname -a' on the instance yields:"
        puts ssh.exec!("uname -a")
        stdout = ""
        ssh.exec!("find /media/. -name 'configuration.php' -exec  grep -ln '$db' '{}' \\;") do |channel, stream, data|
          puts data if stream == :stdout
        end
        #puts stdout
        #puts ssh.exec!("mysqldump --user=root --password=Dhillon60 --opt laserspot_ht")
      end
    end

  end
end

ImportSite.new.connect();
