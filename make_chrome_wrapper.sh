#!/bin/bash
PROFILE_NAME=$1
APP_FOLDER="$HOME/Applications/Chrome Wrappers/$1.app"
echo "Creating $1.app at $APP_FOLDER"
mkdir -p "$APP_FOLDER/Contents/MacOS"
mkdir -p "$APP_FOLDER/Contents/Resources"

echo "APPL????" >> "$APP_FOLDER/Contents/PkgInfo"
INFO_FILENAME="$APP_FOLDER/Contents/Info.plist"
cat > "$INFO_FILENAME" <<\EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleExecutable</key>
	<string>wrapper.sh</string>
	<key>CFBundleIconFile</key>
	<string>app.icns</string>
</dict>
</plist>
EOF

WRAPPER_FILENAME="$APP_FOLDER/Contents/MacOS/wrapper.sh"

echo "PROFILE_NAME='$PROFILE_NAME'\n" >> "$WRAPPER_FILENAME"
cat > "$WRAPPER_FILENAME" <<\EOF
#!/bin/bash
# Find the Google Chrome binary:
CHOME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

exec "$CHOME_BIN" --user-data-dir="$HOME/chrome_profiles/$PROFILE_NAME" --restore-last-session --no-default-browser-check --no-first-run "$@"
EOF
sed -i '' "s*\$PROFILE_NAME*$PROFILE_NAME*g" "$WRAPPER_FILENAME"
sed -i '' "s*\$HOME*$HOME*g" "$WRAPPER_FILENAME"

chmod +x "$WRAPPER_FILENAME"

if [ "$2" ]; then
  echo "Copy icon to app"
  cp $2 "$APP_FOLDER/Contents/Resources/app.icns"
fi

# Create alias with parameters
BIN_FILENAME="$HOME/bin/c_$PROFILE_NAME"
cat > "$BIN_FILENAME" <<\EOF
#!/bin/bash
open "$APP_FOLDER" --args "$@"
EOF
sed -i '' "s+\$APP_FOLDER+$APP_FOLDER+g" "$BIN_FILENAME"

chmod +x "$BIN_FILENAME"
