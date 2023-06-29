import webview from "@suchipi/webview";
webview.spawn({
  title: "Bible App",
  width: 1024,
  height: 768,
  dir: "dist",
  cwd: process.cwd(),
});