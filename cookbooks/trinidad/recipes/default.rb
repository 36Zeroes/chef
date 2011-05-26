include_recipe "runit"
include_recipe 'java'

gem_package "trinidad" do
  action :install
end

template "/etc/trinidad/config.yaml" do
  source 'config.yml'
  owner "root"
  group "root"
  mode 0644
end

runit_service "trinidad"
