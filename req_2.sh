#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.1.0
# SECTION 2 — System Settings (AUDIT ONLY, NO REMEDIATION)
# Prints current state; map outputs to your policy. Run as root for best coverage.

echo "CIS macOS 15 (Sequoia) — Section 2: System Settings (Audit Only)"
hr

# 2.1 Apple Account
echo "[2.1] Apple Account — General (Manual/GUI review)"
echo " Open: System Settings > Apple Account (or Managed Apple Account). Verify org policy."
echo

# 2.1.1 iCloud
echo "[2.1.1] iCloud — Multiple subcontrols"
echo " Most iCloud audits are GUI/profile-driven. Printing a few useful reads:"
/usr/bin/defaults read NSGlobalDomain NSDocumentSaveNewDocumentsToCloud 2>/dev/null || echo "  (No key)"
/usr/bin/defaults read com.apple.finder FXICloudDriveDesktop 2>/dev/null || true
/usr/bin/defaults read com.apple.finder FXICloudDriveDocuments 2>/dev/null || true
echo " If MDM enforces iCloud Drive/Docs sync: check profiles for com.apple.applicationaccess / com.apple.iCloud."
echo

echo "[2.1.1.1] Audit iCloud Keychain (Manual)"
echo " GUI: System Settings > Apple Account > iCloud > Passwords & Keychain per policy."
echo

echo "[2.1.1.2] Audit iCloud Drive (Manual + keys above)"
echo

echo "[2.1.1.3] Ensure iCloud Drive Desktop & Documents Sync is Disabled (Automated via profile)"
echo " NOTE: Compliance typically via MDM profile. Check via profiles:"
/usr/bin/profiles -P -o stdout | /usr/bin/grep -Ei 'iCloud|com.apple.iCloud|com.apple.applicationaccess' -A3 || true
echo

echo "[2.1.1.4] Audit Security Keys used with Apple Accounts (Manual)"
echo

echo "[2.1.1.5] Audit Freeform Sync to iCloud (Manual)"
echo

echo "[2.1.1.6] Audit Find My Mac (Manual)"
echo

echo "[2.1.2] Audit App Store Password Settings (Manual)"
echo

hr
# 2.2 Network
echo "[2.2.1] Ensure Firewall is Enabled (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.alf globalstate 2>/dev/null || echo " (No value)"
echo "  Expected: 1 or 2 (enabled modes)."
echo

echo "[2.2.2] Ensure Firewall Stealth Mode is Enabled (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.alf stealthenabled 2>/dev/null || echo " (No value)"
echo

hr
# 2.3 General
echo "[2.3.1.1] Ensure AirDrop is Disabled When Not Actively Transferring (Automated)"
/usr/bin/defaults read com.apple.NetworkBrowser DisableAirDrop 2>/dev/null || echo " (No value)"
echo "  Expected: 1 (disabled) when not needed."
echo

echo "[2.3.1.2] Ensure AirPlay Receiver is Disabled (Automated)"
/usr/bin/defaults read com.apple.controlcenter AirPlayReceiverEnabled 2>/dev/null || echo " (No value)"
echo "  Expected: 0 (disabled) on enterprise devices unless required."
echo

echo "[2.3.2.1] Ensure Set Time and Date Automatically is Enabled (Automated)"
/usr/sbin/systemsetup -getusingnetworktime
echo

echo "[2.3.2.2] Ensure the Time Service is Enabled (Automated)"
/bin/launchctl print-disabled system | /usr/bin/grep com.apple.timed || echo "  (No print-disabled entry; verify timed active)"
echo

# 2.3.3 Sharing
echo "[2.3.3.1] Ensure Screen Sharing is Disabled (Automated)"
/bin/launchctl list | /usr/bin/grep -c com.apple.screensharing || true
echo "  0 means not running; also verify in System Settings > General > Sharing."
echo

echo "[2.3.3.2] Ensure File Sharing is Disabled (Automated)"
/bin/launchctl list | /usr/bin/grep -c com.apple.smbd || true
echo "  0 means SMB not running."
echo

echo "[2.3.3.3] Ensure Printer Sharing is Disabled (Automated)"
/bin/launchctl list | /usr/bin/grep -c org.cups.cupsd || true
echo

echo "[2.3.3.4] Ensure Remote Login (SSH) is Disabled (Automated)"
/usr/sbin/systemsetup -getremotelogin
echo "  Expected: Remote Login: Off"
echo

