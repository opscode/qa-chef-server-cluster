#
# Cookbook Name:: qa-chef-server-cluster
# Libraries:: helpers
#
# Author: Patrick Wright <patrick@chef.io>
# Copyright (C) 2015, Chef Software, Inc. <legal@getchef.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def install_chef_server_core(package_version: node['qa-chef-server-cluster']['chef-server-core']['version'],
      integration_builds: node['qa-chef-server-cluster']['chef-server-core']['integration_builds'],
      repo: node['qa-chef-server-cluster']['chef-server-core']['repo'])
  if should_install?('chef-server-core')
    install_package('chef-server', package_version, integration_builds, repo)
  else
    Chef::Log.info('Skipping chef-server-core install')
  end
end

def install_opscode_manage(package_version: node['qa-chef-server-cluster']['opscode-manage']['version'],
      integration_builds: node['qa-chef-server-cluster']['opscode-manage']['integration_builds'],
      repo: node['qa-chef-server-cluster']['opscode-manage']['repo'])
  if should_install?('opscode-manage')
    install_package('opscode-manage', package_version, integration_builds, repo)

    chef_server_ingredient 'opscode-manage' do
      action :reconfigure
    end
  else
    Chef::Log.info('Skipping opscode-manage install')
  end
end

def install_chef_ha(package_version: node['qa-chef-server-cluster']['chef-ha']['version'],
      integration_builds: node['qa-chef-server-cluster']['chef-ha']['integration_builds'],
      repo: node['qa-chef-server-cluster']['chef-ha']['repo'])
  if should_install?('chef-ha')
    install_package('chef-ha', package_version, integration_builds, repo)
  else
    Chef::Log.info('Skipping chef-ha install')
  end
end

def install_package(package_name, package_version, integration_builds = nil, repo = nil)
  if install_from_source?(package_version)
    local_source = "#{::File.join(Chef::Config.file_cache_path, ::File.basename(package_version))}"
    remote_file local_source do
      source package_version
    end

    package package_name do
      source local_source
      provider value_for_platform_family(:debian => Chef::Provider::Package::Dpkg)
    end
  else
    omnibus_artifact package_name do
      version package_version
      integration_builds integration_builds
      repo repo
    end
  end
end

def install_from_source?(version)
  (version =~ /\A#{URI::regexp(['http', 'https'])}\z/) == 0 ? true : false
end

def run_chef_server_upgrade_procedure
  if should_install?('chef-server-core')
    execute 'stop services' do
      command 'chef-server-ctl stop'
    end

    install_chef_server_core

    execute 'upgrade server' do
      command 'chef-server-ctl upgrade'
    end

    execute 'start services' do
      command 'chef-server-ctl start'
    end
  else
    Chef::Log.info('Skipping chef-server-core upgrade')
  end
end

def check_backend_ha_status(expected_status)
  ruby_block "is #{expected_status} backend?" do
    block do
      current_cluster_status = Mixlib::ShellOut.new("cat /var/opt/opscode/keepalived/current_cluster_status")
      current_cluster_status.run_command
      server_status = current_cluster_status.stdout.strip!
      if server_status != expected_status
        raise "Expected cluster status '#{expected_status}', but got actual status '#{server_status}'"
      else
        Chef::Log.info "backend has taken over as #{expected_status}!"
      end
    end
    # retry every 15 secs for 10 mins
    retries 4 * 10
    retry_delay 15
  end
end

def should_install?(package)
  node['qa-chef-server-cluster'][package]['skip'] == false ? true : false
end
