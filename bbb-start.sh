#!/bin/bash
# Little helper start script for BigBlueButton in a docker container.
# Author: sandersliu <sandersliu@hotmail.com>
function get_ip (){
curl ip.appspot.com
}
if [ -z "$host" ]; then
host=`get_ip`
fi

echo -e "Starting Enable WebRTC audio ...\n"
bbb-conf --enablewebrtc

# echo -e "Starting BigBlueButton services...\n"
# service redis-server-2.2.4 start
# service bbb-openoffice-headless start
echo -e "Updating BigBlueButton IP address configuration...\n"
bbb-conf --setip $host
# echo -e "Setting BigBlueButton secret...\n"
# bbb-conf --setsecret $secret
# echo -e "Setting BigBlueButton hostname...\n"
# bbb-conf --setip $host
echo -e "Restarting BigBlueButton to apply new secret...\n"
bbb-conf --clean
echo -e "Checking BigBlueButton configuration...\n"
bbb-conf --check
echo -e "*******************************************"
echo -e "Use the following details to access your BBB container:\n"
bbb-conf --secret
echo -e "*******************************************\n"
#Ugly hack: Infinite loop to maintain the container running
#while true;do sleep 100000;done
# dump logs to stdout for docker log viewing
# ideally each service should be in a seperate container which could avoid this
tail -f -n0 /var/log/bigbluebutton/*
