#!/bin/bash
# CIS macOS 15.0 Sequoia - Section 5 Audit Only

echo "== [5.1.1] Home Folders Are Secure (700 recommended) =="
/usr/bin/dscl . -list /Users | while read u; do
  p=$(/usr/bin/dscl . -read /Users/"$u" NFSHomeDirectory 2>/dev/null | /usr/bin/awk '{print $2}')
  [ -n "$p" ] && [ -d "$p" ] && /bin/ls -ldO "$p"
done
echo

echo "== [5.1.2] System Integrity Protection (SIP) Enabled =="
/usr/bin/csrutil status
echo

echo "== [5.1.3] Apple Mobile File Integrity (AMFI) Enabled =="
/usr/sbin/nvram boot-args 2>/dev/null | /usr/bin/grep -q "amfi_get_out_of_my_way=1" && echo "AMFI Disabled flag present" || echo "No AMFI bypass flag in boot-args"
echo

echo "== [5.1.4] Signed System Volume (SSV) Enabled =="
/usr/bin/mount | /usr/bin/grep " / .*sealed"
echo

echo "== [5.1.5] Permissions for System-wide Applications Appropriate =="
/bin/ls -ld /Applications
/bin/ls -lO /Applications | /usr/bin/head
echo

echo "== [5.1.6] No World-writable Folders in /System =="
/usr/bin/sudo /usr/bin/find /System -type d -perm -0002 -maxdepth 5 2>/dev/null | /usr/bin/head
echo

echo "== [5.1.7] No World-writable Folders in /Library =="
/usr/bin/sudo /usr/bin/find /Library -type d -perm -0002 -maxdepth 5 2>/dev/null | /usr/bin/head
echo

echo "== [5.2.x] Password Management (org policy; sample audits) =="
/usr/bin/pwpolicy getaccountpolicies 2>/dev/null
/usr/bin/pwpolicy -showaccountpolicies 2>/dev/null
echo

echo "== [5.4] Sudo Timeout Period Set to Zero (require password each time) =="
/usr/bin/sudo /usr/bin/grep -E 'timestamp_timeout' /etc/sudoers /etc/sudoers.d/* 2>/dev/null
echo

echo "== [5.5] Separate Timestamp for Each user/tty (tty_tickets) =="
/usr/bin/sudo /usr/bin/grep -E 'tty_tickets' /etc/sudoers /etc/sudoers.d/* 2>/dev/null
echo

echo "== [5.6] 'root' Account Disabled =="
/usr/bin/dscl . -read /Users/root AuthenticationAuthority 2>/dev/null
echo

echo "== [5.7] Admin Cannot Login to Another User's Active Locked Session (test via authdb/profile) =="
/usr/bin/security -q authorizationdb read system.login.screensaver 2>/dev/null | /usr/bin/head
echo

echo "== [5.8] Login Window Banner Exists =="
/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText 2>/dev/null
echo

echo "== [5.9] Guest Home Folder Does Not Exist =="
[ -d /Users/Guest ] && echo "/Users/Guest exists" || echo "No /Users/Guest home"
echo

echo "== [5.10] XProtect Running and Updated =="
/usr/libexec/XProtectCheck --check 2>/dev/null || /usr/bin/defaults read /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta LastModification 2>/dev/null
echo

echo "== [5.11] Logging Enabled for sudo (match rsyslog/asl/newsyslog policy) =="
/usr/bin/sudo /usr/bin/grep -i sudo /etc/asl/*.conf /etc/newsyslog.conf 2>/dev/null || true
echo
