#
# Cookbook Name:: cmarepo
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# Rajout du repo d'entreprise

yum_repository 'cmarepo' do
  description "CMA Stable repo"
  baseurl "#{node['repo']['repourl']}/centos/7/2/"
  proxy '_none_'
  gpgcheck false
  # gpgkey 'http://dev.zenoss.com/yum/RPM-GPG-KEY-zenoss'
  action :create
end