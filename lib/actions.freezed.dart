// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'actions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppAction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() firstOpenDone,
    required TResult Function(String code) setLanguageCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? firstOpenDone,
    TResult? Function(String code)? setLanguageCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? firstOpenDone,
    TResult Function(String code)? setLanguageCode,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FirstOpenDone value) firstOpenDone,
    required TResult Function(SetLanguageCode value) setLanguageCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FirstOpenDone value)? firstOpenDone,
    TResult? Function(SetLanguageCode value)? setLanguageCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FirstOpenDone value)? firstOpenDone,
    TResult Function(SetLanguageCode value)? setLanguageCode,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppActionCopyWith<$Res> {
  factory $AppActionCopyWith(AppAction value, $Res Function(AppAction) then) =
      _$AppActionCopyWithImpl<$Res, AppAction>;
}

/// @nodoc
class _$AppActionCopyWithImpl<$Res, $Val extends AppAction>
    implements $AppActionCopyWith<$Res> {
  _$AppActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$FirstOpenDoneCopyWith<$Res> {
  factory _$$FirstOpenDoneCopyWith(
          _$FirstOpenDone value, $Res Function(_$FirstOpenDone) then) =
      __$$FirstOpenDoneCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FirstOpenDoneCopyWithImpl<$Res>
    extends _$AppActionCopyWithImpl<$Res, _$FirstOpenDone>
    implements _$$FirstOpenDoneCopyWith<$Res> {
  __$$FirstOpenDoneCopyWithImpl(
      _$FirstOpenDone _value, $Res Function(_$FirstOpenDone) _then)
      : super(_value, _then);
}

/// @nodoc

class _$FirstOpenDone implements FirstOpenDone {
  const _$FirstOpenDone();

  @override
  String toString() {
    return 'AppAction.firstOpenDone()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FirstOpenDone);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() firstOpenDone,
    required TResult Function(String code) setLanguageCode,
  }) {
    return firstOpenDone();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? firstOpenDone,
    TResult? Function(String code)? setLanguageCode,
  }) {
    return firstOpenDone?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? firstOpenDone,
    TResult Function(String code)? setLanguageCode,
    required TResult orElse(),
  }) {
    if (firstOpenDone != null) {
      return firstOpenDone();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FirstOpenDone value) firstOpenDone,
    required TResult Function(SetLanguageCode value) setLanguageCode,
  }) {
    return firstOpenDone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FirstOpenDone value)? firstOpenDone,
    TResult? Function(SetLanguageCode value)? setLanguageCode,
  }) {
    return firstOpenDone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FirstOpenDone value)? firstOpenDone,
    TResult Function(SetLanguageCode value)? setLanguageCode,
    required TResult orElse(),
  }) {
    if (firstOpenDone != null) {
      return firstOpenDone(this);
    }
    return orElse();
  }
}

abstract class FirstOpenDone implements AppAction {
  const factory FirstOpenDone() = _$FirstOpenDone;
}

/// @nodoc
abstract class _$$SetLanguageCodeCopyWith<$Res> {
  factory _$$SetLanguageCodeCopyWith(
          _$SetLanguageCode value, $Res Function(_$SetLanguageCode) then) =
      __$$SetLanguageCodeCopyWithImpl<$Res>;
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$SetLanguageCodeCopyWithImpl<$Res>
    extends _$AppActionCopyWithImpl<$Res, _$SetLanguageCode>
    implements _$$SetLanguageCodeCopyWith<$Res> {
  __$$SetLanguageCodeCopyWithImpl(
      _$SetLanguageCode _value, $Res Function(_$SetLanguageCode) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
  }) {
    return _then(_$SetLanguageCode(
      null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SetLanguageCode implements SetLanguageCode {
  const _$SetLanguageCode(this.code);

  @override
  final String code;

  @override
  String toString() {
    return 'AppAction.setLanguageCode(code: $code)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetLanguageCode &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetLanguageCodeCopyWith<_$SetLanguageCode> get copyWith =>
      __$$SetLanguageCodeCopyWithImpl<_$SetLanguageCode>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() firstOpenDone,
    required TResult Function(String code) setLanguageCode,
  }) {
    return setLanguageCode(code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? firstOpenDone,
    TResult? Function(String code)? setLanguageCode,
  }) {
    return setLanguageCode?.call(code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? firstOpenDone,
    TResult Function(String code)? setLanguageCode,
    required TResult orElse(),
  }) {
    if (setLanguageCode != null) {
      return setLanguageCode(code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FirstOpenDone value) firstOpenDone,
    required TResult Function(SetLanguageCode value) setLanguageCode,
  }) {
    return setLanguageCode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FirstOpenDone value)? firstOpenDone,
    TResult? Function(SetLanguageCode value)? setLanguageCode,
  }) {
    return setLanguageCode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FirstOpenDone value)? firstOpenDone,
    TResult Function(SetLanguageCode value)? setLanguageCode,
    required TResult orElse(),
  }) {
    if (setLanguageCode != null) {
      return setLanguageCode(this);
    }
    return orElse();
  }
}

abstract class SetLanguageCode implements AppAction {
  const factory SetLanguageCode(final String code) = _$SetLanguageCode;

  String get code;
  @JsonKey(ignore: true)
  _$$SetLanguageCodeCopyWith<_$SetLanguageCode> get copyWith =>
      throw _privateConstructorUsedError;
}
