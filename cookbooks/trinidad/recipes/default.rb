include_recipe "runit"
include_recipe 'rvm'
include_recipe 'java'

# Install jruby and trinidad
rvm_ruby node.trinidad.ruby_string #"jruby-1.6.2"
rvm_gem "trinidad" do
  ruby_string node.trinidad.ruby_string
end
rvm_wrapper "boot" do # create /usr/local/rvm/bin/boot_trinidad
  ruby_string   node.trinidad.ruby_string
  binary        "trinidad"
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

# Alternative: Use capstrap which SSH'es in, then configs server:
#  (1) sets the hostname/domainname for ohai to work properly, 
#  (2) installs min. packages required for RVM,      
#  (3) does an RVM system-wide install, 
#  (4) installs min packages for a ruby,                 <didnt do jruby... have to add)
#  (5) builds the ruby (ree by default), 
#  (6) installs the chef gem,                            <which won't work in jruby -- due to ohai... at least I guess so>
#  (7) optionally pulls down a chef repo for chef-solo, 
#  (8) optionally pulls down a chef-solo config, 
#  (9) optionally executes chef-solo

