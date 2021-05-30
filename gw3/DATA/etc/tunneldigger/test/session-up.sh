#!/bin/bash

INTERFACE="$3"
MTU="$4"

/bin/ip link set dev $INTERFACE up mtu $MTU
##/sbin/brctl addif ggrzL2TP $INTERFACE
/usr/sbin/batctl meshif ggrzBAT if add $INTERFACE
