# timemon
Time Monitor - Custom script to monitor time drift on servers.

## Manual Installation instructions (assumming Ubuntu 16 LTS)
1. Login as user (ie. ubuntu) to target server
2. copy files/timemon.sh and files/monitor.properties to /opt/monscript folder
3. The timemon.sh and monitor.properties should be owned by root:root 
4. The monitor.properties should have 755 file properties (i.e. chmod 755 monitor.properties)
5. The timemon.sh should have 555 file properties 
6. Create the log directory defined in monitor.properties and owned by ubuntu:ubuntu (ie. chown ubuntu:ubuntu logs)
7. Allow ubuntu user to read/write to it (ie. chmod 744 /opt/logs/timemon) 
8. install nptdate on ubuntu (sudo apt install ntpdate)
9. Remove /etc/cron.allow (or configure if needed)
10. crontab –e and add the following line: * * * * * /opt/monscript/timemon.sh (runs every minute)
11. Make sure you have one empty newline at the end of the timemon.sh entry (or cron won’t run)

## TODO
1. Remove assumption that nptdate is in /usr/sbin


