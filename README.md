# Only Bible App

Fix dialog theme

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
1. Fix verse number layout flow
2. Swipe left should pop context if chapter/book index is previous to the current one to maintain scroll history.
3. Reduce verse line spacing

## Todo
1. Add Sqlite for highlighting, notes, chapter verses
2. Custom Selection should show action bar instead of tooltip/popup menu 
3. Figure out history
4. Add more text compact/loose maybe spacing