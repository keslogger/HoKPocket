// lib/features/main_menu/screens/main_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar services para controle de orientação
import 'package:mapahok/features/interactive_map/screens/interactive_map_screen.dart';
import 'package:mapahok/features/main_menu/models/menu_item_model.dart';
import 'package:mapahok/l10n/app_localizations.dart'; // Importar localizações

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Definir a orientação para retrato ao entrar na tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Definindo os itens do menu conforme sua lista
    final List<MenuItemModel> menuItems = [
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
        title: l10n.mapaInterativo, // Usando a string mais específica
        iconLightPath: "assets/icons/menu/minion-light.PNG",
        iconDarkPath: "assets/icons/menu/minion-dark.PNG",
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
        iconLightPath: "assets/icons/menu/tirano-light.PNG", // Mesmo de Itens
        iconDarkPath: "assets/icons/menu/tirano-dark.PNG",
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName), // Corrigido para usar appName
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children:
              menuItems.map((item) {
                Widget iconWidget;
                if (item.flutterIcon != null) {
                  iconWidget = Icon(
                    item.flutterIcon,
                    size: 48.0,
                    color: Theme.of(context).colorScheme.primary,
                  );
                } else {
                  // Assegura que iconLightPath e iconDarkPath não são nulos aqui,
                  // pois flutterIcon é nulo.
                  final iconPath =
                      isDarkMode ? item.iconDarkPath! : item.iconLightPath!;
                  iconWidget = Image.asset(
                    iconPath,
                    width: 48.0,
                    height: 48.0,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Widget de fallback caso o ícone não seja encontrado
                      return Icon(
                        Icons.broken_image,
                        size: 48.0,
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
                  borderRadius: BorderRadius.circular(12.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        iconWidget,
                        const SizedBox(height: 12.0),
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
  }

  @override
  void dispose() {
    // Permitir todas as orientações ao sair da tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
