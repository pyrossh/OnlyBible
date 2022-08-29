setup:
	brew install create-dmg

build: export GOOS=darwin
build: export GOARCH=arm64
build:
	go build -o ./Kannada\ Bible.app/Contents/MacOS/kannada-bible

bundle:
	create-dmg --hdiutil-quiet --hide-extension "Kannada Bible"  --volname "Kannada Bible" --window-size 660 400 --icon "Kannada Bible" 180 170 --app-drop-link 480 170 "Kannada Bible.dmg" "Kannada Bible.app"
