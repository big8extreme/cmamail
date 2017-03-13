#
# Cookbook Name:: cmamail
# Recipe:: aliases
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# include_recipe 'postfix::_common'

execute 'update-postfix-aliases' do
  command 'newaliases'
  environment PATH: "#{ENV['PATH']}:/opt/omni/bin:/opt/omni/sbin" if platform_family?('omnios')
  # On FreeBSD, /usr/sbin/newaliases is the sendmail command, and it's in the path before postfix's /usr/local/bin/newaliases
  environment ({ 'PATH' => "/usr/local/bin:#{ENV['PATH']}" }) if platform_family?('freebsd') # rubocop: disable Lint/ParenthesesAsGroupedExpression
  action :nothing
end

template node['cmamail']['postfix']['aliases_db'] do
  source 'aliases.erb'
  notifies :run, 'execute[update-postfix-aliases]'
end