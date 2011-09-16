# Assumed already installed resque as part of your app!

# Wrap bundler
rvm_wrapper "do" do
  ruby_string node.unicorn.ruby_string
  binary "bundle"
end

# THis is as used by unicorn.... need to pull together in a "ResTracker" recipe better...
node[:active_applications].each do |name, config|
  next unless config["resque_workers"]  # TODO: enhance to hold queue & priorities...

  # Setup defaults...
  app_root = "/var/www/#{name}"
  defaults = Mash.new({
      # Use bundler to handle gem dependencies
      :bundler_path => "#{node.rvm.root_path}/bin/do_bundle",    
      :app_root => app_root,
      :run_as => "capistrano:capistrano",    
      :env => {
        "RAILS_ENV" => 'production',
        "QUEUE"     => '*'
      }
    }
  )

  # Runit
  config_with_defaults = defaults.merge(config)
  runit_service "resque-#{name}" do
    template_name "resque"
    cookbook "resque_worker"
    options config_with_defaults
  end
end
