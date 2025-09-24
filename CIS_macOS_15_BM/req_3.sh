#!/bin/bash
# CIS macOS 15.0 Sequoia - Section 3 Audit Only

pass_count=0
fail_count=0

echo "== [3.1] Security Auditing Enabled (auditd) =="
output=$(/usr/bin/sudo /bin/launchctl list 2>&1)
echo "$output"
if echo "$output" | /usr/bin/grep -qi "com.apple.auditd"; then
    pass_count=$((pass_count + 1))
    echo "PASS"
else
    fail_count=$((fail_count + 1))
    echo "FAIL"
fi
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


echo "== [1.1] Ensure All Apple-provided Software Is Current =="
output=$(/usr/bin/sudo /usr/sbin/softwareupdate -l 2>&1)
echo "$output"
if echo "$output" | /usr/bin/grep -qi "no new software available"; then
    pass_count=$((pass_count + 1))
    echo "PASS"
else
    fail_count=$((fail_count + 1))
    echo "FAIL"
fi
echo

echo "== [1.2] Ensure 'Download new updates when available' Is Enabled =="
output=$(/usr/bin/sudo /usr/bin/osascript -l JavaScript <<'EOS'
$.NSUserDefaults.alloc.initWithSuiteName('com.apple.SoftwareUpdate').objectForKey('AutomaticDownload').js
EOS
)
echo "$output"
if [ "$output" = "true" ]; then
    pass_count=$((pass_count + 1))
    echo "PASS"
else
    fail_count=$((fail_count + 1))
    echo "FAIL"
fi

echo
echo "Total Passes: $pass_count"
echo "Total Fails: $fail_count"