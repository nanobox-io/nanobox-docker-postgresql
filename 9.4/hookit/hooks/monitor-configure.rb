
include Hooky::Postgresql

# Setup
boxfile = converge( BOXFILE_DEFAULTS, payload[:boxfile] )

# Setup root keys for data migrations
directory '/root/.ssh' do
  recursive true
end

file '/root/.ssh/id_rsa' do
  content payload[:ssh][:admin_key][:private_key]
  mode 0600
end

file '/root/.ssh/id_rsa.pub' do
  content payload[:ssh][:admin_key][:public_key]
end

file '/root/.ssh/authorized_keys' do
  content payload[:ssh][:admin_key][:public_key]
end
