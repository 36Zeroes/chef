counter = 0

node[:active_applications].each do |name, config|
  app_root = "/var/www/#{name}"
  defaults = Mash.new({
    :pid_path => "#{app_root}/shared/pids/unicorn.pid",
    :worker_count => node[:unicorn][:worker_count],
    :timeout => node[:unicorn][:timeout],
    :socket_path => "/tmp/unicorn/#{name}.sock",
    :backlog_limit => 1,
    :master_bind_address => '0.0.0.0',
    :master_bind_port => "36#{counter}00",
    :worker_listeners => true,
    :worker_bind_address => '127.0.0.1',
    :worker_bind_base_port => "37#{counter}01",
    :debug => false,
    :binary_path => "#{node.rvm.root_path}/bin/boot_unicorn",
    :env => 'production',
    :app_root => app_root,
    :enable => true,
    :config_path => "#{app_root}/current/config/unicorn.conf.rb",
    :use_bundler => false
  })
  
  config_with_defaults = defaults.merge(config)
  runit_service "unicorn-#{name}" do
    template_name "unicorn"
    cookbook "unicorn"
    options config_with_defaults
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
