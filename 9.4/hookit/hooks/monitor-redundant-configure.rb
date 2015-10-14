
include Hooky::Postgresql

template '/data/etc/yoke.ini' do
  mode 0644
  owner 'gonano'
  group 'gonano'
end

# Import service (and start)
directory '/etc/service/monitor' do
  recursive true
end

directory '/etc/service/monitor/log' do
  recursive true
end

template '/etc/service/monitor/log/run' do
  mode 0755
  source 'log-run.erb'
  variables ({ svc: "monitor" })
end

template '/etc/service/monitor/run' do
  mode 0755
  variables ({ exec: "/data/bin/yoke /data/etc/yoke.ini 2>&1" })
end

# execute 'give gonano permissions to enable vip'
