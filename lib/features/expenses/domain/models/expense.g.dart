// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      note: json['note'] as String?,
      receiptImageUrl: json['receiptImageUrl'] as String?,
      type: $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']) ??
          TransactionType.expense,
      isSynced: json['isSynced'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'currency': instance.currency,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'note': instance.note,
      'receiptImageUrl': instance.receiptImageUrl,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'isSynced': instance.isSynced,
      'isDeleted': instance.isDeleted,
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'food',
  ExpenseCategory.transport: 'transport',
  ExpenseCategory.utilities: 'utilities',
  ExpenseCategory.entertainment: 'entertainment',
  ExpenseCategory.shopping: 'shopping',
  ExpenseCategory.health: 'health',
  ExpenseCategory.education: 'education',
  ExpenseCategory.salary: 'salary',
  ExpenseCategory.business: 'business',
  ExpenseCategory.investment: 'investment',
  ExpenseCategory.gift: 'gift',
  ExpenseCategory.friend: 'friend',
  ExpenseCategory.bank: 'bank',
  ExpenseCategory.family: 'family',
  ExpenseCategory.other: 'other',
};

const _$TransactionTypeEnumMap = {
  TransactionType.expense: 'expense',
  TransactionType.income: 'income',
  TransactionType.borrow: 'borrow',
  TransactionType.lend: 'lend',
};
