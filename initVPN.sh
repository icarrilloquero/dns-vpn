#!/bin/bash
IMAGE=icarrilloquero/rpi-openvpn
BUFFER_CLIENT=393216
OVPN_DATA=ads-ovpn-data

if [ "$PROTOCOL" = "tcp" ]; then
        BUFFER_SERVER=0
else
        BUFFER_SERVER=$BUFFER_CLIENT
fi

docker volume create --name $OVPN_DATA && \
docker run -v $OVPN_DATA:/etc/openvpn --rm $IMAGE \
        ovpn_genconfig -d -N \
                -u $OVPN_URI \
                -e "sndbuf $BUFFER_SERVER" \
                -e "rcvbuf $BUFFER_SERVER" \
                -e "push \"sndbuf $BUFFER_CLIENT\"" \
                -e "push \"rcvbuf $BUFFER_CLIENT\"" \
		-n "$DNS" \
		-p "script-security 2" \
                -p "block-outside-dns" \
                -p "route $DNS 255.255.255.255" && \
docker run -v $OVPN_DATA:/etc/openvpn --rm -it $IMAGE ovpn_initpki
