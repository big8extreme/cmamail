#
# Cookbook Name:: cmamail
# Recipe:: web_user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
group node['cmamail']['group']

user node['cmamail']['user'] do
  group node['cmamail']['group']
  system true
  shell '/bin/bash'
end