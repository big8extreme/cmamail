def random_password
  require 'securerandom'
  SecureRandom.base64
end

# default['cmamail']['packages'] = %w(dovecot postfix dovecot-mysql telnet mailx mutt php-imap dovecot-core dovecot-imapd dovecot-dovec dovec dovec lmtpd)
default['cmamail']['packages'] = %w(dovecot postfix dovecot-mysql telnet mailx mutt php-imap php-mbstring dovecot opendkim unzip)
default['cmamail']['domain'] = "c-ops.com"
default['cmamail']['hostname'] = "mail.#{node['cmamail']['domain']}"
default['cmamail']['application_name'] = "mail"

default['cmamail']['repourl'] = "http://gaiarepo.cma-cgm.com/"
default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true
default['cmamail']['open_ports'] = [80, 25, 587, 993, 8080]
default['cmamail']['user'] = 'web_admin'
default['cmamail']['group'] = 'web_admin'
default['cmamail']['sslFolder'] = '/etc/pki/mail'
default['cmamail']['document_root'] = '/var/www/customers/public_html'

normal_unless['cmamail']['database']['root_password'] = 'mysql_root_password'
normal_unless['cmamail']['database']['admin_password'] = 'mysql_admin_password'

default['cmamail']['database']['dbname'] = 'mail'
default['cmamail']['database']['host'] = '127.0.0.1'
default['cmamail']['database']['root_username'] = 'root'
default['cmamail']['database']['admin_username'] = 'mail_admin'
default['cmamail']['database']['postfix']['dbname'] = 'postfix'
default['cmamail']['database']['postfix']['user'] = 'postfix'
default['cmamail']['database']['postfix']['password'] = 'postfix_password'
default['cmamail']['database']['version'] = '5.7'

default['cmamail']['postfix']['postfix_root'] = '/etc/postfix'
default['cmamail']['postfix']['group'] = 'postfix'
default['cmamail']['postfix']['user'] = 'postfix'
default['cmamail']['postfix']['aliases_db'] = '/etc/aliases'

default['cmamail']['vmail']['user'] = 'vmail'
default['cmamail']['vmail']['group'] = 'vmail'

default['cmamail']['postfixadmin']['document_root'] = '/var/www/postfixadmin'
default['cmamail']['postfixadmin']['version'] = '3.0'
default['cmamail']['postfixadmin']['user'] = node['cmamail']['user']
default['cmamail']['postfixadmin']['group'] = node['cmamail']['group']

default['cmamail']['dovecot']['dovecot_root'] = '/etc/dovecot'
default['cmamail']['dovecot']['group'] = 'dovecot'
default['cmamail']['dovecot']['user'] = 'dovecot'

default['cmamail']['opendkim']['socketfolder'] = '/var/spool/postfix/var/run/opendkim'

default['cmamail']['rainloop']['document_root'] = '/var/www/rainloop'
default['cmamail']['rainloop']['version'] = '1.10.5.192'
default['cmamail']['rainloop']['port'] = 8080
default['cmamail']['rainloop']['user'] = node['cmamail']['user']
default['cmamail']['rainloop']['group'] = node['cmamail']['group']