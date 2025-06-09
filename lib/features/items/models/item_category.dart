// lib/features/items/models/item_category.dart
import 'package:mapahok/l10n/app_localizations.dart'; // Para nomes de abas localizados

enum ItemCategory {
  all,
  physical,
  magical,
  defense,
  movement,
  jungle,
  support;

  String get assetFolderName {
    switch (this) {
      case ItemCategory.physical:
        return 'physical';
      case ItemCategory.magical:
        return 'magical';
      case ItemCategory.defense:
        return 'defense';
      case ItemCategory.movement:
        return 'movement';
      case ItemCategory.jungle:
        return 'jungle';
      case ItemCategory.support:
        return 'support';
      case ItemCategory
          .all: // "All" não tem uma pasta específica, agrega de outras
        return ''; // "All" não tem uma pasta específica, agrega de outras
    }
  }

  // Você precisará adicionar os getters correspondentes em AppLocalizations
  String displayName(AppLocalizations l10n) {
    switch (this) {
      case ItemCategory.all:
        return l10n.todosTabLabel; // Ex: "Todos"
      case ItemCategory.physical:
        return l10n.fisicoTabLabel; // Ex: "Físico"
      case ItemCategory.magical:
        return l10n.magicoTabLabel; // Ex: "Mágico"
      case ItemCategory.defense:
        return l10n.defesaTabLabel; // Ex: "Defesa"
      case ItemCategory.movement:
        return l10n.movimentoTabLabel; // Ex: "Movimento"
      case ItemCategory.jungle:
        return l10n.cacaTabLabel; // Ex: "Caça"
      case ItemCategory.support:
        return l10n.apoioTabLabel; // Ex: "Apoio"
      // Não é necessário default aqui, pois todos os casos do enum são cobertos.
      // Se um novo valor for adicionado ao enum ItemCategory, o analisador
      // irá alertar sobre um caso ausente neste switch.
    }
  }
}
