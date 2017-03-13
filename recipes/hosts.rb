#
# Cookbook Name:: cmamail
# Recipe:: hosts
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

hostsfile_entry '127.0.0.1' do
  hostname  'imap.c-ops.com'
  aliases   ['imap.c-ops.com', 'smtp.c-ops.com']
  comment   'Append by Recipe X'
  action    :append
end