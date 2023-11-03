#!/usr/bin/env bash
clear
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo Testing for network connection, please wait..
Sleep 2
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo Network connection found, starting script
  Sleep 1
else
  read -rsp $'No network connection found, press any key to exit script. \n' -n1 key
  exit 
fi
echo Removing old version
rm -rf "/Applications/HCS Remote Support.app"


echo Downloading Teamviewer.. 
curl --silent https://customdesignservice.teamviewer.com/download/mac/v15/2refr8j/TeamViewerQS.zip --output /tmp/hcs.zip


sleep 3
echo Extracting files to Application folder
open -W /tmp/hcs.zip 
sleep 5

mv -f /tmp/*.app "/Applications/HCS Remote Support.app"
cp -af "$SCRIPT_DIR"/hcs.icns "/Applications/HCS Remote Support.app/Contents/Resources/AppIcon.icns"
sleep 3 

echo Opening and closing app to validate signature
open "/Applications/HCS Remote Support.app"
pkill -x "HCS Remote Support"
echo Editing application plist to change icon
sed -i '' 's/AppIcon/AppIcon.icns/g' "/Applications/HCS Remote Support.app/Contents/Info.plist"
touch "/Applications/HCS Remote Support.app"
echo Refreshing icon cache..
open "/Applications/HCS Remote Support.app"


echo Tidying up..
rm -rf /tmp/*.zip 
rm -rf /tmp/*.app
echo Pinning HCS Remote to Dock
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/HCS Remote Support.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
killall cfprefsd 
killall Dock




read -rsp $'Script complete, press any key to exit..\n' -n1 key
clear 
exit