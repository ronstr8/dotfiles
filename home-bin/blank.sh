#!/bin/bash

#CDRECORD_SPEED=4
#CDRECORD_ARGS="blank=fast -dev 0,0,0 -speed=$CDRECORD_SPEED"
CDRECORD_ARGS="blank=all -dev /dev/cdrom -speed=4"
cdrecord $CDRECORD_ARGS 

