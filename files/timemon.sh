#!/bin/bash
# Author: @jerryibrahim  

# Version 1.0.0
#Set Version Number
Version_NO="1.0.0"



# Time Drift Monitoring Main Script

# Load Properties File

. `dirname $0`/monitor.properties


# -----------------------------------------------------------------------
# -----------------------------------------------------------------------


# change working directory to where script is running
cd "$(dirname "$0")"

# Global Variables
# _LO - Log Output
_LO="" 
_OS=""
_NETSTATSEPERATOR=":"

# FUNCTIONS
fInitizalize () {
	fEcho "--------------------------------------------------------"
	fEcho "Monitoring Initialization..."
	fEcho "Program Arguments: "$1
	fEcho "Log Directory="$LOGDIR
	fEcho "PATH=$PATH"

	# Check to make sure LOGDIR is defined
	if [ x"$LOGDIR" = x ] ; then
		echo "ERROR: LOGDIR not defined in monitor.properties. Monitoring is disabled."
		exit 0
	fi

	_OS=`uname -s`
	case "x$_OS" in
	    "xLinux")
	        # Nothing to do yet
	        ;;
	    "xDarwin")
			_NETSTATSEPERATOR="."       
	        ;;
	esac      
	fEcho "Operating System: "$_OS
	fEcho "--------------------------------------------------------"
}

fEcho () {
	if [ x$VERBOSE = "x1" ] ; then
		echo $1
	fi
}

fLogAppend () {
	_LO=${_LO}"\"$1 $2\"=\"$3\", "
}

fLog () {
	fEcho "----- LOG -----"
	# TODO: ADD micro seconds

	__DateTime=`date -u +"%F %T %Z"`
	__Date=`echo $__DateTime | cut -c 1-10`

	_LO="\"timestamp\"=\"${__DateTime}\", \"timemon\"=\"$Version_NO\", ${_LO}"

	# Removes trailing comma-space ", "
	_LO=`echo $_LO | sed 's:^\(.*\)..$:\1:'`

	fEcho $_LO
	echo $_LO >> "${LOGDIR}/${__Date}_monitor.log"
}



fTimeLatency () {
	fEcho "----- Time Latency -----"
	__REMOTEHOST=$1
	__REMOTEHOSTIP=""
	__PING=""
	__LATENCY=""
	__NTP=""
	__DRIFT=""

	if [ x"$__REMOTEHOST" = x ] ; then
		# Set Default to google.com if a host is not specified
		__REMOTEHOST="time.google.com"
	fi
	fEcho "Checking: $__REMOTEHOST"		
	__PING=`ping -c 4 "$__REMOTEHOST"`

	__LATENCY=`echo ${__PING} | tail -1 | awk '{print $4}' | cut -d '/' -f 2`
	if [ x"$__LATENCY" = x ] ; then
		__LATENCY="Time Out"
	fi
	fEcho "Latency (ms): $__LATENCY"

	__REMOTEHOSTIP=`echo ${__PING} | head -n 1 | awk '{print $3}' | cut -d '(' -f 2 | cut -d ')' -f 1`
	if [ x"$__REMOTEHOSTIP" = x ] ; then
		__REMOTEHOSTIP="UNKNOWN"
	fi
	fEcho "HOST IP: $__REMOTEHOSTIP"


	__NTP=`/usr/sbin/ntpdate -q "$__REMOTEHOST"`
	__DRIFT=`echo ${__NTP} | tail -1 | awk '{print $10}'`
	if [ x"$__DRIFT" = x ] ; then
		__DRIFT="UNKNOWN"
	fi
	fEcho "NTP: $__NTP"
	fEcho "TIME DRIFT: $__DRIFT"


	fLogAppend "PingLatency" $__REMOTEHOST $__LATENCY
	fLogAppend "HostIP" $__REMOTEHOST $__REMOTEHOSTIP
	fLogAppend "TimeDrift" $__REMOTEHOST $__DRIFT
}

fUsage(){

 echo "Usage: $0 -v|--version To See version number"

}

# MAIN Script
case "$1" in
   --version|-v) 
      echo "Version "$Version_NO
      exit 0
   ;;
   "")
      echo "Script Execution Started"
   ;;
   *) 
      echo "Invalid Option"
      fUsage
      exit 1
   ;;
esac


# Change Internal Field Separator from default <space> to allow for spaces
IFS='%'
fInitizalize

#Loop through time hosts for time drift Check
for ((a=0; a < ${#TIMEHOSTS[@]}; a++))
do
    fTimeLatency ${TIMEHOSTS[a]}
done

fLog

# Reset Internal Field Separator to default <space>
unset IFS



