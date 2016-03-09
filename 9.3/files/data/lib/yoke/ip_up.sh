interface=$1
ip=$2

if ifconfig ${interface}:0| grep $ip; then
  echo "already exists"
else
  ifconfig ${interface}:0 ${ip}
fi