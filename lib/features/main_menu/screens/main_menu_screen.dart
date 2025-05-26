import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar services para controle de orientação
import 'package:mapahok/features/interactive_map/screens/interactive_map_screen.dart';
import 'package:mapahok/features/main_menu/models/menu_item_model.dart';
import 'package:mapahok/l10n/app_localizations.dart'; // Importar localizações
import 'package:provider/provider.dart'; // Para acessar o ThemeNotifier
import 'package:mapahok/core/notifiers/theme_notifier.dart'; // Importar o ThemeNotifier

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  // Constantes para UI
  static const double _paddingAll = 16.0;
  static const int _crossAxisCount = 3;
  static const double _gridSpacing = 16.0;
  static const double _iconSize = 64.0;
  static const double _cardBorderRadius = 12.0;
  static const double _cardElevation = 2.0;
  static const double _sizedBoxHeight = 12.0;
  static const double _fallbackIconSize = 48.0;

  @override
  void initState() {
    super.initState();
    // print("--- MainMenuScreen initState START ---"); // Removido para produção
    // Definir a orientação para retrato ao entrar na tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // print("--- MainMenuScreen initState END ---"); // Removido para produção
  }

  // Método para construir a lista de itens do menu
  List<MenuItemModel> _getMenuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Definindo os itens do menu conforme sua lista
    // print("--- MainMenuScreen: Creating menuItems list ---"); // Removido para produção
    return [
      MenuItemModel(
        title: l10n.herois,
        iconLightPath: "assets/icons/menu/hero-light.PNG",
        iconDarkPath: "assets/icons/menu/hero-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.monstros,
        iconLightPath: "assets/icons/menu/fogo-light.PNG",
        iconDarkPath: "assets/icons/menu/fogo-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.arcanas,
        iconLightPath: "assets/icons/menu/arcana.png", // Mesmo para dark
        iconDarkPath: "assets/icons/menu/arcana.png",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.itens,
        iconLightPath: "assets/icons/menu/tirano-light.PNG",
        iconDarkPath: "assets/icons/menu/tirano-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.build,
        iconLightPath: "assets/icons/menu/portal-light.PNG",
        iconDarkPath: "assets/icons/menu/portal-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.mapaInterativo,
        iconLightPath: "assets/icons/menu/nexus-light.PNG",
        iconDarkPath: "assets/icons/menu/nexus-dark.PNG",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InteractiveMapScreen(),
            ),
          );
        },
      ),
      MenuItemModel(
        title: l10n.atualizacoes,
        iconLightPath: "assets/icons/menu/minion-light.PNG", // Mesmo de Itens
        iconDarkPath: "assets/icons/menu/minion-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.matchUps,
        iconLightPath: "assets/icons/menu/overlord-light.PNG",
        iconDarkPath: "assets/icons/menu/overlord-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.torneios,
        iconLightPath: "assets/icons/menu/tempestade.PNG", // Mesmo para dark
        iconDarkPath: "assets/icons/menu/tempestade.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.composicoes,
        iconLightPath: "assets/icons/menu/olho-light.PNG",
        iconDarkPath: "assets/icons/menu/olho-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.midia,
        flutterIcon: Icons.play_circle_outline, // Exemplo de ícone Flutter
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.preferencias,
        flutterIcon: Icons.settings_outlined, // Exemplo de ícone Flutter
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
      MenuItemModel(
        title: l10n.sobre,
        iconLightPath: "assets/icons/menu/goiaba-light.PNG",
        iconDarkPath: "assets/icons/menu/goiaba-dark.PNG",
        onTap: () {
          /* TODO: Implementar navegação ou ação */
        },
      ),
    ];
    // print(
    //   "--- MainMenuScreen: menuItems list CREATED with ${menuItems.length} items ---",
    // ); // Removido para produção
  }

  @override
  Widget build(BuildContext context) {
    // print("--- MainMenuScreen build START ---"); // Removido para produção
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final l10n = AppLocalizations.of(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<MenuItemModel> menuItems = _getMenuItems(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HoK Pocket", // Mantido como nome do app, mas poderia ser l10n.appName
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip:
                themeNotifier.themeMode == ThemeMode.light
                    ? l10n.toolTipChangeToDarkMode
                    : l10n.toolTipChangeToLightMode,
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(_paddingAll),
        child: GridView.count(
          crossAxisCount: _crossAxisCount,
          crossAxisSpacing: _gridSpacing,
          mainAxisSpacing: _gridSpacing,
          children:
              menuItems.map((item) {
                // print("--- MainMenuScreen: Mapping item: ${item.title} ---"); // Removido para produção
                Widget iconWidget;

                if (item.flutterIcon != null) {
                  iconWidget = Icon(
                    item.flutterIcon,
                    size: _iconSize,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha((255 * 0.8).round()),
                  );
                } else {
                  // Assegura que iconLightPath e iconDarkPath não são nulos aqui,
                  // pois flutterIcon é nulo. Idealmente, MenuItemModel garante isso.
                  final iconPath =
                      isDarkMode ? item.iconDarkPath! : item.iconLightPath!;
                  // print(
                  //   "--- MainMenuScreen: Loading image for ${item.title}: $iconPath ---",
                  // ); // Removido para produção
                  iconWidget = Image.asset(
                    iconPath,
                    width: _iconSize,
                    height: _iconSize,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // print(
                      //   "--- MainMenuScreen: ERROR loading image for ${item.title}: $error ---",
                      // ); // Removido para produção. Considerar logar o erro.
                      // Widget de fallback caso o ícone não seja encontrado
                      return Icon(
                        Icons.broken_image,
                        size: _fallbackIconSize,
                        color: Theme.of(context).colorScheme.error,
                      );
                    },
                  );
                }
                return InkWell(
                  onTap:
                      item.onTap ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.itemSelecionadoAcaoNaoImplementada(
                                item.title,
                              ),
                            ),
                          ),
                        );
                      },
                  borderRadius: BorderRadius.circular(_cardBorderRadius),
                  child: Card(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .surface, // Aplicando cor de superfície ao card
                    elevation: _cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_cardBorderRadius),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        iconWidget,
                        const SizedBox(height: _sizedBoxHeight),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
    // print("--- MainMenuScreen build END ---"); // Este print pode não ser alcançado se houver um return antes
  }

  @override
  void dispose() {
    // print("--- MainMenuScreen dispose START ---"); // Removido para produção
    // Permitir todas as orientações ao sair da tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // Boa prática resetar as orientações
    super.dispose();
    // print("--- MainMenuScreen dispose END ---"); // Removido para produção
  }
}
