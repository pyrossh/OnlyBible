# Only Bible App

The only bible app you will ever need.

No ads, No in-app purchases, No distractions.

Offline First

Optimized reading

Online Audio Playback

## Setup

```agsl
brew install fastlane
```

For emulators,
1. Turn on developer options
2. Disable HW overlays in those options

## iOS

* Make sure you've added a Distribution certificate to the system keystore and download it and install it
* Make sure you create an App Store provisioning profile for this certificate and download it and install it
* Add you Apple Developer Team account in xCode and open ios/Runner.xcworkspace and under Runner Project,
* Runner Target, Signing Tab, Release Tab, select that provisioning profile and Team and Certificate.

## TODO
1. Fix Long chapter name (Thessalonians) where menu button shrinks
2. Add locales in the resources/localeList or app definition