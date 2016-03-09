interface=$1
ip=$2

if ifconfig ${interface}:0| grep $ip; then
  ifconfig ${interface}:0 down
else
  echo "already gone"
fi