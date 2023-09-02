part of "bible_bloc.dart";

@freezed
class BibleEvent with _$BibleEvent {
  const factory BibleEvent.firstLoad() = NoBible;
  const factory BibleEvent.load(String name) = LoadBible;
}
