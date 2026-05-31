// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending_pattern.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpendingPattern _$SpendingPatternFromJson(Map<String, dynamic> json) {
  return _SpendingPattern.fromJson(json);
}

/// @nodoc
mixin _$SpendingPattern {
  String get id => throw _privateConstructorUsedError;
  PatternType get type => throw _privateConstructorUsedError;
  ExpenseCategory get category => throw _privateConstructorUsedError;
  double get typicalAmount => throw _privateConstructorUsedError;
  int get occurrences => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  DateTime get firstSeen => throw _privateConstructorUsedError;
  DateTime get lastSeen => throw _privateConstructorUsedError;
  DateTime get detectedAt => throw _privateConstructorUsedError;
  double? get amountTolerance => throw _privateConstructorUsedError;
  int? get timeSlotHour => throw _privateConstructorUsedError;
  int? get timeSlotWindowMinutes => throw _privateConstructorUsedError;
  int? get dayOfWeek => throw _privateConstructorUsedError;
  int? get dayOfMonth =>
      throw _privateConstructorUsedError; // for monthly patterns
  bool get notificationScheduled => throw _privateConstructorUsedError;
  bool get isDismissed => throw _privateConstructorUsedError;
  bool get isConfirmed =>
      throw _privateConstructorUsedError; // user tapped "Yes, remind me"
  DateTime? get nextScheduledAt => throw _privateConstructorUsedError;
  int? get notificationId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpendingPatternCopyWith<SpendingPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendingPatternCopyWith<$Res> {
  factory $SpendingPatternCopyWith(
          SpendingPattern value, $Res Function(SpendingPattern) then) =
      _$SpendingPatternCopyWithImpl<$Res, SpendingPattern>;
  @useResult
  $Res call(
      {String id,
      PatternType type,
      ExpenseCategory category,
      double typicalAmount,
      int occurrences,
      double confidence,
      DateTime firstSeen,
      DateTime lastSeen,
      DateTime detectedAt,
      double? amountTolerance,
      int? timeSlotHour,
      int? timeSlotWindowMinutes,
      int? dayOfWeek,
      int? dayOfMonth,
      bool notificationScheduled,
      bool isDismissed,
      bool isConfirmed,
      DateTime? nextScheduledAt,
      int? notificationId});
}

/// @nodoc
class _$SpendingPatternCopyWithImpl<$Res, $Val extends SpendingPattern>
    implements $SpendingPatternCopyWith<$Res> {
  _$SpendingPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? typicalAmount = null,
    Object? occurrences = null,
    Object? confidence = null,
    Object? firstSeen = null,
    Object? lastSeen = null,
    Object? detectedAt = null,
    Object? amountTolerance = freezed,
    Object? timeSlotHour = freezed,
    Object? timeSlotWindowMinutes = freezed,
    Object? dayOfWeek = freezed,
    Object? dayOfMonth = freezed,
    Object? notificationScheduled = null,
    Object? isDismissed = null,
    Object? isConfirmed = null,
    Object? nextScheduledAt = freezed,
    Object? notificationId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PatternType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory,
      typicalAmount: null == typicalAmount
          ? _value.typicalAmount
          : typicalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      occurrences: null == occurrences
          ? _value.occurrences
          : occurrences // ignore: cast_nullable_to_non_nullable
              as int,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      firstSeen: null == firstSeen
          ? _value.firstSeen
          : firstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      detectedAt: null == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amountTolerance: freezed == amountTolerance
          ? _value.amountTolerance
          : amountTolerance // ignore: cast_nullable_to_non_nullable
              as double?,
      timeSlotHour: freezed == timeSlotHour
          ? _value.timeSlotHour
          : timeSlotHour // ignore: cast_nullable_to_non_nullable
              as int?,
      timeSlotWindowMinutes: freezed == timeSlotWindowMinutes
          ? _value.timeSlotWindowMinutes
          : timeSlotWindowMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationScheduled: null == notificationScheduled
          ? _value.notificationScheduled
          : notificationScheduled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDismissed: null == isDismissed
          ? _value.isDismissed
          : isDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      nextScheduledAt: freezed == nextScheduledAt
          ? _value.nextScheduledAt
          : nextScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpendingPatternImplCopyWith<$Res>
    implements $SpendingPatternCopyWith<$Res> {
  factory _$$SpendingPatternImplCopyWith(_$SpendingPatternImpl value,
          $Res Function(_$SpendingPatternImpl) then) =
      __$$SpendingPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PatternType type,
      ExpenseCategory category,
      double typicalAmount,
      int occurrences,
      double confidence,
      DateTime firstSeen,
      DateTime lastSeen,
      DateTime detectedAt,
      double? amountTolerance,
      int? timeSlotHour,
      int? timeSlotWindowMinutes,
      int? dayOfWeek,
      int? dayOfMonth,
      bool notificationScheduled,
      bool isDismissed,
      bool isConfirmed,
      DateTime? nextScheduledAt,
      int? notificationId});
}

