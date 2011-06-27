include_recipe "runit"
include_recipe 'rvm'

counter = 0

node[:active_applications].each do |name, config|
  app_root = "/var/www/#{name}"
  defaults = Mash.new({
    :debug => false,
    
    # Use bundler to handle gem dependencies
    :binary_path => "#{node.rvm.root_path}/bin/do_bundle exec unicorn_rails",
    
    :env => 'production',
    :app_root => app_root,
    :enable => true,
    :config_path => "#{app_root}/current/config/unicorn.conf.rb",

    :run_as => "capistrano:capistrano"
  })
  
  
  config_with_defaults = defaults.merge(config)
  runit_service "unicorn-#{name}" do
    template_name "unicorn"
    cookbook "unicorn"
    options config_with_defaults
  end
  
  
  logrotate_app "#{name}" do
    cookbook "logrotate"
    path "#{app_root}/current/log/*.log"
    frequency "daily"
    rotate 30
  end
  
  
# ODDITY: #runit_service will call #service but override core parts...
#   -- it'll use default provider (not your OS one)
#   -- it'll re-define start/stop and related using runsv's 'sv' cmd
#   -- it'll subscribe to changes of './run' with a restart
#   
#  => The problem is that after that, using #service for the same name
#     will not use OS provider either, so no :enable is defined 
#     
#  => Which in turnmeans we can't enable at boot...
#     
#  service "unicorn-#{name}" do
#    action config_with_defaults[:enable] ? [:enable, :start] : [:disable, :stop]
#  end

  counter += 1
end
