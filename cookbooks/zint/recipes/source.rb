#
# Cookbook Name:: zint
# Recipe:: source
#
# Author:: Anuj Luthra (<anuj@36zeroes.com.au>)
#
# Copyright 2009-2011, 36 Zeroes Pty. Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

packages = value_for_platform(
    ["ubuntu", "debian"] => {'default' => ['libpng12-dev', 'g++', 'cmake', 'libqt4-dev']}
  )

packages.each do |devpkg|
  package devpkg
end

zint_version = node[:zint][:version]
zint_source_location = node[:zint][:location]


remote_file "/tmp/zint-#{zint_version}.src.tar.gz" do
  source zint_source_location
  action :create_if_missing
end

bash "compile_zint_source" do
  cwd "/tmp"
  code <<-EOH
    tar zxf zint-#{zint_version}.tar.gz
    cd zint-#{zint_version} && cmake .
    make install
  EOH
  creates node[:zint][:src_binary]
end

