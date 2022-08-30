build: export GOOS=darwin
build: export GOARCH=arm64
build:
	go build -o ./Kannada\ Bible.app/Contents/MacOS/kannada-bible
