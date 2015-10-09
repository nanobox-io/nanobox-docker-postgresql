
include Hooky::Postgresql

if payload[:platform] == 'local'
  memcap = 128
  user   = 'nanobox'
else
  memcap = payload[:member][:schema][:meta][:ram].to_i / 1024 / 1024
  user   = payload[:service][:users][:default][:name]
end

# Setup
boxfile = converge( BOXFILE_DEFAULTS, payload[:boxfile] )

execute 'generate locale' do
  command "locale-gen #{boxfile[:locale]} && update-locale"
end

directory '/data/var/db/postgresql' do
  recursive true
end

# chown data/var/db/postgresql for gonano
execute 'chown /data/var/db/postgresql' do
  command 'chown -R gonano:gonano /data/var/db/postgresql'
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

execute '/data/bin/initdb -E UTF8 /data/var/db/postgresql' do
  user 'gonano'
  not_if { ::Dir.exists? '/data/var/db/postgresql/base' }
end

template '/data/var/db/postgresql/postgresql.conf' do
  mode 0644
  variables ({
    boxfile: boxfile,
    memcap: memcap
  })
  owner 'gonano'
  group 'gonano'
end

template '/data/var/db/postgresql/pg_hba.conf' do
  mode 0600
  owner 'gonano'
  group 'gonano'
  variables ({ user: user })
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

file '/etc/service/db/run' do
  mode 0755
  content File.read("/opt/gonano/hookit/mod/files/postgresql-run")
end

# Configure narc
template '/opt/gonano/etc/narc.conf' do
  variables ({ uid: payload[:uid], app: "nanobox", logtap: payload[:logtap_host] })
end

directory '/etc/service/narc'

file '/etc/service/narc/run' do
  mode 0755
  content File.read("/opt/gonano/hookit/mod/files/narc-run")
end

# Wait for server to start
until File.exists?( "/tmp/.s.PGSQL.5432" )
   sleep( 1 )
end

# Wait for server to start
ensure_socket 'db' do
  port '(4400|5432)'
  action :listening
end

if payload[:platform] == 'local'

  # Create nanobox user and databases
  execute 'create gonano db' do
    command "/data/bin/psql postgres -c 'CREATE DATABASE gonano;'"
    user 'gonano'
    not_if { `/data/bin/psql -U gonano gonano -c ';' > /dev/null 2>&1`; $?.exitstatus == 0 }
  end

  execute 'create nanobox user' do
    command "/data/bin/psql -c \"CREATE USER nanobox ENCRYPTED PASSWORD 'password'\""
    user 'gonano'
    not_if { `/data/bin/psql -U gonano -t -c "SELECT EXISTS(SELECT usename FROM pg_catalog.pg_user WHERE usename='nanobox');"`.to_s.strip == 't' }
  end

  execute 'grant all to nanobox user on gonano' do
    command "/data/bin/psql -c \"GRANT ALL PRIVILEGES ON DATABASE gonano TO nanobox\""
    user 'gonano'
    not_if { `/data/bin/psql -U gonano -t -c "SELECT * FROM has_database_privilege('nanobox', 'gonano', 'create');"`.to_s.strip == 't' }
  end

else

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

end

boxfile[:extensions].each do |extension|

  execute 'create extension' do
    command "/data/bin/psql -c \"CREATE EXTENSION IF NOT EXISTS \\\"#{extension}\\\"\""
    user 'gonano'
  end

end

if payload[:platform] != 'local'

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

end
