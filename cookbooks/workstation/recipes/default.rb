#
# Cookbook Name:: workstation
# Recipe:: default
#
# Copyright 2010-2012, Joshua Timberman
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

begin
  wk = data_bag_item("apps","workstation")
  u  = data_bag_item("users", "user")
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("#{cookbook_name} could not load data bag; #{e}")
end

case node['platform']
when "mac_os_x"
  wk['dmgs'].each do |pkg, data|
    dmg_package pkg do
      app data['app'] if data.has_key?('app')
      volumes_dir data['volumes_dir'] if data.has_key?('volumes_dir')
      dmg_name data['dmg_name'] if data.has_key?('dmg_name')
      destination data['destination'] if data.has_key?('destination')
      type data['type'] if data.has_key?('type')
      package_id data['package_id'] if data.has_key?('package_id')
      source data['url']
      checksum data['checksum']
    end
  end

  include_recipe "homebrew::default"

  wk['dirs'].each do |dir|
    directory "#{dir}" do
      owner ENV['USER']
      group "staff"
      mode "0755"
      recursive true
    end
  end

  wk['brew_repos'].each do |brew_repo|
    homebrew_tap brew_repo do
      action :tap
    end
  end

  wk['brew_packages'].each do |brew_pkg|
    package brew_pkg do
      action :install
      provider Chef::Provider::Package::Homebrew
    end
  end

  end
  wk['cask_packages'].each do |cask_pkg|
    homebrew_cask "#{cask_pkg}" do
      options ["--appdir=\"/Applications\""]
      action :cask      
    end
  end

  wk['plists'].each do |plist|
    mac_os_x_plist_file plist
  end

  if u.has_key?("repos")
    directory node['workstation']['workspace'] do
      owner ENV['USER']
      group "staff"
      mode "0755"
      action :create
    end
    
    node.override['ssh_known_hosts']['file'] = "#{ENV['HOME']}/.ssh/known_hosts"
    include_recipe "ssh_known_hosts"
    ssh_known_hosts_entry 'bitbucket.org'
    ssh_known_hosts_entry 'github.com'

    u["repos"].each do |target, repo|
      git "#{node['workstation']['workspace']}/#{target}" do
        repository repo['repo']
        reference repo['revision']
        action :sync
        user ENV['USER']
      end
    end
  end
end
