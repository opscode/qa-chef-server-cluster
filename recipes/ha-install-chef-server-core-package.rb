#
# Cookbook Name:: qa-chef-server-cluster
# Recipes:: chef-server-core-upgrade-package
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

# called during ha upgrade orchestration
chef_package current_server.package_name do
  package_url node['qa-chef-server-cluster']['chef-server']['url']
  version node['qa-chef-server-cluster']['chef-server']['version']
  channel node['qa-chef-server-cluster']['chef-server']['channel']
end
