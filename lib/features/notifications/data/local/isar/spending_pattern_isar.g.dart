// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spending_pattern_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSpendingPatternIsarCollection on Isar {
  IsarCollection<SpendingPatternIsar> get spendingPatternIsars =>
      this.collection();
}

const SpendingPatternIsarSchema = CollectionSchema(
  name: r'SpendingPatternIsar',
  id: 1422222045838271178,
  properties: {
    r'amountTolerance': PropertySchema(
      id: 0,
      name: r'amountTolerance',
      type: IsarType.double,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 2,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'dayOfMonth': PropertySchema(
      id: 3,
      name: r'dayOfMonth',
      type: IsarType.long,
    ),
    r'dayOfWeek': PropertySchema(
      id: 4,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'detectedAt': PropertySchema(
      id: 5,
      name: r'detectedAt',
      type: IsarType.dateTime,
    ),
    r'firstSeen': PropertySchema(
      id: 6,
      name: r'firstSeen',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 7,
      name: r'id',
      type: IsarType.string,
    ),
    r'isConfirmed': PropertySchema(
      id: 8,
      name: r'isConfirmed',
      type: IsarType.bool,
    ),
    r'isDismissed': PropertySchema(
      id: 9,
      name: r'isDismissed',
      type: IsarType.bool,
    ),
    r'lastSeen': PropertySchema(
      id: 10,
      name: r'lastSeen',
      type: IsarType.dateTime,
    ),
    r'nextScheduledAt': PropertySchema(
      id: 11,
      name: r'nextScheduledAt',
      type: IsarType.dateTime,
    ),
    r'notificationId': PropertySchema(
      id: 12,
      name: r'notificationId',
      type: IsarType.long,
    ),
    r'notificationScheduled': PropertySchema(
      id: 13,
      name: r'notificationScheduled',
      type: IsarType.bool,
    ),
    r'occurrences': PropertySchema(
      id: 14,
      name: r'occurrences',
      type: IsarType.long,
    ),
    r'timeSlotHour': PropertySchema(
      id: 15,
      name: r'timeSlotHour',
      type: IsarType.long,
    ),
    r'timeSlotWindowMinutes': PropertySchema(
      id: 16,
      name: r'timeSlotWindowMinutes',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 17,
      name: r'type',
      type: IsarType.string,
    ),
    r'typicalAmount': PropertySchema(
      id: 18,
      name: r'typicalAmount',
      type: IsarType.double,
    )
  },
  estimateSize: _spendingPatternIsarEstimateSize,
  serialize: _spendingPatternIsarSerialize,
  deserialize: _spendingPatternIsarDeserialize,
  deserializeProp: _spendingPatternIsarDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _spendingPatternIsarGetId,
  getLinks: _spendingPatternIsarGetLinks,
  attach: _spendingPatternIsarAttach,
  version: '3.1.0+1',
);

int _spendingPatternIsarEstimateSize(
  SpendingPatternIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _spendingPatternIsarSerialize(
  SpendingPatternIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountTolerance);
  writer.writeString(offsets[1], object.category);
  writer.writeDouble(offsets[2], object.confidence);
  writer.writeLong(offsets[3], object.dayOfMonth);
  writer.writeLong(offsets[4], object.dayOfWeek);
  writer.writeDateTime(offsets[5], object.detectedAt);
  writer.writeDateTime(offsets[6], object.firstSeen);
  writer.writeString(offsets[7], object.id);
  writer.writeBool(offsets[8], object.isConfirmed);
  writer.writeBool(offsets[9], object.isDismissed);
  writer.writeDateTime(offsets[10], object.lastSeen);
  writer.writeDateTime(offsets[11], object.nextScheduledAt);
  writer.writeLong(offsets[12], object.notificationId);
  writer.writeBool(offsets[13], object.notificationScheduled);
  writer.writeLong(offsets[14], object.occurrences);
  writer.writeLong(offsets[15], object.timeSlotHour);
  writer.writeLong(offsets[16], object.timeSlotWindowMinutes);
  writer.writeString(offsets[17], object.type);
  writer.writeDouble(offsets[18], object.typicalAmount);
}

SpendingPatternIsar _spendingPatternIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpendingPatternIsar();
  object.amountTolerance = reader.readDoubleOrNull(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.confidence = reader.readDouble(offsets[2]);
  object.dayOfMonth = reader.readLongOrNull(offsets[3]);
  object.dayOfWeek = reader.readLongOrNull(offsets[4]);
  object.detectedAt = reader.readDateTime(offsets[5]);
  object.firstSeen = reader.readDateTime(offsets[6]);
  object.id = reader.readString(offsets[7]);
  object.isConfirmed = reader.readBool(offsets[8]);
  object.isDismissed = reader.readBool(offsets[9]);
  object.isarId = id;
  object.lastSeen = reader.readDateTime(offsets[10]);
  object.nextScheduledAt = reader.readDateTimeOrNull(offsets[11]);
  object.notificationId = reader.readLongOrNull(offsets[12]);
  object.notificationScheduled = reader.readBool(offsets[13]);
  object.occurrences = reader.readLong(offsets[14]);
  object.timeSlotHour = reader.readLongOrNull(offsets[15]);
  object.timeSlotWindowMinutes = reader.readLongOrNull(offsets[16]);
  object.type = reader.readString(offsets[17]);
  object.typicalAmount = reader.readDouble(offsets[18]);
  return object;
}

P _spendingPatternIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _spendingPatternIsarGetId(SpendingPatternIsar object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _spendingPatternIsarGetLinks(
    SpendingPatternIsar object) {
  return [];
}

void _spendingPatternIsarAttach(
    IsarCollection<dynamic> col, Id id, SpendingPatternIsar object) {
  object.isarId = id;
}

extension SpendingPatternIsarByIndex on IsarCollection<SpendingPatternIsar> {
  Future<SpendingPatternIsar?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  SpendingPatternIsar? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<SpendingPatternIsar?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<SpendingPatternIsar?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(SpendingPatternIsar object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(SpendingPatternIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<SpendingPatternIsar> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<SpendingPatternIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension SpendingPatternIsarQueryWhereSort
    on QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QWhere> {
  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SpendingPatternIsarQueryWhere
    on QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QWhereClause> {
  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterWhereClause>
      idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SpendingPatternIsarQueryFilter on QueryBuilder<SpendingPatternIsar,
    SpendingPatternIsar, QFilterCondition> {
  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      amountToleranceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amountTolerance',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      amountToleranceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amountTolerance',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      amountToleranceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountTolerance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      amountToleranceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountTolerance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      amountToleranceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountTolerance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      amountToleranceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountTolerance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      confidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      confidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      confidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      confidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayOfMonth',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayOfMonth',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfMonthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfMonthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfMonthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfMonthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayOfWeek',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayOfWeek',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfWeekEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfWeekLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      dayOfWeekBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      detectedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      detectedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      detectedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      detectedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detectedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      firstSeenEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      firstSeenGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      firstSeenLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      firstSeenBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstSeen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      isConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isConfirmed',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      isDismissedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDismissed',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      lastSeenEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      lastSeenGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      lastSeenLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      lastSeenBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSeen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      nextScheduledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextScheduledAt',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      nextScheduledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextScheduledAt',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      nextScheduledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextScheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      nextScheduledAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextScheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      nextScheduledAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextScheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      nextScheduledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextScheduledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      notificationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notificationId',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      notificationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notificationId',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      notificationIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      notificationIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      notificationIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      notificationIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      notificationScheduledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      occurrencesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurrences',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      occurrencesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occurrences',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      occurrencesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occurrences',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      occurrencesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occurrences',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeSlotHour',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeSlotHour',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotHourEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSlotHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotHourGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeSlotHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotHourLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeSlotHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotHourBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeSlotHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotWindowMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeSlotWindowMinutes',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotWindowMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeSlotWindowMinutes',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotWindowMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSlotWindowMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotWindowMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeSlotWindowMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotWindowMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeSlotWindowMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      timeSlotWindowMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeSlotWindowMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typicalAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typicalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typicalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typicalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typicalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typicalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterFilterCondition>
      typicalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typicalAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SpendingPatternIsarQueryObject on QueryBuilder<SpendingPatternIsar,
    SpendingPatternIsar, QFilterCondition> {}

extension SpendingPatternIsarQueryLinks on QueryBuilder<SpendingPatternIsar,
    SpendingPatternIsar, QFilterCondition> {}

extension SpendingPatternIsarQuerySortBy
    on QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QSortBy> {
  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByAmountTolerance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTolerance', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByAmountToleranceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTolerance', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByDetectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByFirstSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstSeen', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByFirstSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstSeen', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByNextScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextScheduledAt', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByNextScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextScheduledAt', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByNotificationScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationScheduled', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByNotificationScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationScheduled', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByOccurrences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrences', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByOccurrencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrences', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByTimeSlotHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotHour', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByTimeSlotHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotHour', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByTimeSlotWindowMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotWindowMinutes', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByTimeSlotWindowMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotWindowMinutes', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByTypicalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typicalAmount', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      sortByTypicalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typicalAmount', Sort.desc);
    });
  }
}

extension SpendingPatternIsarQuerySortThenBy
    on QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QSortThenBy> {
  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByAmountTolerance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTolerance', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByAmountToleranceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTolerance', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByDetectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByFirstSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstSeen', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByFirstSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstSeen', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByNextScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextScheduledAt', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByNextScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextScheduledAt', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByNotificationScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationScheduled', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByNotificationScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationScheduled', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByOccurrences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrences', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByOccurrencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrences', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByTimeSlotHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotHour', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByTimeSlotHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotHour', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByTimeSlotWindowMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotWindowMinutes', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByTimeSlotWindowMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotWindowMinutes', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByTypicalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typicalAmount', Sort.asc);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QAfterSortBy>
      thenByTypicalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typicalAmount', Sort.desc);
    });
  }
}

extension SpendingPatternIsarQueryWhereDistinct
    on QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct> {
  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByAmountTolerance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountTolerance');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfMonth');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfWeek');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detectedAt');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByFirstSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstSeen');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isConfirmed');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDismissed');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeen');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByNextScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextScheduledAt');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationId');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByNotificationScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationScheduled');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByOccurrences() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurrences');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByTimeSlotHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSlotHour');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByTimeSlotWindowMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSlotWindowMinutes');
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QDistinct>
      distinctByTypicalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typicalAmount');
    });
  }
}

