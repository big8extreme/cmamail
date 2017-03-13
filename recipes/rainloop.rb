# Install Apache and start the service.
httpd_service 'rainloop' do
  mpm 'prefork'
  listen_ports [node['cmamail']['rainloop']['port']]
  action [:create, :start]
end

# Add the site configuration.
httpd_config 'rainloop' do
  instance 'rainloop'
  source 'rainloop.conf.erb'
  notifies :restart, 'httpd_service[rainloop]'
end

# Create the document root directory.
directory node['cmamail']['rainloop']['document_root'] do
  recursive true
end

# # Write the home page.
# template "#{node['cmamail']['postfixadmin']['document_root']}/index.php" do
#   source 'index.php.erb'
#   mode '0644'
#   owner node['cmamail']['user']
#   group node['cmamail']['group']
# end

# Install the mod_php Apache module.
httpd_module 'php' do
  instance 'rainloop'
end

# Install php-mysql.
package 'php-mysql' do
  action :install
  notifies :restart, 'httpd_service[rainloop]'
end


# Install php-xml
package 'php-xml' do
  action :install
  notifies :restart, 'httpd_service[rainloop]'
end


# Deploiement du script d'installation de postfixadmin
template "#{node['cmamail']['rainloop']['document_root']}/rainloopupdate.sh" do
  source 'rainloop.erb'
  user node['cmamail']['user']
  group node['cmamail']['group']
  mode 0744
end


src_filename = "rainloop-community-#{node['cmamail']['rainloop']['version']}.zip"
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"


# Creation du repertoire de decompression de l'archive postfixadmin
directory "#{Chef::Config['file_cache_path']}/rainloop-community-#{node['cmamail']['rainloop']['version']}" do
  user node['cmamail']['rainloop']['user']
  group node['cmamail']['rainloop']['group']
  mode 0755
  action :create
end

remote_file src_filepath do
  source "#{node['repo']['repourl']}/sources/rainloop/#{src_filename}"
  notifies :run, "execute[install_rainloop]", :immediately
end

execute 'install_rainloop' do
  # cwd Chef::Config['file_cache_path']
  command "#{node['cmamail']['rainloop']['document_root']}/rainloopupdate.sh"
  not_if do ::File.exists?("#{node['cmamail']['rainloop']['document_root']}/v-#{node['cmamail']['rainloop']['version']}") end # On ne lance la bascule que si la version en cours est differente ou nulle
end

# Creation d'un symlink vers la version en cours de rainloop, celle ci etant extraite dans un repertoire suffixe de la version
# link "#{node['cmamail']['rainloop']['document_root']}/rainloop" do
#   to "#{node['cmamail']['rainloop']['document_root']}/rainloop-#{node['cmamail']['rainloop']['version']}"
# end