# Only Bible App

minSdkVersion 30
targetSdkVersion 34

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
flutter pub run flutter_launcher_icons
```

## Run
```agsl
flutter clean
flutter run
```