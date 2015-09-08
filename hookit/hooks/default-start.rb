
# the only_if logic is there as an alternative to `sleep 6` (runit service detection)
service 'db' do
  action :enable
  init :runit
  only_if do
    if File.exist?('/etc/service/db/run')
      6.times { `sv status db`; break if $?.exitstatus == 0; sleep 1}
      $?.exitstatus == 0
    else
      false
    end
  end
end

execute 'ensure socket' do
  command "netstat -an | egrep ':(4400|5432)'"
  only_if do
    5.times { `netstat -an | egrep ':(4400|5432)'`; $?.exitstatus == 0 && break; sleep 1 }
    $?.exitstatus == 0
  end
end
