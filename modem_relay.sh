#!/bin/bash
#VARS
REMOTEIP=8.8.8.8 #Host to ping
TRIGGERPIN=0 #wiringpi pin numbering scheme
WAITBETWEENREBOOT=300 #wait timeout between checks after reboot
REBOOTPERIOD=10 #Wait between off and on command
PINGCOUNT=0 #Increment number of failed pings
PINGDELAY=30 #Delay between each ping
PINGTHRESHOLD=5 #Number of consecutive failures needed to indicated failure

#INIT
gpio mode ${TRIGGERPIN} out
gpio write ${TRIGGERPIN} 1 # turn on pin

#MAIN LOOP
while true; do #Master loop
	while [ ${PINGCOUNT} -lt ${PINGTHRESHOLD} ]; do #Check if ping has failed enough
		#Ping our host
		ping -c 1 -w 1 ${REMOTEIP}
		# Check our conditions
		if [ $? -ne 0 ];then
			((PINGCOUNT++))
		else
			PINGCOUNT=0
		fi
		sleep ${PINGDELAY} # time to next ping
	done #End loop
	PINGCOUNT=0 #Reset fail counter before reboot
	logger Rebooting modem on `date`
	gpio mode ${TRIGGERPIN} out
	gpio write ${TRIGGERPIN} 0 # turn off pin
	sleep ${REBOOTPERIOD}
	gpio write ${TRIGGERPIN} 1 # turn on pin
	sleep ${WAITBETWEENREBOOT}
done #End master loop
