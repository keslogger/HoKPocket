// lib/features/items/screens/items_screen.dart
import 'package:flutter/material.dart';
import 'package:mapahok/features/items/models/item_category.dart';
import 'package:mapahok/features/items/models/item_model.dart';
import 'package:mapahok/features/items/repositories/item_repository.dart';
import 'package:mapahok/features/items/widgets/item_grid_tile.dart';
import 'package:mapahok/l10n/app_localizations.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ItemRepository _itemRepository = ItemRepository();
  final List<ItemCategory> _categories = [
    ItemCategory.all,
    ItemCategory.physical,
    ItemCategory.magical,
    ItemCategory.defense,
    ItemCategory.movement,
    ItemCategory.jungle,
    ItemCategory.support,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.itens), // Supondo que l10n.itens existe
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs:
              _categories.map((category) {
                // Você precisará adicionar os getters correspondentes em AppLocalizations
                // Ex: l10n.todosTabLabel, l10n.fisicoTabLabel, etc.
                // Por agora, usaremos placeholders se não existirem.
                String tabName;
                try {
                  tabName = category.displayName(l10n);
                } catch (e) {
                  // Placeholder em caso de string de localização ausente
                  tabName = category.name.toUpperCase();
                }
                return Tab(text: tabName);
              }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _categories.map((category) {
              return FutureBuilder<List<ItemModel>>(
                future: _itemRepository.getItemsByCategory(category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(l10n.erroAoCarregarItens),
                    ); // Supondo l10n.erroAoCarregarItens
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(l10n.nenhumItemEncontrado),
                    ); // Supondo l10n.nenhumItemEncontrado
                  }

                  final items = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Ajuste conforme necessário
                            childAspectRatio:
                                0.75, // Ajuste para o visual desejado
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ItemGridTile(item: items[index]);
                      },
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}

// Adicione estas chaves ao seu arquivo app_en.arb (e traduções correspondentes):
// "todosTabLabel": "All",
// "fisicoTabLabel": "Physical",
// "magicoTabLabel": "Magical",
// "defesaTabLabel": "Defense",
// "movimentoTabLabel": "Movement",
// "cacaTabLabel": "Jungle",
// "apoioTabLabel": "Support",
// "erroAoCarregarItens": "Error loading items",
// "nenhumItemEncontrado": "No items found"