echo "[2.3.3.5] Ensure Remote Management (ARD) is Disabled (Automated)"
/usr/bin/sudo /bin/ps -ef | /usr/bin/grep -e ARDAgent
echo " (Benchmark Terminal Method: ps | grep ARDAgent) — ensure ARDAgent not active." # CIS ref
# Ref: Remote Management audit command per CIS PDF
# 
echo

echo "[2.3.3.6] Ensure Remote Apple Events is Disabled (Automated)"
/bin/launchctl print-disabled system | /usr/bin/grep com.apple.AEServer || echo "  (No print-disabled line; verify in Sharing UI)"
echo

echo "[2.3.3.7] Ensure Internet Sharing is Disabled (Automated)"
/usr/bin/defaults read /Library/Preferences/SystemConfiguration/com.apple.nat NAT 2>/dev/null || echo " (No NAT key; likely disabled)"
echo

echo "[2.3.3.8] Ensure Content Caching is Disabled (Automated)"
/usr/bin/AssetCacheManagerUtil status 2>/dev/null | /usr/bin/grep -i "Activated:" || echo "  (No AssetCacheManagerUtil status; not running?)"
echo

echo "[2.3.3.9] Ensure Media Sharing is Disabled (Automated)"
/usr/bin/defaults read com.apple.amp.mediasharingd home-sharing-enabled 2>/dev/null || echo " (No value)"
echo "  Expected: 0"
echo

echo "[2.3.3.10] Ensure Bluetooth Sharing is Disabled (Automated)"
/usr/bin/defaults -currentHost read com.apple.Bluetooth PrefKeyServicesEnabled 2>/dev/null || echo " (No value)"
echo "  Expected: 0"
echo

echo "[2.3.3.11] Computer Name does NOT contain PII/Protected info (Manual)"
/usr/sbin/scutil --get ComputerName 2>/dev/null || true
echo " Review against org policy."
echo

# 2.3.4 Time Machine
echo "[2.3.4.1] Ensure 'Backup Automatically' is Enabled if Time Machine is Enabled (Automated)"
/usr/bin/tmutil destinationinfo 2>/dev/null || echo "  (No TM destination configured or restricted)"
echo

echo "[2.3.4.2] Ensure Time Machine Volumes are Encrypted if TM Enabled (Automated)"
/usr/bin/tmutil destinationinfo 2>/dev/null | /usr/bin/grep -i Encrypted || echo "  (No TM destination or no Encrypted line)"
echo

# 2.4 Control Center
echo "[2.4.1] Ensure 'Show Wi-Fi status in Menu Bar' is Enabled (Automated via profile)"
/usr/bin/profiles -P -o stdout | /usr/bin/grep -i com.apple.controlcenter -A3 | /usr/bin/grep -i WiFi || echo "  (Check in UI or profile payload.)"
echo

echo "[2.4.2] Ensure 'Show Bluetooth status in Menu Bar' is Enabled (Automated via profile)"
/usr/bin/profiles -P -o stdout | /usr/bin/grep -i com.apple.controlcenter -A3 | /usr/bin/grep -i Bluetooth || echo "  (Check in UI or profile payload.)"
echo

# 2.5 Apple Intelligence & Siri
echo "[2.5.1.x] Apple Intelligence — External Extensions, Writing Tools, Mail/Notes Summarization (Automated via profile)"
echo " NOTE: As of macOS 15.0.1, first-party features may be pending; the Benchmark advises org risk review."
echo " Check profiles for restrictions disabling 3rd-party integrations/invocations."
# Benchmark note on Apple Intelligence being pending and recommending disabling 3rd-party integrations until DLP controls eval.
# 
echo

echo "[2.5.2.1] Ensure Siri is Disabled (Automated)"
echo "  Check via profile/UI. Terminal-only audit is not always reliable across versions."
/usr/bin/profiles -P -o stdout | /usr/bin/grep -Ei 'com.apple.Siri|assistant' -A3 || true
echo

echo "[2.5.2.2] Ensure 'Listen for Siri' is Disabled (Manual)"
echo "  GUI: System Settings > Siri & Spotlight > Listen for 'Siri' (Off)."
echo

# 2.6 Privacy & Security
echo "[2.6.1.1] Ensure Location Services is Enabled (Automated)"
echo "  NOTE: Auditing locationd DB typically requires elevated/system context; results may vary."
/usr/bin/sudo /usr/bin/defaults read /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.plist LocationServicesEnabled 2>/dev/null || echo "  (Unable to read; SIP/permissions or file path change)"
echo

