// lib/features/items/models/item_model.dart
import 'package:mapahok/features/items/models/item_category.dart';

class ItemModel {
  final String id;
  final String name;
  final String imagePath;
  final ItemCategory category; // A categoria principal do item

  ItemModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
  });
}
