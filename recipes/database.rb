#
# Cookbook Name:: cmamail
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# Configure the MySQL client.
mysql_client node['cmamail']['application_name'] do
  version node['cmamail']['database']['version']
  action :create
end

# Configure the MySQL service.
mysql_service node['cmamail']['application_name'] do
  initial_root_password node['cmamail']['database']['root_password']
  version node['cmamail']['database']['version']
  action [:create, :start]
end

# Install mysql-devel for ruby compilation
package 'mysql-devel' do
  action :install
end

# Install the mysql2 Ruby gem.
mysql2_chef_gem node['cmamail']['application_name'] do
  action :install
  client_version node['cmamail']['database']['version']
end


# Create the database instance.
mysql_database node['cmamail']['database']['dbname'] do
  connection(
      :host => node['cmamail']['database']['host'],
      :username => node['cmamail']['database']['root_username'],
      :password => node['cmamail']['database']['root_password']
  )
  action :create
end

# Add a database user.
mysql_database_user node['cmamail']['database']['admin_username'] do
  connection(
      :host => node['cmamail']['database']['host'],
      :username => node['cmamail']['database']['root_username'],
      :password => node['cmamail']['database']['root_password']
  )
  password node['cmamail']['database']['admin_password']
  database_name node['cmamail']['database']['dbname']
  host node['cmamail']['database']['host']
  action [:create, :grant]
end

# Ajout de la base postfixadmin
mysql_database node['cmamail']['database']['postfix']['dbname'] do
  connection(
      :host => node['cmamail']['database']['host'],
      :username => node['cmamail']['database']['root_username'],
      :password => node['cmamail']['database']['root_password']
  )
  action :create
end

# Ajout de l'utilisateur "postfix" et ajout des permissions
mysql_database_user node['cmamail']['database']['postfix']['user'] do
  connection(
      :host => node['cmamail']['database']['host'],
      :username => node['cmamail']['database']['root_username'],
      :password => node['cmamail']['database']['root_password']
  )
  password node['cmamail']['database']['postfix']['password']
  database_name node['cmamail']['database']['postfix']['dbname']
  host node['cmamail']['database']['host']
  action [:create, :grant]
end

# Create a path to the SQL file in the Chef cache.
create_tables_script_path = File.join(Chef::Config[:file_cache_path], 'create-tables.sql')

# Write the SQL script to the filesystem.
cookbook_file create_tables_script_path do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Seed the database with tables.
execute "initialize #{node['cmamail']['database']['dbname']} database" do
  command "mysql -h #{node['cmamail']['database']['host']} -u #{node['cmamail']['database']['admin_username']} -p#{node['cmamail']['database']['admin_password']} -D #{node['cmamail']['database']['dbname']} < #{create_tables_script_path}"
  not_if  "mysql -h #{node['cmamail']['database']['host']} -u #{node['cmamail']['database']['admin_username']} -p#{node['cmamail']['database']['admin_password']} -D #{node['cmamail']['database']['dbname']} -e 'describe transport;'"
end