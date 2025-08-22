import 'package:json_annotation/json_annotation.dart';

part 'income_entry.g.dart';

@JsonSerializable()
class IncomeEntry {
  final int? id;
  final String category;
  final String? description;
  final double amount;
  final String date; // yyyy-MM-dd

  IncomeEntry({
    this.id,
    required this.category,
    this.description,
    required this.amount,
    required this.date,
  });

  factory IncomeEntry.fromJson(Map<String, dynamic> json) => _$IncomeEntryFromJson(json);
  Map<String, dynamic> toJson() => _$IncomeEntryToJson(this);
}
