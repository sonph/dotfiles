#!/bin/bash

if [[ $(uname) != "Darwin" ]]; then
  echo "This script only works on macOS"
  exit 0
fi

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <app> <width> <height>"
  echo "Example: $0 Chrome 1200 800"
  exit 0
fi

APP="$1"
WIDTH="$2"
HEIGHT="$3"

TMP_FILE="$PWD/.resize.AppleScript"

cat << END >> "$TMP_FILE"
set theApp to "${APP}"
set appHeight to ${HEIGHT}
set appWidth to ${WIDTH}

tell application "Finder"
	set screenResolution to bounds of window of desktop
end tell

set screenWidth to item 3 of screenResolution
set screenHeight to item 4 of screenResolution

tell application theApp
	activate
	reopen
	set yAxis to (screenHeight - appHeight) / 2 as integer
	set xAxis to (screenWidth - appWidth) / 2 as integer
	set the bounds of the first window to {xAxis, yAxis, appWidth + xAxis, appHeight + yAxis}
end tell
END

osascript "$TMP_FILE"
rm -f "$TMP_FILE"
