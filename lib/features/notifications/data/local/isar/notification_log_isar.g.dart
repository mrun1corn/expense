// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationLogIsarCollection on Isar {
  IsarCollection<NotificationLogIsar> get notificationLogIsars =>
      this.collection();
}

const NotificationLogIsarSchema = CollectionSchema(
  name: r'NotificationLogIsar',
  id: 3048391128245374674,
  properties: {
    r'addedAmount': PropertySchema(
      id: 0,
      name: r'addedAmount',
      type: IsarType.double,
    ),
    r'firedAt': PropertySchema(
      id: 1,
      name: r'firedAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'patternId': PropertySchema(
      id: 3,
      name: r'patternId',
      type: IsarType.string,
    ),
    r'response': PropertySchema(
      id: 4,
      name: r'response',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _notificationLogIsarEstimateSize,
  serialize: _notificationLogIsarSerialize,
  deserialize: _notificationLogIsarDeserialize,
  deserializeProp: _notificationLogIsarDeserializeProp,
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
  getId: _notificationLogIsarGetId,
  getLinks: _notificationLogIsarGetLinks,
  attach: _notificationLogIsarAttach,
  version: '3.1.0+1',
);

int _notificationLogIsarEstimateSize(
  NotificationLogIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.patternId.length * 3;
  bytesCount += 3 + object.response.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _notificationLogIsarSerialize(
  NotificationLogIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.addedAmount);
  writer.writeDateTime(offsets[1], object.firedAt);
  writer.writeString(offsets[2], object.id);
  writer.writeString(offsets[3], object.patternId);
  writer.writeString(offsets[4], object.response);
  writer.writeString(offsets[5], object.type);
}

NotificationLogIsar _notificationLogIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationLogIsar();
  object.addedAmount = reader.readDoubleOrNull(offsets[0]);
  object.firedAt = reader.readDateTime(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.isarId = id;
  object.patternId = reader.readString(offsets[3]);
  object.response = reader.readString(offsets[4]);
  object.type = reader.readString(offsets[5]);
  return object;
}

P _notificationLogIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationLogIsarGetId(NotificationLogIsar object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _notificationLogIsarGetLinks(
    NotificationLogIsar object) {
  return [];
}

void _notificationLogIsarAttach(
    IsarCollection<dynamic> col, Id id, NotificationLogIsar object) {
  object.isarId = id;
}

extension NotificationLogIsarByIndex on IsarCollection<NotificationLogIsar> {
  Future<NotificationLogIsar?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  NotificationLogIsar? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<NotificationLogIsar?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<NotificationLogIsar?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(NotificationLogIsar object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(NotificationLogIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<NotificationLogIsar> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<NotificationLogIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension NotificationLogIsarQueryWhereSort
    on QueryBuilder<NotificationLogIsar, NotificationLogIsar, QWhere> {
  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationLogIsarQueryWhere
    on QueryBuilder<NotificationLogIsar, NotificationLogIsar, QWhereClause> {
  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhereClause>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhereClause>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterWhereClause>
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

extension NotificationLogIsarQueryFilter on QueryBuilder<NotificationLogIsar,
    NotificationLogIsar, QFilterCondition> {
  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      addedAmountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'addedAmount',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      addedAmountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'addedAmount',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      addedAmountEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      addedAmountGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      addedAmountLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      addedAmountBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addedAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      firedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      firedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      firedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      firedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patternId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'patternId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'patternId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'patternId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'patternId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'patternId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'patternId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'patternId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patternId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      patternIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'patternId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'response',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'response',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'response',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      responseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'response',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
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

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension NotificationLogIsarQueryObject on QueryBuilder<NotificationLogIsar,
    NotificationLogIsar, QFilterCondition> {}

extension NotificationLogIsarQueryLinks on QueryBuilder<NotificationLogIsar,
    NotificationLogIsar, QFilterCondition> {}

extension NotificationLogIsarQuerySortBy
    on QueryBuilder<NotificationLogIsar, NotificationLogIsar, QSortBy> {
  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByAddedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAmount', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByAddedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAmount', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByFiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByPatternIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension NotificationLogIsarQuerySortThenBy
    on QueryBuilder<NotificationLogIsar, NotificationLogIsar, QSortThenBy> {
  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByAddedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAmount', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByAddedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAmount', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByFiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByPatternIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.desc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension NotificationLogIsarQueryWhereDistinct
    on QueryBuilder<NotificationLogIsar, NotificationLogIsar, QDistinct> {
  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QDistinct>
      distinctByAddedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedAmount');
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QDistinct>
      distinctByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firedAt');
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QDistinct>
      distinctByPatternId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'patternId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QDistinct>
      distinctByResponse({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'response', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationLogIsar, NotificationLogIsar, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension NotificationLogIsarQueryProperty
    on QueryBuilder<NotificationLogIsar, NotificationLogIsar, QQueryProperty> {
  QueryBuilder<NotificationLogIsar, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<NotificationLogIsar, double?, QQueryOperations>
      addedAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedAmount');
    });
  }

  QueryBuilder<NotificationLogIsar, DateTime, QQueryOperations>
      firedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firedAt');
    });
  }

  QueryBuilder<NotificationLogIsar, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationLogIsar, String, QQueryOperations>
      patternIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'patternId');
    });
  }

  QueryBuilder<NotificationLogIsar, String, QQueryOperations>
      responseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'response');
    });
  }

  QueryBuilder<NotificationLogIsar, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
