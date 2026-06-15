import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseUiUtils {
  static IconData getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food: return Icons.restaurant;
      case ExpenseCategory.transport: return Icons.directions_car;
      case ExpenseCategory.utilities: return Icons.electrical_services;
      case ExpenseCategory.entertainment: return Icons.movie;
      case ExpenseCategory.shopping: return Icons.shopping_bag;
      case ExpenseCategory.health: return Icons.medical_services;
      case ExpenseCategory.education: return Icons.school;
      case ExpenseCategory.salary: return Icons.work;
      case ExpenseCategory.business: return Icons.storefront;
      case ExpenseCategory.investment: return Icons.trending_up;
      case ExpenseCategory.gift: return Icons.card_giftcard;
      case ExpenseCategory.friend: return Icons.people;
      case ExpenseCategory.bank: return Icons.account_balance;
      case ExpenseCategory.family: return Icons.house;
      case ExpenseCategory.other: return Icons.more_horiz;
    }
  }

  static Color getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food: return Colors.orange;
      case ExpenseCategory.transport: return Colors.blue;
      case ExpenseCategory.shopping: return Colors.purple;
      case ExpenseCategory.utilities: return Colors.amber;
      case ExpenseCategory.health: return Colors.red;
      case ExpenseCategory.entertainment: return Colors.green;
      case ExpenseCategory.education: return Colors.indigo;
      case ExpenseCategory.salary: return Colors.teal;
      case ExpenseCategory.business: return Colors.cyan;
      case ExpenseCategory.investment: return Colors.lightGreen;
      case ExpenseCategory.gift: return Colors.deepPurple;
      case ExpenseCategory.friend: return Colors.brown;
      case ExpenseCategory.bank: return Colors.blueGrey;
      case ExpenseCategory.family: return Colors.pink;
      case ExpenseCategory.other: return Colors.grey;
    }
  }

  static String formatEnumName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }
}
