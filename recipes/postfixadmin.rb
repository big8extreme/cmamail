# Install Apache and start the service.
httpd_service 'postfixadmin' do
  mpm 'prefork'
  action [:create, :start]
end

# Add the site configuration.
httpd_config 'postfixadmin' do
  instance 'postfixadmin'
  source 'postfixadmin.conf.erb'
  notifies :restart, 'httpd_service[postfixadmin]'
end

# Create the document root directory.
directory node['cmamail']['postfixadmin']['document_root'] do
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
  instance 'postfixadmin'
end

# Install php-mysql.
package 'php-mysql' do
  action :install
  notifies :restart, 'httpd_service[postfixadmin]'
end

src_filename = "postfixadmin-#{node['cmamail']['postfixadmin']['version']}.tar.gz"
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"


# Creation du repertoire de decompression de l'archive postfixadmin
directory "#{Chef::Config['file_cache_path']}/postfixadmin-#{node['cmamail']['postfixadmin']['version']}" do
  user node['cmamail']['postfixadmin']['user']
  group node['cmamail']['postfixadmin']['group']
  mode 0755
  action :create
end

remote_file src_filepath do
  source "#{node['repo']['repourl']}/sources/postfixadmin/#{src_filename}"
  # checksum node[:program][:checksum]
  notifies :run, "execute[install_postfixadmin]", :immediately
end

# Deploiement du script d'installation de postfixadmin
template "#{node['cmamail']['postfixadmin']['document_root']}/postfixadminupdate.sh" do
  source 'postfixadmin.erb'
  user node['cmamail']['user']
  group node['cmamail']['group']
  mode 0744
end

execute 'install_postfixadmin' do
  cwd Chef::Config['file_cache_path']
  # command "tar xf #{Chef::Config['file_cache_path']}/#{src_filename} -C rocketchat && cp -a #{Chef::Config['file_cache_path']}/rocketchat/bundle/* #{node['cmarocketchat']['install_dir']} && touch #{node['cmarocketchat']['install_dir']}/v-#{node['cmarocketchat']['rocket_version']}"
  command "#{node['cmamail']['postfixadmin']['document_root']}/postfixadminupdate.sh"
  not_if do ::File.exists?("#{node['cmamail']['postfixadmin']['document_root']}/v-#{node['cmamail']['postfixadmin']['version']}") end # On ne lance la bascule que si la version en cours est differente ou nulle
end

# Creation du repertoire des templates et bascule en 777
directory "#{node['cmamail']['postfixadmin']['document_root']}/postfixadmin-#{node['cmamail']['postfixadmin']['version']}/templates_c" do
  user node['cmamail']['postfixadmin']['user']
  group node['cmamail']['postfixadmin']['group']
  mode 0777
  action :create
end

# Creation d'un symlink vers la version en cours de postfixadmin, celle ci etant extraite dans un repertoire suffixe de la version
link "#{node['cmamail']['postfixadmin']['document_root']}/postfixadmin" do
  to "#{node['cmamail']['postfixadmin']['document_root']}/postfixadmin-#{node['cmamail']['postfixadmin']['version']}"
end

# Ecriture du fichier de configuration de postfix
# Todo le hash généré par l'assistant doit etre rajoute dans le fichier config.inc.php $CONF['setup_password'] = 'HASH';
template "#{node['cmamail']['postfixadmin']['document_root']}/postfixadmin/config.inc.php" do
  source 'postfixadmin-config.erb'
  mode '0644'
  owner node['cmamail']['user']
  group node['cmamail']['group']
end

template "#{node['cmamail']['postfix']['postfix_root']}/mysql-virtual-mailbox-domains.cf" do
  source 'mysql-virtual-mailbox-domains.cf.erb'
  mode '0640'
  group node['cmamail']['postfix']['group']
end

template "#{node['cmamail']['postfix']['postfix_root']}/mysql-virtual-mailbox-maps.cf" do
  source 'mysql-virtual-mailbox-maps.cf.erb'
  mode '0640'
  group node['cmamail']['postfix']['group']
end

template "#{node['cmamail']['postfix']['postfix_root']}/mysql-virtual-alias-maps.cf" do
  source 'mysql-virtual-alias-maps.cf.erb'
  mode '0640'
  group node['cmamail']['postfix']['group']
end