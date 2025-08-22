// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseEntry _$ExpenseEntryFromJson(Map<String, dynamic> json) => ExpenseEntry(
  id: (json['id'] as num?)?.toInt(),
  category: json['category'] as String,
  subCategory: json['subCategory'] as String?,
  description: json['description'] as String?,
  amount: (json['amount'] as num).toDouble(),
  date: json['date'] as String,
);

Map<String, dynamic> _$ExpenseEntryToJson(ExpenseEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'description': instance.description,
      'amount': instance.amount,
      'date': instance.date,
    };
