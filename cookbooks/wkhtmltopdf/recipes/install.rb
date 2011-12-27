wkhtmltopdf_file = "wkhtmltopdf-#{node[:wkhtmltopdf][:version]}-static-#{node[:wkhtmltopdf][:arch]}.tar.bz2"

remote_file "/tmp/#{wkhtmltopdf_file}" do
  source "http://wkhtmltopdf.googlecode.com/files/#{wkhtmltopdf_file}"
  owner 'root'
  group 'root'
  not_if do
    File.exist?(node[:wkhtmltopdf][:binary])
  end
end

execute "tar xfvj /tmp/#{wkhtmltopdf_file}" do
  cwd "/tmp"
  not_if do
    File.exist?(node[:wkhtmltopdf][:binary])
  end
end

execute "mv /tmp/wkhtmltopdf-#{node[:wkhtmltopdf][:arch]} #{node[:wkhtmltopdf][:binary]}" do
  creates node[:wkhtmltopdf][:binary]
end
