// lib/features/items/widgets/item_grid_tile.dart
import 'package:flutter/material.dart';
import 'package:mapahok/features/items/models/item_model.dart';

class ItemGridTile extends StatelessWidget {
  final ItemModel item;

  const ItemGridTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior:
          Clip.antiAlias, // Para que a imagem não ultrapasse as bordas arredondadas
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Widget de fallback caso a imagem não seja encontrada
                  return const Icon(Icons.broken_image, size: 48.0);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
