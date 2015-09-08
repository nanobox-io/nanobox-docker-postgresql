
service 'db' do
  action :disable
  init :runit
end
