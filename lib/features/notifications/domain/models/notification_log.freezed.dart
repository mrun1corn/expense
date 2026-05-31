// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationLog _$NotificationLogFromJson(Map<String, dynamic> json) {
  return _NotificationLog.fromJson(json);
}

/// @nodoc
mixin _$NotificationLog {
  String get id => throw _privateConstructorUsedError;
  String get patternId =>
      throw _privateConstructorUsedError; // which pattern triggered this (can be empty for non-pattern alerts)
  NotificationType get type => throw _privateConstructorUsedError;
  DateTime get firedAt => throw _privateConstructorUsedError;
  UserResponse get response =>
      throw _privateConstructorUsedError; // tapped | dismissed | quickAdded | customAdded | ignored
  double? get addedAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationLogCopyWith<NotificationLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationLogCopyWith<$Res> {
  factory $NotificationLogCopyWith(
          NotificationLog value, $Res Function(NotificationLog) then) =
      _$NotificationLogCopyWithImpl<$Res, NotificationLog>;
  @useResult
  $Res call(
      {String id,
      String patternId,
      NotificationType type,
      DateTime firedAt,
      UserResponse response,
      double? addedAmount});
}

/// @nodoc
class _$NotificationLogCopyWithImpl<$Res, $Val extends NotificationLog>
    implements $NotificationLogCopyWith<$Res> {
  _$NotificationLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patternId = null,
    Object? type = null,
    Object? firedAt = null,
    Object? response = null,
    Object? addedAmount = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patternId: null == patternId
          ? _value.patternId
          : patternId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      firedAt: null == firedAt
          ? _value.firedAt
          : firedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as UserResponse,
      addedAmount: freezed == addedAmount
          ? _value.addedAmount
          : addedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationLogImplCopyWith<$Res>
    implements $NotificationLogCopyWith<$Res> {
  factory _$$NotificationLogImplCopyWith(_$NotificationLogImpl value,
          $Res Function(_$NotificationLogImpl) then) =
      __$$NotificationLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String patternId,
      NotificationType type,
      DateTime firedAt,
      UserResponse response,
      double? addedAmount});
}

/// @nodoc
class __$$NotificationLogImplCopyWithImpl<$Res>
    extends _$NotificationLogCopyWithImpl<$Res, _$NotificationLogImpl>
    implements _$$NotificationLogImplCopyWith<$Res> {
  __$$NotificationLogImplCopyWithImpl(
      _$NotificationLogImpl _value, $Res Function(_$NotificationLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patternId = null,
    Object? type = null,
    Object? firedAt = null,
    Object? response = null,
    Object? addedAmount = freezed,
  }) {
    return _then(_$NotificationLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patternId: null == patternId
          ? _value.patternId
          : patternId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      firedAt: null == firedAt
          ? _value.firedAt
          : firedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as UserResponse,
      addedAmount: freezed == addedAmount
          ? _value.addedAmount
          : addedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationLogImpl implements _NotificationLog {
  const _$NotificationLogImpl(
      {required this.id,
      required this.patternId,
      required this.type,
      required this.firedAt,
      required this.response,
      this.addedAmount});

  factory _$NotificationLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationLogImplFromJson(json);

  @override
  final String id;
  @override
  final String patternId;
// which pattern triggered this (can be empty for non-pattern alerts)
  @override
  final NotificationType type;
  @override
  final DateTime firedAt;
  @override
  final UserResponse response;
// tapped | dismissed | quickAdded | customAdded | ignored
  @override
  final double? addedAmount;

  @override
  String toString() {
    return 'NotificationLog(id: $id, patternId: $patternId, type: $type, firedAt: $firedAt, response: $response, addedAmount: $addedAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patternId, patternId) ||
                other.patternId == patternId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.firedAt, firedAt) || other.firedAt == firedAt) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.addedAmount, addedAmount) ||
                other.addedAmount == addedAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, patternId, type, firedAt, response, addedAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationLogImplCopyWith<_$NotificationLogImpl> get copyWith =>
      __$$NotificationLogImplCopyWithImpl<_$NotificationLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationLogImplToJson(
      this,
    );
  }
}

abstract class _NotificationLog implements NotificationLog {
  const factory _NotificationLog(
      {required final String id,
      required final String patternId,
      required final NotificationType type,
      required final DateTime firedAt,
      required final UserResponse response,
      final double? addedAmount}) = _$NotificationLogImpl;

  factory _NotificationLog.fromJson(Map<String, dynamic> json) =
      _$NotificationLogImpl.fromJson;

  @override
  String get id;
  @override
  String get patternId;
  @override // which pattern triggered this (can be empty for non-pattern alerts)
  NotificationType get type;
  @override
  DateTime get firedAt;
  @override
  UserResponse get response;
  @override // tapped | dismissed | quickAdded | customAdded | ignored
  double? get addedAmount;
  @override
  @JsonKey(ignore: true)
  _$$NotificationLogImplCopyWith<_$NotificationLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
