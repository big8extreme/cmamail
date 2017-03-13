#
# Cookbook Name:: cmamail
# Recipe:: web_user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

node['cmamail']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end