
service "monitor" do
  action :disable
  only_if { File.exist?('/etc/service/monitor/run') }
  init :runit
end
