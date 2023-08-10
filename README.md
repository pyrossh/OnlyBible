# Only Bible App

A new Flutter project.

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
flutter pub run change_app_package_name:main com.new.package.name
```

## Run
```agsl
flutter clean
flutter run
```