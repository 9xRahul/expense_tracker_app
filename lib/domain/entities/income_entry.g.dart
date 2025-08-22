// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeEntry _$IncomeEntryFromJson(Map<String, dynamic> json) => IncomeEntry(
  id: (json['id'] as num?)?.toInt(),
  category: json['category'] as String,
  description: json['description'] as String?,
  amount: (json['amount'] as num).toDouble(),
  date: json['date'] as String,
);

Map<String, dynamic> _$IncomeEntryToJson(IncomeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'description': instance.description,
      'amount': instance.amount,
      'date': instance.date,
    };
