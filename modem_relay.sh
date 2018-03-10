#!/bin/bash
# MIT License

# Copyright (c) 2018 Jacob Wilkinson

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
