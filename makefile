setup:
	cargo install cross --git https://github.com/cross-rs/cross

build:
	go build -o ./Kannada\ Bible.app/Contents/MacOS/kannada-bible
