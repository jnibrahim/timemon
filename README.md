# timemon
Time Monitor - Custom script to monitor time drift on servers.

## Manual Installation instructions (assumming Ubuntu 16 LTS)
1. Login as user (ie. ubuntu) to target server
2. copy files/timemon.sh and files/monitor.properties to /opt/monscript folder
3. Remove /etc/cron.allow (or configure if needed)
4. crontab –e and add the following line: * * * * * /opt/monscript/timemon.sh (runs every minute)
5. Make sure you have one empty newline at the end of the timemon.sh entry (or cron won’t run)
6. The timemon.sh and monitor.properties should be owned by root:root 
7. The monitor.properties should have 755 file properties (i.e. chmod 755 monitor.properties)
8. The timemon.sh should have 555 file properties 
9. Create the log directory defined in monitor.properties and owned by ubuntu:ubuntu (ie. chown ubuntu:ubuntu logs)
10. Allow ubuntu user to read/write to it (ie. chmod 744 /opt/logs/timemon) 
11. install nptdate on ubuntu (sudo apt install ntpdate)

## TODO
1. Remove assumption that nptdate is in /usr/sbin


