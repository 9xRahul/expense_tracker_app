// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_limit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLimit _$CategoryLimitFromJson(Map<String, dynamic> json) =>
    CategoryLimit(
      id: (json['id'] as num?)?.toInt(),
      category: json['category'] as String,
      monthlyLimit: (json['monthlyLimit'] as num).toDouble(),
    );

Map<String, dynamic> _$CategoryLimitToJson(CategoryLimit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'monthlyLimit': instance.monthlyLimit,
    };
