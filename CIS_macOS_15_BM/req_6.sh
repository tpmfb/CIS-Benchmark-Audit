#!/bin/bash
# CIS macOS 15.0 Sequoia - Section 6 Audit Only

echo "== [6.1.1] Finder: Show All Filename Extensions Enabled =="
/usr/bin/defaults read NSGlobalDomain AppleShowAllExtensions 2>/dev/null
echo

echo "== [6.2.x] Mail: Protect Mail Activity (Manual/GUI) =="
echo "Manual: Mail > Settings > Privacy > Protect Mail Activity."
echo

echo "== [6.3.1] Safari: Automatic Opening of 'Safe' Files Disabled =="
/usr/bin/defaults read com.apple.Safari AutoOpenSafeDownloads 2>/dev/null
echo

echo "== [6.3.3] Safari: Warn When Visiting Fraudulent Website Enabled =="
/usr/bin/defaults read com.apple.Safari WarnAboutFraudulentWebsites 2>/dev/null
echo

echo "== [6.3.4] Safari: Prevent Cross-site Tracking Enabled =="
/usr/bin/defaults read com.apple.Safari PreventCrossSiteTracking 2>/dev/null
echo

echo "== [6.3.6] Safari: Advertising Privacy Protection Enabled =="
/usr/bin/defaults read com.apple.Safari PrivateClickMeasurementEnabled 2>/dev/null
echo

echo "== [6.3.7] Safari: Show Full Website Address Enabled =="
/usr/bin/defaults read com.apple.Safari ShowFullURLInSmartSearchField 2>/dev/null
echo

echo "== [6.3.10] Safari: Show Status Bar Enabled =="
/usr/bin/defaults read com.apple.Safari ShowStatusBar 2>/dev/null
echo

echo "== [6.4.1] Terminal.app: Secure Keyboard Entry Enabled =="
/usr/bin/defaults read com.apple.Terminal SecureKeyboardEntry 2>/dev/null
echo

echo "== [6.5.1] Passwords: Audit (Manual/Password Manager UI) =="
echo "Manual: System Settings > Passwords — review per org policy."
echo
