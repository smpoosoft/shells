# ip=$(python ../src/util/py/get_ip.py)
# echo ${ip}

# ip=$(python -c 'import socket; ip = socket.gethostbyname(socket.gethostname()); print(ip if ip != "127.0.0.1" else "")')
# echo $ip
ip=$(python ../src/util/py/getIp.py)
echo ${ip}
echo "done"