/// @nodoc
class __$$SpendingPatternImplCopyWithImpl<$Res>
    extends _$SpendingPatternCopyWithImpl<$Res, _$SpendingPatternImpl>
    implements _$$SpendingPatternImplCopyWith<$Res> {
  __$$SpendingPatternImplCopyWithImpl(
      _$SpendingPatternImpl _value, $Res Function(_$SpendingPatternImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? typicalAmount = null,
    Object? occurrences = null,
    Object? confidence = null,
    Object? firstSeen = null,
    Object? lastSeen = null,
    Object? detectedAt = null,
    Object? amountTolerance = freezed,
    Object? timeSlotHour = freezed,
    Object? timeSlotWindowMinutes = freezed,
    Object? dayOfWeek = freezed,
    Object? dayOfMonth = freezed,
    Object? notificationScheduled = null,
    Object? isDismissed = null,
    Object? isConfirmed = null,
    Object? nextScheduledAt = freezed,
    Object? notificationId = freezed,
  }) {
    return _then(_$SpendingPatternImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PatternType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory,
      typicalAmount: null == typicalAmount
          ? _value.typicalAmount
          : typicalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      occurrences: null == occurrences
          ? _value.occurrences
          : occurrences // ignore: cast_nullable_to_non_nullable
              as int,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      firstSeen: null == firstSeen
          ? _value.firstSeen
          : firstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      detectedAt: null == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amountTolerance: freezed == amountTolerance
          ? _value.amountTolerance
          : amountTolerance // ignore: cast_nullable_to_non_nullable
              as double?,
      timeSlotHour: freezed == timeSlotHour
          ? _value.timeSlotHour
          : timeSlotHour // ignore: cast_nullable_to_non_nullable
              as int?,
      timeSlotWindowMinutes: freezed == timeSlotWindowMinutes
          ? _value.timeSlotWindowMinutes
          : timeSlotWindowMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationScheduled: null == notificationScheduled
          ? _value.notificationScheduled
          : notificationScheduled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDismissed: null == isDismissed
          ? _value.isDismissed
          : isDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      nextScheduledAt: freezed == nextScheduledAt
          ? _value.nextScheduledAt
          : nextScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpendingPatternImpl implements _SpendingPattern {
  const _$SpendingPatternImpl(
      {required this.id,
      required this.type,
      required this.category,
      required this.typicalAmount,
      required this.occurrences,
      required this.confidence,
      required this.firstSeen,
      required this.lastSeen,
      required this.detectedAt,
      this.amountTolerance,
      this.timeSlotHour,
      this.timeSlotWindowMinutes,
      this.dayOfWeek,
      this.dayOfMonth,
      this.notificationScheduled = false,
      this.isDismissed = false,
      this.isConfirmed = false,
      this.nextScheduledAt,
      this.notificationId});

  factory _$SpendingPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpendingPatternImplFromJson(json);

  @override
  final String id;
  @override
  final PatternType type;
  @override
  final ExpenseCategory category;
  @override
  final double typicalAmount;
  @override
  final int occurrences;
  @override
  final double confidence;
  @override
  final DateTime firstSeen;
  @override
  final DateTime lastSeen;
  @override
  final DateTime detectedAt;
  @override
  final double? amountTolerance;
  @override
  final int? timeSlotHour;
  @override
  final int? timeSlotWindowMinutes;
  @override
  final int? dayOfWeek;
  @override
  final int? dayOfMonth;
// for monthly patterns
  @override
  @JsonKey()
  final bool notificationScheduled;
  @override
  @JsonKey()
  final bool isDismissed;
  @override
  @JsonKey()
  final bool isConfirmed;
// user tapped "Yes, remind me"
  @override
  final DateTime? nextScheduledAt;
  @override
  final int? notificationId;

  @override
  String toString() {
    return 'SpendingPattern(id: $id, type: $type, category: $category, typicalAmount: $typicalAmount, occurrences: $occurrences, confidence: $confidence, firstSeen: $firstSeen, lastSeen: $lastSeen, detectedAt: $detectedAt, amountTolerance: $amountTolerance, timeSlotHour: $timeSlotHour, timeSlotWindowMinutes: $timeSlotWindowMinutes, dayOfWeek: $dayOfWeek, dayOfMonth: $dayOfMonth, notificationScheduled: $notificationScheduled, isDismissed: $isDismissed, isConfirmed: $isConfirmed, nextScheduledAt: $nextScheduledAt, notificationId: $notificationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendingPatternImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.typicalAmount, typicalAmount) ||
                other.typicalAmount == typicalAmount) &&
            (identical(other.occurrences, occurrences) ||
                other.occurrences == occurrences) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.firstSeen, firstSeen) ||
                other.firstSeen == firstSeen) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            (identical(other.amountTolerance, amountTolerance) ||
                other.amountTolerance == amountTolerance) &&
            (identical(other.timeSlotHour, timeSlotHour) ||
                other.timeSlotHour == timeSlotHour) &&
            (identical(other.timeSlotWindowMinutes, timeSlotWindowMinutes) ||
                other.timeSlotWindowMinutes == timeSlotWindowMinutes) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.dayOfMonth, dayOfMonth) ||
                other.dayOfMonth == dayOfMonth) &&
            (identical(other.notificationScheduled, notificationScheduled) ||
                other.notificationScheduled == notificationScheduled) &&
            (identical(other.isDismissed, isDismissed) ||
                other.isDismissed == isDismissed) &&
            (identical(other.isConfirmed, isConfirmed) ||
                other.isConfirmed == isConfirmed) &&
            (identical(other.nextScheduledAt, nextScheduledAt) ||
                other.nextScheduledAt == nextScheduledAt) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        type,
        category,
        typicalAmount,
        occurrences,
        confidence,
        firstSeen,
        lastSeen,
        detectedAt,
        amountTolerance,
        timeSlotHour,
        timeSlotWindowMinutes,
        dayOfWeek,
        dayOfMonth,
        notificationScheduled,
        isDismissed,
        isConfirmed,
        nextScheduledAt,
        notificationId
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendingPatternImplCopyWith<_$SpendingPatternImpl> get copyWith =>
      __$$SpendingPatternImplCopyWithImpl<_$SpendingPatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpendingPatternImplToJson(
      this,
    );
  }
}

