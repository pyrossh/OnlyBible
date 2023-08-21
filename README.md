# Only Bible App

The only bible app you will ever need. No ads, No in-app purchases, No distractions.
Optimized for reading and highlighting.
Just the bibles which are freely available in the public domain.
Verse by verse audio is also supported for some of the languages generated using Azure TTS.

Most of the major Indian languages are supported such as Hindi, Kannada, Tamil, Malayalam, Nepali.

## Setup

```agsl
brew install fluttter cocoapods firebase-cli
```

## Lint

```agsl
dart fix --apply
dart format lib
```

## Build

```agsl
dart pub global activate flutterfire_cli
flutterfire configure --project=only-bible-app
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
https://only-bible-app.web.app
https://only-bible-app.firebaseapp.com/
https://onlybible.app
```

## Sync audio files

```agsl
gsutil -m cp -r scripts/audio/Kannada gs://only-bible-app.appspot.com/
```

Note:
> For crashanalytics to work in dev/debug mode in macos this has to be set DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";

## Bugs
1. Swipe left should pop context if chapter/book index is previous to the current one to maintain scroll history.

## Todo

1. Figure out history
2. Add more text options compact/loose, line spacing