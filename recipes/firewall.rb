include_recipe 'firewall::default'

node['cmamail']['open_ports'].each do |port|
  firewall_rule "open ports #{port}" do
    port port
  end
end
#
# ports = node['cmamail']['open_ports']
# firewall_rule "open ports #{ports}" do
#   port ports
# end

firewall 'default' do
  action :save
end