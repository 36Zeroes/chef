include_recipe "runit"
include_recipe 'java'

rvm_gem "trinidad" do
  ruby_string node['trinidad']['ruby_string']
  action :install
end

directory "/etc/trinidad" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/trinidad/config.yaml" do
  source 'config.yaml.erb'
  owner "root"
  group "root"
  mode 0644
end

runit_service "trinidad"
