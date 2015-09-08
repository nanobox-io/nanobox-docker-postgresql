
service "monitor" do
  action :enable
  only_if { File.exist?('/etc/service/monitor/run') }
  init :runit
end
