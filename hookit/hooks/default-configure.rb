
include Hooky::Postgresql

# Setup
boxfile = converge( BOXFILE_DEFAULTS, payload[:boxfile] )

directory '/datas'

# chown datas for gonano
execute 'chown /datas' do
  command 'chown -R gonano:gonano /datas'
end

directory '/var/log/pgsql' do
  owner 'gonano'
  group 'gonano'
end

file '/var/log/pgsql/pgsql.log' do
  owner 'gonano'
  group 'gonano'
end

execute 'rm -rf /var/pgsql'

execute '/data/bin/initdb -E UTF8 /datas' do
  user 'gonano'
  not_if { ::Dir.exists? '/datas/base' }
end

template '/datas/postgresql.conf' do
  mode 0644
  variables ({ boxfile: boxfile })
  owner 'gonano'
  group 'gonano'
end

template '/datas/pg_hba.conf' do
  mode 0600
  owner 'gonano'
  group 'gonano'
  variables ({ user: payload[:service][:users][:default][:name] })
end

# Import service (and start)
directory '/etc/service/db' do
  recursive true
end

directory '/etc/service/db/log' do
  recursive true
end

template '/etc/service/db/log/run' do
  mode 0755
  source 'log-run.erb'
  variables ({ svc: "db" })
end

template '/etc/service/db/run' do
  mode 0755
  variables ({ exec: "ulimit -n 10240 && /data/bin/pg_ctl -D /datas -w -l /var/log/pgsql/pgsql.log start 2>&1" })
end

# Wait for server to start
until File.exists?( "/tmp/.s.PGSQL.5432" )
   sleep( 1 )
end

users = payload[:service][:users]

# Create users and databases
execute 'create gonano db' do
  command "/data/bin/psql postgres -c 'CREATE DATABASE gonano;'"
  user 'gonano'
  not_if { `/data/bin/psql -U gonano gonano -c ';'`; $?.exitstatus == 0 }
end

execute 'create default user' do
  command "/data/bin/psql -c \"CREATE USER #{users[:default][:name]} ENCRYPTED PASSWORD '#{users[:default][:password]}'\""
  user 'gonano'
  not_if { `/data/bin/psql -U gonano -t -c "SELECT EXISTS(SELECT usename FROM pg_catalog.pg_user WHERE usename='#{users[:default][:name]}');"`.to_s.strip == 't' }
end

execute 'grant all to default user on gonano' do
  command "/data/bin/psql -c \"GRANT ALL PRIVILEGES ON DATABASE gonano TO #{users[:default][:name]}\""
  user 'gonano'
  not_if { `/data/bin/psql -U gonano -t -c "SELECT * FROM has_database_privilege('#{users[:default][:name]}', 'gonano', 'create');"`.to_s.strip == 't' }
end

# Configure narc
template '/opt/gonano/etc/narc.conf' do
  variables ({ uid: payload[:uid], app: "nanobox", logtap: payload[:logtap_uri] })
end

directory '/etc/service/narc'

file '/etc/service/narc/run' do
  mode 0755
  content <<-EOF
#!/bin/sh -e
export PATH="/opt/local/sbin:/opt/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/gonano/sbin:/opt/gonano/bin"

exec /opt/gonano/bin/narcd /opt/gonano/etc/narc.conf
  EOF
end

# Setup root keys for data migrations
directory '/root/.ssh' do
  recursive true
end

file '/root/.ssh/id_rsa' do
  content payload[:ssh][:admin_key][:private_key]
  mode 0600
end

file '/root/.ssh/id_rsa.pub' do
  content payload[:ssh][:admin_key][:public_key]
end

file '/root/.ssh/authorized_keys' do
  content payload[:ssh][:admin_key][:public_key]
end
