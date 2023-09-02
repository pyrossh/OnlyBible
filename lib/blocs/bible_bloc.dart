import "package:bloc/bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/state.dart";

part "bible_bloc.freezed.dart";

part "bible_event.dart";

part "bible_state.dart";

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  final String? bibleName;
  BibleBloc(this.bibleName) : super(const _Loading()) {
    on<NoBible>((event, emit) {
      emit(const _Loading());
    });
    on<LoadBible>((event, emit) async {
      try {
        emit(const _Loading());
        final bible = await loadBible(event.name);
        emit(_Success(bible!));
      } catch (e) {
        emit(const _Error());
      }
    });
  }
}