echo "[2.6.1.2] Ensure 'Show Location Icon in Control Center when System Services request location' is Enabled (Automated via profile/UI)"
/usr/bin/profiles -P -o stdout | /usr/bin/grep -Ei 'Location(Menu|Status|Icon)' -A2 || true
echo

echo "[2.6.1.3] Audit Location Services Access (Manual)"
echo "  GUI: System Settings > Privacy & Security > Location Services — review per app."
echo

echo "[2.6.2.1] Audit Full Disk Access for Applications (Manual)"
echo "  GUI: System Settings > Privacy & Security > Full Disk Access."
echo

echo "[2.6.3.1] Ensure 'Share Mac Analytics' is Disabled (Automated)"
/usr/bin/defaults read /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit 2>/dev/null || echo "  (No key)"
echo

echo "[2.6.3.2] Ensure 'Improve Siri & Dictation' is Disabled (Automated)"
/usr/bin/defaults read com.apple.assistant.support 'UseSiri' 2>/dev/null || echo "  (No key; may be profile/GUI only)"
echo

echo "[2.6.3.3] Ensure 'Improve Assistive Voice Features' is Disabled (Automated via profile/UI)"
/usr/bin/profiles -P -o stdout | /usr/bin/grep -Ei 'Assistive|Voice' -A2 || true
echo

echo "[2.6.3.4] Ensure 'Share with app developers' is Disabled (Automated)"
/usr/bin/defaults read /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist ThirdPartyDataSubmit 2>/dev/null || echo "  (No key)"
echo

echo "[2.6.3.5] Ensure Share iCloud Analytics is Disabled (Manual)"
echo "  GUI: System Settings > Privacy & Security > Analytics & Improvements."
echo

echo "[2.6.4] Ensure Limit Ad Tracking is Enabled (Automated)"
/usr/bin/defaults read com.apple.AdLib allowApplePersonalizedAdvertising 2>/dev/null || echo "  (No key)"
echo "  Expected: 0 (disallow personalized ads)."
echo

echo "[2.6.5] Ensure Gatekeeper is Enabled (Automated)"
/usr/sbin/spctl --status || true
echo "  Expected: assessments enabled"
echo

echo "[2.6.6] Ensure FileVault is Enabled (Automated)"
/usr/bin/fdesetup status
echo

echo "[2.6.7] Audit Lockdown Mode (Manual)"
echo "  GUI: System Settings > Privacy & Security > Lockdown Mode — per org policy."
echo

echo "[2.6.8] Ensure an Administrator Password is Required to access System-wide Preferences (Automated)"
# Per Benchmark, use authdb reads; note about not prefixing sudo on the array variable applies.
#  
authDBs=("system.preferences" "system.preferences.energysaver" "system.preferences.network" "system.preferences.printing" "system.preferences.sharing" "system.preferences.softwareupdate" "system.preferences.startupdisk" "system.preferences.timemachine")
result="1"
for section in ${authDBs[@]}; do
  shared=$(/usr/bin/security -q authorizationdb read "$section" | /usr/bin/xmllint -xpath 'name(//*[contains(text(), "shared")]/following-sibling::*[1])' - 2>/dev/null || echo "")
  group=$(/usr/bin/security -q authorizationdb read "$section" | /usr/bin/xmllint -xpath '//*[contains(text(), "group")]/following-sibling::*[1]/text()' - 2>/dev/null || echo "")
  authuser=$(/usr/bin/security -q authorizationdb read "$section" | /usr/bin/xmllint -xpath 'name(//*[contains(text(), "authenticate-user")]/following-sibling::*[1])' - 2>/dev/null || echo "")
  sessionowner=$(/usr/bin/security -q authorizationdb read "$section" | /usr/bin/xmllint -xpath 'name(//*[contains(text(), "session-owner")]/following-sibling::*[1])' - 2>/dev/null || echo "")
  if [[ "$shared" != "false" || "$group" != "admin" || "$authuser" != "true" || "$sessionowner" != "false" ]]; then
    result="0"
  fi
done
echo "  authdb result: $result  (1=compliant, 0=not compliant)"
echo

