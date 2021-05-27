#!/bin/bash
# !! IPv4 Only !!

UMBRELLA_IP="208.67.220.220"
# https://docs.umbrella.com/deployment-umbrella/docs/find-your-organization-id
UMBRELLA_DEVICE_ID=""
# https://support.umbrella.com/hc/en-us/articles/230651087-Cisco-Umbrella-Network-Device-Integrations
ORG_ID=""
#Pad 1 Byte
ORG_ID_HEX=`printf '00%x\n' $ORG_ID | grep -Eo '[0-9ef]{8}$'`
MAGIC_26946="4f70656e444e53"
MAGIC_20292="4f444e53000008"
QUERY="$1"
#convert to HEX
IP_SRC_ADDR="`echo $2 | sed 's/\./ /g'`"
IP_SRC_ADDR_HEX=`printf '%02x' $IP_SRC_ADDR`

if [ "$#" -ne 2 ]; then
	echo "$0 [ DNS_QUERY ] [ SRC_IP ]"
	exit 10
fi
dig $QUERY \
	+ednsopt="26946:${MAGIC_26946}${UMBRELLA_DEVICE_ID}" \
	+ednsopt="20292:${MAGIC_20292}${ORG_ID_HEX}10${IP_SRC_ADDR_HEX}40${UMBRELLA_DEVICE_ID}" \
	@$UMBRELLA_IP
