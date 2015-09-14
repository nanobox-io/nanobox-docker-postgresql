
include Hooky::Postgresql

# Setup
boxfile = converge( BOXFILE_DEFAULTS, payload[:boxfile] )

# configure yoke.ini
template '/data/etc/yoke.ini' do
  mode 0644
  owner 'gonano'
  group 'gonano'
end

# update start comand
template '/etc/service/db/run' do
  mode 0755
  variables ({ exec: "/data/bin/yoke /data/etc/yoke.ini 2>&1" })
end
