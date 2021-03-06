#
# Cookbook Name:: build
# Recipe:: smoke_ha_upgrade_aws
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node.override['chef-server-acceptance']['identifier'] = 'ha-upgrade'

include_recipe 'build::smoke_general_prep'

include_recipe 'build::ha_prepare_machine_configs'

include_recipe 'build::smoke_ha'
