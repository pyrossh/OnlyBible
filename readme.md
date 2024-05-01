# Only Bible App

The only bible app you will ever need.

No ads, No in-app purchases, No distractions.

Optimized for reading and highlighting.
Only Bibles which are in the public domain are available.
Verse by verse audio is also supported for some of the languages generated using Azure TTS.

### Languages Supported

| Language  | Audio |
|-----------|:-----:|
| Bengali   |   ✅   |
| English   |   ✅   |
| Gujarati  |   ✅   |
| Hindi     |   ✅   |
| Kannada   |   ✅   |
| Malayalam |   ✅   |
| Nepali    |   ✅   |
| Oriya     |   ❌   |
| Punjabi   |   ❌   |
| Tamil     |   ✅   |
| Telugu    |   ✅   |

## Setup

```agsl
brew install fluttter cocoapods
```

## Lint

```agsl
dart fix --apply
dart format lib
```

## Update icons

```agsl
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Run

```agsl
flutter clean
flutter run --dart-define-from-file=.env
```

## IntelliJ IDE
Add additional run arguments `--dart-define-from-file=.env`

## Test

```agsl
flutter test
```

## Web

```agsl
https://onlybible.app
```


## Release Process
Increment the patch/minor version in pubspec.yaml for iOS  ex: 1.0.7
Increment versionCode in pubspec.yaml for android  ex: +9

### android

```
flutter build appbundle --release --dart-define-from-file=.env

# copy file from build/app/outputs/bundle/release/app-release.aab
```

### iOS

Make sure you've added a Distribution certificate to the system keystore and download it and install it
Make sure you create an App Store provisioning profile for this certificate and download it and install it
Add you Apple Developer Team account in xCode and open ios/Runner.xcworkspace and under Runner Project,
Runner Target, Signing Tab, Release Tab, select that provisioning profile and Team and Certificate.

```
flutter build ipa --release --dart-define-from-file=.env
```

## Bugs

1. Swipe left should pop context if chapter/book index is previous to the current one to maintain scroll history.

## Todo

1. Figure out history
2. Add more text options compact/loose, line spacing
4. Add Next/Prev/Home in bottom navigation as optional for mobile users