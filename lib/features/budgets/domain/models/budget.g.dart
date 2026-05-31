// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetImpl _$$BudgetImplFromJson(Map<String, dynamic> json) => _$BudgetImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      limitAmount: (json['limitAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BudgetImplToJson(_$BudgetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'limitAmount': instance.limitAmount,
      'currency': instance.currency,
      'month': instance.month,
      'year': instance.year,
      'spentAmount': instance.spentAmount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'food',
  ExpenseCategory.transport: 'transport',
  ExpenseCategory.utilities: 'utilities',
  ExpenseCategory.entertainment: 'entertainment',
  ExpenseCategory.shopping: 'shopping',
  ExpenseCategory.health: 'health',
  ExpenseCategory.education: 'education',
  ExpenseCategory.other: 'other',
};
