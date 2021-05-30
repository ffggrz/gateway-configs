#!/bin/bash
INTERFACE="$3"

##/sbin/brctl delif ggrzL2TP $INTERFACE
/usr/sbin/batctl meshif ggrzBAT if del $INTERFACE
exit 0

