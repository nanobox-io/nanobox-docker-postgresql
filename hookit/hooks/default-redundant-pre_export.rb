
payload[:generation][:members].each do |member|

  if member[:member_type] == 'default'

    execute "send bulk data to new member" do
      command "tar -cf - /datas | ssh #{member[:local_ip]} tar -xpf -"
    end

  end
end
