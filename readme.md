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
flutter run
firebase emulators:start
```

## Test

```agsl
flutter test
```

## Deploy

```agsl
flutter build web
firebase deploy
```

## Web

```agsl
https://onlybible.app
```

## Bugs

1. Swipe left should pop context if chapter/book index is previous to the current one to maintain scroll history.

## Todo

1. Figure out history
2. Add more text options compact/loose, line spacing
3. Backups (File, Google Drive)
4. Add Next/Prev/Home in bottom navigation as optional for mobile users