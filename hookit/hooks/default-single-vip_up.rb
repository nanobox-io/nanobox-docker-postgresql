
# IMPORTANT NOTE: docker container must be run with --priviledged="true"

# set up persistance 
file "/etc/nanoinit.d/eth00" do
  content <<-EOF
    ifconfig eth0:0 #{payload[:service][:ips][:default]}
  EOF
  mode 0755
end

# bring up interface
execute "bring up vip" do
  command <<-EOF
    ifconfig eth0:0 #{payload[:service][:ips][:default]}
  EOF
end 
