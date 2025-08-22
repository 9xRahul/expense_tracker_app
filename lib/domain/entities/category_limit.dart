import 'package:json_annotation/json_annotation.dart';

part 'category_limit.g.dart';

@JsonSerializable()
class CategoryLimit {
  final int? id;
  final String category;
  final double monthlyLimit;

  CategoryLimit({this.id, required this.category, required this.monthlyLimit});

  factory CategoryLimit.fromJson(Map<String, dynamic> json) => _$CategoryLimitFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryLimitToJson(this);
}
