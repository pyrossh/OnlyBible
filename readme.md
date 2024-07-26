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


## Release Process
* Create file fastlane/metadata/android/en-GB/changelogs/$versionCode.txt and add change details

### android

```
flutter build appbundle --release --dart-define-from-file=.env
fastlane supply --aab ../build/app/outputs/bundle/release/app-release.aab
```

### iOS

* Make sure you've added a Distribution certificate to the system keystore and download it and install it
* Make sure you create an App Store provisioning profile for this certificate and download it and install it
* Add you Apple Developer Team account in xCode and open ios/Runner.xcworkspace and under Runner Project,
* Runner Target, Signing Tab, Release Tab, select that provisioning profile and Team and Certificate.

```
flutter build ipa --release --dart-define-from-file=.env
fastlane deliver  --ipa "../build/ios/ipa/only-bible-app.ipa" --automatic_release --submit_for_review
```
