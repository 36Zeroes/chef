#
# Cookbook Name:: s3cmd
# Recipe:: default
#

#install s3cmd

apt_repo "s3tools" do
  url "http://s3tools.org/repo/deb-all"
  distribution ""
  components ["stable/"]
  key_id  "C762B6E6"
  key_url "http://s3tools.org/repo/deb-all/stable/s3tools.key"
  key_package "s3cmd"
  notifies :run, "execute[apt-get update]", :immediately
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