# timemon
Time Monitor - Custom script to monitor time drift servers.

## Manual Installation instructions
1. Login as user (ie. ubuntu) to target server
2. copy files/timemon.sh and files/monitor.properties to /opt/monscript folder
3. Remove /etc/cron.allow (or configure if needed)
4. crontab –e and add the following line: * * * * * /opt/monscript/timemon.sh (runs every minute)
5. Make sure you have one empty newline at the end of the timemon.sh entry (or cron won’t run)
6. The timemon.sh and monitor.properties should be owned by ubuntu:ubuntu 
7. The monitor.properties should have 744 file properties (i.e. chmod 744 monitor.properties)
8. The timemon.sh should have 544 file properties 
9. Create the log directory defined in monitor.properties and allow ubuntu user to write to it

