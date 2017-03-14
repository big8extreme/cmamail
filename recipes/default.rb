#
# Cookbook Name:: cmamail
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'selinux::permissive'
include_recipe 'cmamail::hosts'
include_recipe 'cmamail::packages'
include_recipe 'cmamail::postfix'
include_recipe 'cmamail::dovecot'
include_recipe 'cmamail::firewall'
include_recipe 'cmamail::web_user'
include_recipe 'cmamail::postfixadmin'
# include_recipe 'cmamail::web'
include_recipe 'cmamail::database'
include_recipe 'cmamail::opendkim'
include_recipe 'cmamail::rainloop'