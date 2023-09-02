import "package:freezed_annotation/freezed_annotation.dart";
part "actions.freezed.dart";

@freezed
class AppAction with _$AppAction {
  const factory AppAction.firstOpenDone() = FirstOpenDone;
  const factory AppAction.setLanguageCode(String code) = SetLanguageCode;
}