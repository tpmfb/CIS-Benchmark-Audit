#!/bin/bash
# CIS macOS 15.0 Sequoia - Section 4 Audit Only

echo "== [4.1] Bonjour Advertising Services Disabled (No Multicast Ads) =="
/usr/bin/sudo /usr/bin/defaults read /Library/Preferences/com.apple.mDNSResponder NoMulticastAdvertisements
echo

echo "== [4.2] HTTP Server (Apache) Disabled =="
/bin/launchctl list | /usr/bin/grep -c org.apache.httpd
echo

echo "== [4.3] NFS Server Disabled =="
/bin/launchctl list | /usr/bin/grep -c com.apple.nfsd
echo
