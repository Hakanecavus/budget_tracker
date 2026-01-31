import 'package:flutter/material.dart';

enum CategoryType { income, expense }

class Category {
  final String id;
  final String name;
  final Color color;
  final CategoryType type;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.toARGB32(),
      'type': type.index,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      type: CategoryType.values[json['type']],
    );
  }
}
