package main

import (
	"embed"
	"net/http"

	"github.com/webview/webview"
)

//go:embed assets/*
var assets embed.FS

func main() {
	println("http server listening on http://localhost:3005")
	http.Handle("/", http.StripPrefix("/", http.FileServer(http.FS(assets))))
	go http.ListenAndServe(":3005", nil)
	w := webview.New(false)
	defer w.Destroy()
	w.SetTitle("Kannada Bible")
	w.SetSize(1280, 720, webview.HintNone)
	w.Navigate("http://localhost:3005/assets")
	w.Run()
}
