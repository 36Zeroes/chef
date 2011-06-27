rvm_gem "unicorn" do
  ruby_string node.unicorn.ruby_string
  version node[:unicorn][:version]
end


rvm_wrapper "boot" do # create /usr/local/rvm/bin/boot_unicorn
  ruby_string   node.unicorn.ruby_string
  binary        "unicorn"
end

cookbook_file "/usr/local/bin/unicornctl" do
  mode 0755
end
