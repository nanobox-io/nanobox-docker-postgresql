
directory '/datas'

# chown datas for gonano
execute 'chown /datas' do
  command 'chown -R gonano:gonano /datas'
end

file '/var/log/postgresql.log' do
  owner 'gonano'
  group 'gonano'
end

execute '/data/bin/initdb -E UTF8 /datas' do
  user 'gonano'
  not_if { ::Dir.exists? '/datas/base' }
end

hookit_file '/datas/postgresql.conf' do
  mode 0644
  owner 'gonano'
  group 'gonano'
end

template '/datas/pg_hba.conf' do
  mode 0600
  owner 'gonano'
  group 'gonano'
  variables ({ user: "nanobox" })
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
  variables ({ exec: "ulimit -n 10240 && /data/bin/pg_ctl -D /datas -w -l /var/log/postgresql.log start" })
end

# Wait for server to start
until File.exists?( "/tmp/.s.PGSQL.5432" )
   sleep( 1 )
end

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
