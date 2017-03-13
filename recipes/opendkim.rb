#
# Cookbook Name:: cmamail
# Recipe:: opendkim
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

template "/etc/opendkim.conf" do
  source 'opendkim.opendkim.conf.erb'
  # mode '0640'
  # group node['cmamail']['postfix']['group']
end

# Create the opendkim socket folder to communicate with postfix.
directory node['cmamail']['opendkim']['socketfolder'] do
  recursive true
  user "opendkim"
end

# Rajout de postfix dans le groupe opendkim
group "opendkim" do
  action :modify
  members "postfix"
  append true
end

# Adding the opendkim key folder
directory "/etc/opendkim/keys/#{node['cmamail']['domain']}" do
  recursive true
end

# Adding the trusted hosts
template '/etc/opendkim/TrustedHosts' do
  source 'opendkim.TrustedHosts.erb'
  mode '0644'
  # group node['cmamail']['postfix']['group']
end

# Adding the Key Table
template '/etc/opendkim/KeyTable' do
  source 'opendkim.KeyTable.erb'
  mode '0644'
  # group node['cmamail']['postfix']['group']
end

# Adding the Key Table
template '/etc/opendkim/SigningTable' do
  source 'opendkim.SigningTable.erb'
  mode '0644'
  # group node['cmamail']['postfix']['group']
end

# TODO a deplancer dans un databag encrypte
template "/etc/opendkim/keys/#{node['cmamail']['domain']}/mail.txt" do
  source 'opendkim.mail.txt.erb'
  mode '0600'
  user 'root'
  # group node['cmamail']['postfix']['group']
end


# Transfert de l'ensemble des clefs du databag mail_certificates dans le repertoire ssl par defaut du cookbook
secret_key = Chef::EncryptedDataBagItem.load_secret("#{Chef::Config[:encrypted_data_bag_secret]}")
enc_records = data_bag('mail_certificates')
enc_records.each do |private_key|
  enc_record = data_bag_item('mail_certificates', private_key,secret_key)
  if enc_record['id']=='opendkimkey'
    file "/etc/opendkim/keys/#{node['cmamail']['domain']}/#{enc_record['file_name']}" do
      mode '0600'
      user 'opendkim'
      content enc_record['private']
    end
  end
end