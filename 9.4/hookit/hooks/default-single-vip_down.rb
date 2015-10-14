
execute "bring down vip" do
  command "ifconfig eth0:0 down"
end

execute "remove persistance" do
  command "rm -f /etc/nanoinit.d/eth00"
end