abstract class _SpendingPattern implements SpendingPattern {
  const factory _SpendingPattern(
      {required final String id,
      required final PatternType type,
      required final ExpenseCategory category,
      required final double typicalAmount,
      required final int occurrences,
      required final double confidence,
      required final DateTime firstSeen,
      required final DateTime lastSeen,
      required final DateTime detectedAt,
      final double? amountTolerance,
      final int? timeSlotHour,
      final int? timeSlotWindowMinutes,
      final int? dayOfWeek,
      final int? dayOfMonth,
      final bool notificationScheduled,
      final bool isDismissed,
      final bool isConfirmed,
      final DateTime? nextScheduledAt,
      final int? notificationId}) = _$SpendingPatternImpl;

  factory _SpendingPattern.fromJson(Map<String, dynamic> json) =
      _$SpendingPatternImpl.fromJson;

  @override
  String get id;
  @override
  PatternType get type;
  @override
  ExpenseCategory get category;
  @override
  double get typicalAmount;
  @override
  int get occurrences;
  @override
  double get confidence;
  @override
  DateTime get firstSeen;
  @override
  DateTime get lastSeen;
  @override
  DateTime get detectedAt;
  @override
  double? get amountTolerance;
  @override
  int? get timeSlotHour;
  @override
  int? get timeSlotWindowMinutes;
  @override
  int? get dayOfWeek;
  @override
  int? get dayOfMonth;
  @override // for monthly patterns
  bool get notificationScheduled;
  @override
  bool get isDismissed;
  @override
  bool get isConfirmed;
  @override // user tapped "Yes, remind me"
  DateTime? get nextScheduledAt;
  @override
  int? get notificationId;
  @override
  @JsonKey(ignore: true)
  _$$SpendingPatternImplCopyWith<_$SpendingPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
