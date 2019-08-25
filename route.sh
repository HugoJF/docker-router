#!/bin/bash

function flush_iptables() {
	iptables -t nat -F PREROUTING
	return 0
}

function set_destination_by_hostname() {
	# Translate destination hostname to IP
	echo "Translating destination name $DESTINATION ..."
	if ! DESTINATION_IP_RAW=$(host $DESTINATION);
	then
		echo "Failed to resolve $DESTINATION"
		echo "ERROR: $DESTINATION_IP_RAW"
		return 1
	else
		DESTINATION_IP=$(echo $DESTINATION_IP_RAW | awk '{print $NF}')
		echo "Destination was translated to $DESTINATION_IP"
	fi

	# Redirect all packets to destination host
	if ! iptables -t nat -A PREROUTING -i eth1 -j DNAT --to-destination $DESTINATION_IP;
	then
		echo "Failed to set IPTables rules"
		echo "ERROR: Code $?"
	fi
}

echo "===== Setting IPTables ====="

# Clear prerouting table
echo "Flushing PREROUTING chain on NAT table"
flush_iptables
# iptables -t nat -F PREROUTING

# Translate destination hostname to IP
# echo "Translating destination name $DESTINATION ..."
# export DESTINATION_IP=$(host $DESTINATION | awk '{print $NF}')

# Redirect all packets to destination host
# echo "Destination was translated to $DESTINATION_IP"
# iptables -t nat -A PREROUTING -j DNAT --to-destination $DESTINATION_IP

# eth1 is selected because eth0 should be input (since we join the public IP network) and eth1 should be the bridge network (later manually joined)
#
# we only MASQUERADE eth1 to allow responses to be routed back to the agent
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

set_destination_by_hostname

# tail -f /dev/null
for (( ; ; ))
do
	echo "Checking for hostname changes"
	flush_iptables
	set_destination_by_hostname
	sleep 10
done
