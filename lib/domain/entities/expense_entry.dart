import 'package:json_annotation/json_annotation.dart';

part 'expense_entry.g.dart';

@JsonSerializable()
class ExpenseEntry {
  final int? id;
  final String category;
  final String? subCategory; 
  final String? description; 
  final double amount;
  final String date; 

  ExpenseEntry({
    this.id,
    required this.category,
    this.subCategory,
    this.description,
    required this.amount,
    required this.date,
  });

  factory ExpenseEntry.fromJson(Map<String, dynamic> json) => _$ExpenseEntryFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseEntryToJson(this);
}