extension SpendingPatternIsarQueryProperty
    on QueryBuilder<SpendingPatternIsar, SpendingPatternIsar, QQueryProperty> {
  QueryBuilder<SpendingPatternIsar, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SpendingPatternIsar, double?, QQueryOperations>
      amountToleranceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountTolerance');
    });
  }

  QueryBuilder<SpendingPatternIsar, String, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<SpendingPatternIsar, double, QQueryOperations>
      confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<SpendingPatternIsar, int?, QQueryOperations>
      dayOfMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfMonth');
    });
  }

  QueryBuilder<SpendingPatternIsar, int?, QQueryOperations>
      dayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfWeek');
    });
  }

  QueryBuilder<SpendingPatternIsar, DateTime, QQueryOperations>
      detectedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detectedAt');
    });
  }

  QueryBuilder<SpendingPatternIsar, DateTime, QQueryOperations>
      firstSeenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstSeen');
    });
  }

  QueryBuilder<SpendingPatternIsar, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SpendingPatternIsar, bool, QQueryOperations>
      isConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isConfirmed');
    });
  }

  QueryBuilder<SpendingPatternIsar, bool, QQueryOperations>
      isDismissedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDismissed');
    });
  }

  QueryBuilder<SpendingPatternIsar, DateTime, QQueryOperations>
      lastSeenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeen');
    });
  }

  QueryBuilder<SpendingPatternIsar, DateTime?, QQueryOperations>
      nextScheduledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextScheduledAt');
    });
  }

  QueryBuilder<SpendingPatternIsar, int?, QQueryOperations>
      notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationId');
    });
  }

  QueryBuilder<SpendingPatternIsar, bool, QQueryOperations>
      notificationScheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationScheduled');
    });
  }

  QueryBuilder<SpendingPatternIsar, int, QQueryOperations>
      occurrencesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurrences');
    });
  }

  QueryBuilder<SpendingPatternIsar, int?, QQueryOperations>
      timeSlotHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSlotHour');
    });
  }

  QueryBuilder<SpendingPatternIsar, int?, QQueryOperations>
      timeSlotWindowMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSlotWindowMinutes');
    });
  }

  QueryBuilder<SpendingPatternIsar, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<SpendingPatternIsar, double, QQueryOperations>
      typicalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typicalAmount');
    });
  }
}
