#
# Cookbook Name:: s3cmd
# Recipe:: default
#

#install s3cmd

apt_repository "s3cmd" do
  uri "http://s3tools.org/repo/deb-all"
  components ["stable/"]
  key "http://s3tools.org/repo/deb-all/stable/s3tools.key"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

execute "apt-get update" do
  action :nothing
end

package "s3cmd" do 
  action :upgrade
end

#deploy configuration for each user. Change s3cfg.erb template in your site cookbook to set 
#you access key and secret. 
node[:s3cmd][:users].each do |user| 
  
  home = user == :root ? "/root" : "/home/#{user}"
  
  template "s3cfg" do
      path "#{home}/.s3cfg"
      mode "0600"
      owner user
      group user
      source "s3cfg.erb"
      action :create_if_missing
  end  
end

template "/usr/local/sbin/s3cmd_tasks.sh" do
  source "s3cmd_tasks.sh.erb"
  mode "0700"
  owner "root"
  group "root"
  action :create_if_missing
end

cron "s3cmd_tasks" do
  hour "1"
  minute "16"
  command "/usr/local/sbin/s3cmd_tasks.sh"
end