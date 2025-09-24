#!/bin/bash
# CIS macOS 15.0 Sequoia - Section 1 Audit Only

pass_count=0
fail_count=0

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

echo "== [1.3] Ensure 'Install macOS updates' Is Enabled =="
output=$(/usr/bin/sudo /usr/bin/osascript -l JavaScript <<'EOS'
$.NSUserDefaults.alloc.initWithSuiteName('com.apple.SoftwareUpdate').objectForKey('AutomaticallyInstallMacOSUpdates').js
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

echo "== [1.4] Ensure 'Install application updates from the App Store' Is Enabled =="
output=$(/usr/bin/sudo /usr/bin/osascript -l JavaScript <<'EOS'
function run() {
  let pref1 = ObjC.unwrap($.NSUserDefaults.alloc.initWithSuiteName('com.apple.commerce').objectForKey('AutoUpdate'))
  let pref2 = ObjC.unwrap($.NSUserDefaults.alloc.initWithSuiteName('com.apple.SoftwareUpdate').objectForKey('AutomaticallyInstallAppUpdates'))
  if ( pref1 == 1 || pref2 == 1 ) { return("true") } else { return("false") }
}
run()
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

echo "== [1.5] Ensure 'Install Security Responses and System files' Is Enabled =="
output=$(/usr/bin/sudo /usr/bin/osascript -l JavaScript <<'EOS'
function run() {
  let pref1 = ObjC.unwrap($.NSUserDefaults.alloc.initWithSuiteName('com.apple.SoftwareUpdate').objectForKey('ConfigDataInstall'))
  let pref2 = ObjC.unwrap($.NSUserDefaults.alloc.initWithSuiteName('com.apple.SoftwareUpdate').objectForKey('CriticalUpdateInstall'))
  if ( pref1 == 1 && pref2 == 1 ) { return("true") } else { return("false") }
}
run()
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

echo "== [1.6] Ensure Software Update Deferment ≤ 30 Days (if configured) =="
output=$(/usr/bin/sudo /usr/bin/osascript -l JavaScript <<'EOS'
$.NSUserDefaults.alloc.initWithSuiteName('com.apple.applicationaccess').objectForKey('enforcedSoftwareUpdateDelay').js
EOS
)
echo "$output"
# Assuming output is a number or null; pass if <=30 or null (not configured)
if [ -z "$output" ] || [ "$output" -le 30 ] 2>/dev/null; then
    pass_count=$((pass_count + 1))
    echo "PASS"
else
    fail_count=$((fail_count + 1))
    echo "FAIL"
fi

echo
echo "Total Passes: $pass_count"
echo "Total Fails: $fail_count"