# 2.7 Desktop & Dock
echo "[2.7.1] Ensure Screen Saver Corners are Secure (Automated — profile required)"
/usr/bin/profiles -P -o stdout | /usr/bin/grep -Ec '"wvous-bl-corner" = 6|"wvous-br-corner" = 6|"wvous-tl-corner" = 6|"wvous-tr-corner" = 6'
# CIS: Terminal audit counts corners set to 6 (Disable Screen Saver) — should be 0 to be compliant
# 
echo "  Expect 0."
echo

echo "[2.7.2] Audit iPhone Mirroring (Manual)"
echo

# 2.8 Displays
echo "[2.8.1] Audit Universal Control Settings (Manual)"
echo

# 2.9 Spotlight
echo "[2.9.1] Ensure 'Help Apple Improve Search' is Disabled (Manual)"
echo

# 2.10 Battery (Energy Saver)
echo "[2.10.1.1] Intel: Ensure OS is not Active when Resuming from Standby (Manual)"
echo
echo "[2.10.1.2] Apple Silicon: Ensure Sleep & Display Sleep Enabled (Automated)"
/usr/bin/pmset -g | /usr/bin/grep -E 'sleep|displaysleep'
echo
echo "[2.10.2] Ensure Power Nap is Disabled for Intel Macs (Automated)"
/usr/bin/pmset -g | /usr/bin/grep -i powernap || true
echo
echo "[2.10.3] Ensure Wake for Network Access is Disabled (Automated)"
/usr/bin/pmset -g | /usr/bin/grep -i womp || true
echo

# 2.11 Lock Screen
echo "[2.11.1] Ensure Screen Saver activates ≤ 15 minutes (Automated)"
/usr/bin/defaults -currentHost read com.apple.screensaver idleTime 2>/dev/null || echo "  (No key)"
echo "  Expected: <= 900 seconds"
echo
echo "[2.11.2] Ensure 'Require password' after screen saver/display off is 5s or immediately (Automated)"
/usr/bin/defaults read com.apple.screensaver askForPassword 2>/dev/null || echo "  (No key)"
/usr/bin/defaults read com.apple.screensaver askForPasswordDelay 2>/dev/null || echo "  (No key)"
echo
echo "[2.11.3] Ensure a Custom Login Window Message is Enabled (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText 2>/dev/null || echo "  (No key)"
echo
echo "[2.11.4] Ensure Login Window Displays as Name and Password (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow SHOWFULLNAME 2>/dev/null || echo "  (No key)"
echo
echo "[2.11.5] Ensure Show Password Hints is Disabled (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow RetriesUntilHint 2>/dev/null || echo "  (No key)"
echo

# 2.12 Touch ID & Password
echo "[2.12.1] Ensure Users' Accounts do NOT have a Password Hint (Automated)"
/usr/bin/dscl . -list /Users | while read u; do /usr/bin/dscl . -read /Users/"$u" hint 2>/dev/null && echo "  HINT PRESENT for $u"; done
echo
echo "[2.12.2] Audit Touch ID (Manual)"
echo

# 2.13 Users & Groups
echo "[2.13.1] Ensure Guest Account is Disabled (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow GuestEnabled 2>/dev/null || echo "  (No key -> often disabled)"
echo
echo "[2.13.2] Ensure Guest Access to Shared Folders is Disabled (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.AppleFileServer guestAccess 2>/dev/null || echo "  (No AFP guestAccess key)"
/usr/bin/defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess 2>/dev/null || echo "  (No SMB AllowGuestAccess key)"
echo
echo "[2.13.3] Ensure Automatic Login is Disabled (Automated)"
/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser 2>/dev/null && echo "  autoLoginUser set" || echo "  No autoLoginUser (good)"
echo

# 2.14 Game Center
echo "[2.14.1] Audit Game Center Settings (Manual)"
echo

# 2.15 Notifications
echo "[2.15.1] Audit Notification Settings (Manual)"
echo

# 2.16 Wallet & Apple Pay
echo "[2.16.1] Audit Wallet & Apple Pay Settings (Manual)"
echo

# 2.17 Internet Accounts
echo "[2.17.1] Audit Internet Accounts for Authorized Use (Manual)"
echo

# 2.18 Keyboard
echo "[2.18.1] Ensure On-Device Dictation is Enabled (Automated)"
/usr/bin/defaults read com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMMasterDictationEnabled 2>/dev/null || echo "  (No key)"
echo

hr
echo "Section 2 audit complete."
