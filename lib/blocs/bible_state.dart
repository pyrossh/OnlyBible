part of "bible_bloc.dart";

@freezed
class BibleState with _$BibleState {
  const factory BibleState.loading() = _Loading;
  const factory BibleState.success(Bible bible) = _Success;
  const factory BibleState.error() = _Error;
}