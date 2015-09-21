
execute "send diff data to new member" do
  command "rsync --delete -a /datas/. #{payload[:new_member][:local_ip]}:/datas/"
end
