
service 'db' do
  action :enable
  init 'runit'
end
