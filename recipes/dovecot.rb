#
# Cookbook Name:: cmamail
# Recipe:: postfix
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

group node['cmamail']['dovecot']['group']

template "#{node['cmamail']['dovecot']['dovecot_root']}/dovecot.conf" do
  source 'dovecot.conf.erb'
  mode '0640'
  group node['cmamail']['dovecot']['group']
  owner node['cmamail']['vmail']['user']
end

template "#{node['cmamail']['dovecot']['dovecot_root']}/conf.d/10-mail.conf" do
  source 'dovecot.10-mail.conf.erb'
  mode '0640'
  group node['cmamail']['dovecot']['group']
  owner node['cmamail']['vmail']['user']
end

template "#{node['cmamail']['dovecot']['dovecot_root']}/conf.d/10-auth.conf" do
  source 'dovecot.10-auth.conf.erb'
  mode '0640'
  group node['cmamail']['dovecot']['group']
  owner node['cmamail']['vmail']['user']
end

template "#{node['cmamail']['dovecot']['dovecot_root']}/conf.d/10-master.conf" do
  source 'dovecot.10-master.conf.erb'
  mode '0640'
  group node['cmamail']['dovecot']['group']
  owner node['cmamail']['vmail']['user']
end

template "#{node['cmamail']['dovecot']['dovecot_root']}/conf.d/10-ssl.conf" do
  source 'dovecot.10-ssl.conf.erb'
  mode '0640'
  group node['cmamail']['dovecot']['group']
  owner node['cmamail']['vmail']['user']
end

template "#{node['cmamail']['dovecot']['dovecot_root']}/conf.d/auth-sql.conf.ext" do
  source 'dovecot.auth-sql.conf.ext.erb'
  mode '0640'
  group node['cmamail']['dovecot']['group']
  owner node['cmamail']['vmail']['user']
end

template "#{node['cmamail']['dovecot']['dovecot_root']}/dovecot-sql.conf.ext" do
  source 'dovecot.dovecot-sql.conf.ext.erb'
  mode '0640'
  group node['cmamail']['dovecot']['group']
  owner node['cmamail']['vmail']['user']
end

service 'dovecot' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Creation du repertoire de decompression de l'archive postfixadmin
directory "/var/mail/vhosts/#{node['cmamail']['domain']}" do
  user node['cmamail']['vmail']['user']
  group node['cmamail']['vmail']['user']
  recursive true
  mode 0755
  action :create
end


directory "/home/dovecot/" do
  user node['cmamail']['vmail']['user']
  group node['cmamail']['vmail']['user']
  recursive true
  mode 0755
  action :create
end

directory "/home/dovecot/#{node['cmamail']['domain']}" do
  user node['cmamail']['vmail']['user']
  group node['cmamail']['vmail']['user']
  recursive true
  mode 0755
  action :create
end