#!/bin/bash
# CIS macOS 15.0 Sequoia - Section 3 Audit Only

echo "== [3.1] Security Auditing Enabled (auditd) =="
/bin/launchctl list | /usr/bin/grep -i auditd
echo

echo "== [3.2] Security Auditing Flags for User-Attributable Events =="
/usr/bin/sudo /usr/bin/grep -e "^flags:" /etc/security/audit_control
echo "Expected to include: aa, ad, -ex, -fm, -fr, -fw, lo  (or -all for all failed classes)"
echo

echo "== [3.3] install.log Retained for ≥365 Days, No Max Size (review policy files) =="
/usr/bin/sudo /usr/bin/grep -i "install" /etc/asl/*.conf 2>/dev/null || true
/usr/bin/sudo /usr/bin/grep -i "install" /etc/newsyslog.conf 2>/dev/null || true
echo "Also inspect /var/log/install.log rotation policy as applicable."
echo

echo "== [3.4] Security Auditing Retention Enabled =="
/usr/bin/sudo /usr/bin/grep -e "^expire-after" /etc/security/audit_control
echo

echo "== [3.5] Access to Audit Records Controlled (permissions) =="
/bin/ls -ld /var/audit
/bin/ls -l /var/audit | /usr/bin/head
echo

echo "== [3.6] Software Inventory (Manual) =="
echo "Manual: inventory via MDM/management tool; Terminal example:"
echo "  system_profiler SPApplicationsDataType -detailLevel mini"
echo
