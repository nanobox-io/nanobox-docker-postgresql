
payload[:generation][:members].each do |member|

  if member[:member_type] == 'default'

    execute "send diff data to new member" do
      command "rsync --delete -a /datas/. #{member[:local_ip]}:/datas/"
    end

  end
end
