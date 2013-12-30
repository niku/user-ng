#
# Cookbook Name:: user-ng
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
data_bag('users').each do |id|
  u = data_bag_item('users', id)
  username = u['id']
  homedir = "/home/#{username}"

  user username do
    supports manage_home: true
    home homedir
    shell u['shell'] || '/bin/bash'
  end

  if u['ssh_keys']
    sshdir = "#{homedir}/.ssh"

    directory sshdir do
      owner username
      group username
      mode '0700'
    end

    template "#{sshdir}/authorized_keys" do
      source 'authorized_keys.erb'
      owner username
      group username
      mode '0400'
      variables ssh_keys: u['ssh_keys']
    end
  end

  if u['sudo_privilege']
    template "/etc/sudoers.d/#{username}" do
      source 'sudo_privilege.erb'
      variables username: username, sudo_privilege: u['sudo_privilege']
      mode '0440'
    end
  end

  if u['sudo_privilege']
    template "/etc/sudoers.d/#{username}" do
      source 'sudo_privilege.erb'
      variables username: username, sudo_privilege: u['sudo_privilege']
      mode '0440'
    end
  end
end
