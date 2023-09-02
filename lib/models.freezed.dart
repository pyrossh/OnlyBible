// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Bible {
  String get name => throw _privateConstructorUsedError;
  List<Book> get books => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleCopyWith<Bible> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleCopyWith<$Res> {
  factory $BibleCopyWith(Bible value, $Res Function(Bible) then) =
      _$BibleCopyWithImpl<$Res, Bible>;
  @useResult
  $Res call({String name, List<Book> books});
}

/// @nodoc
class _$BibleCopyWithImpl<$Res, $Val extends Bible>
    implements $BibleCopyWith<$Res> {
  _$BibleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? books = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      books: null == books
          ? _value.books
          : books // ignore: cast_nullable_to_non_nullable
              as List<Book>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BibleCopyWith<$Res> implements $BibleCopyWith<$Res> {
  factory _$$_BibleCopyWith(_$_Bible value, $Res Function(_$_Bible) then) =
      __$$_BibleCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<Book> books});
}

/// @nodoc
class __$$_BibleCopyWithImpl<$Res> extends _$BibleCopyWithImpl<$Res, _$_Bible>
    implements _$$_BibleCopyWith<$Res> {
  __$$_BibleCopyWithImpl(_$_Bible _value, $Res Function(_$_Bible) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? books = null,
  }) {
    return _then(_$_Bible(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      books: null == books
          ? _value._books
          : books // ignore: cast_nullable_to_non_nullable
              as List<Book>,
    ));
  }
}

/// @nodoc

class _$_Bible extends _Bible {
  const _$_Bible({required this.name, required final List<Book> books})
      : _books = books,
        super._();

  @override
  final String name;
  final List<Book> _books;
  @override
  List<Book> get books {
    if (_books is EqualUnmodifiableListView) return _books;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_books);
  }

  @override
  String toString() {
    return 'Bible(name: $name, books: $books)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Bible &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._books, _books));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_books));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BibleCopyWith<_$_Bible> get copyWith =>
      __$$_BibleCopyWithImpl<_$_Bible>(this, _$identity);
}

abstract class _Bible extends Bible {
  const factory _Bible(
      {required final String name, required final List<Book> books}) = _$_Bible;
  const _Bible._() : super._();

  @override
  String get name;
  @override
  List<Book> get books;
  @override
  @JsonKey(ignore: true)
  _$$_BibleCopyWith<_$_Bible> get copyWith =>
      throw _privateConstructorUsedError;
}
