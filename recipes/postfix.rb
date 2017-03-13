#
# Cookbook Name:: cmamail
# Recipe:: postfix
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


template "#{node['cmamail']['postfix']['postfix_root']}/mysql-virtual_domains.cf" do
  source 'mysql-virtual_domains.cf.erb'
  mode '0640'
  group node['cmamail']['postfix']['group']
end

template "#{node['cmamail']['postfix']['postfix_root']}/mysql-virtual_forwardings.cf" do
  source 'mysql-virtual_forwardings.cf.erb'
  mode '0640'
  group node['cmamail']['postfix']['group']
end

template "#{node['cmamail']['postfix']['postfix_root']}/mysql-virtual_mailboxes.cf" do
  source 'mysql-virtual_mailboxes.cf.erb'
  mode '0640'
  mode '0640'
  group node['cmamail']['postfix']['group']
end

template "#{node['cmamail']['postfix']['postfix_root']}/mysql-virtual_email2email.cf" do
  source 'mysql-virtual_email2email.cf.erb'
  mode '0640'
  group node['cmamail']['postfix']['group']
end

group node['cmamail']['vmail']['group']

user node['cmamail']['vmail']['user'] do
  group node['cmamail']['vmail']['group']
  comment ' All virtual mailboxes will be stored under this user’s home director'
  home "/home/#{node['cmamail']['vmail']['user']}"
  uid 5000
  gid 5000
  system true
end

directory "/home/#{node['cmamail']['vmail']['user']}" do
  owner node['cmamail']['vmail']['user']
  group node['cmamail']['vmail']['group']
  mode '0755'
  action :create
end

template "#{node['cmamail']['postfix']['postfix_root']}/main.cf" do
  source 'main.cf.erb'
  # mode '0640'
  # group node['cmamail']['postfix']['group']
end

template "#{node['cmamail']['postfix']['postfix_root']}/master.cf" do
  source 'master.cf.erb'
  # mode '0640'
  # group node['cmamail']['postfix']['group']
end

service 'postfix' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Creation du repertoire qui contiendra toutes les clefs utiles pour la gestion des emails (postfix, dovecot...)
directory node['cmamail']['sslFolder'] do
  mode '0700'
  action :create
end

# Transfert de l'ensemble des clefs du databag mail_certificates dans le repertoire ssl par defaut du cookbook
secret_key = Chef::EncryptedDataBagItem.load_secret("#{Chef::Config[:encrypted_data_bag_secret]}")
enc_records = data_bag('mail_certificates')
enc_records.each do |private_key|
  enc_record = data_bag_item('mail_certificates', private_key,secret_key)
  file "#{node['cmamail']['sslFolder']}/#{enc_record['file_name']}" do
    mode '0644'
    content enc_record['private']
  end
end