include_recipe "apache::apt_repository"

directory '/vagrant/app' do
  owner "vagrant"
  group "vagrant"
  mode  0755
  recursive true
  action :create
  not_if { ::FileTest.exists?("/vagrant/app/webroot/index.php") }
end

directory '/vagrant/app' do
  owner "vagrant"
  group "vagrant"
  mode  0755
  recursive true
  action :create
  not_if { ::FileTest.exists?("/vagrant/app/webroot/index.php") }
end

directory '/vagrant/app/webroot' do
  owner "vagrant"
  group "vagrant"
  mode  0755
  recursive true
  action :create
  not_if { ::FileTest.exists?("/vagrant/app/webroot/index.php") }
end

template "/vagrant/app/webroot/index.php" do
  source "index.php.erb"
  owner "vagrant"
  group "vagrant"
  mode 0644
  not_if { ::FileTest.exists?("/vagrant/app/webroot/index.php") }
end

package "apache2"  do
  action :install
end

package "libapache2-mod-fastcgi" do
  action :install
end

service "apache2"  do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/apache2/conf-enabled/php5-fpm.conf" do
  source "php.conf.erb"
  owner "root"
  group "root"
  mode 0777
  notifies :restart, "service[apache2]"
end

template "/etc/apache2/sites-available/000-default" do
  source "app.dev.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :server_name => node['apache2']['server_name']
  )
  notifies :restart, "service[apache2]"
end
