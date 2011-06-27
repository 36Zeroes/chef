rvm_gem "unicorn" do
  ruby_string node['unicorn']['ruby_string']
  version node[:unicorn][:version]
end

cookbook_file "/usr/local/bin/unicornctl" do
  mode 0755
end
