include_recipe "ruby"
include_recipe "runit"
include_recipe 'java'

gem_package "trinidad" do
  action :install
end

directory "/etc/trinidad/config.yaml" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

runit_service "trinidad"
