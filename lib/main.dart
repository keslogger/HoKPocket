import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mapahok/l10n/app_localizations.dart'; // Caminho de importação atualizado
import 'package:flutter/material.dart';
// Importe a sua tela do mapa interativo
import 'package:mapahok/features/main_menu/screens/main_menu_screen.dart'; // Alterado para o menu principal
// Importe o ThemeNotifier
import 'package:mapahok/core/notifiers/theme_notifier.dart'; // Ajuste o caminho se o seu ThemeNotifier estiver em outro local
// Importe o Provider
import 'package:provider/provider.dart';

void main() async {
  // main precisa ser async
  // Necessário para garantir que os bindings do Flutter estejam inicializados antes de configurar a orientação
  WidgetsFlutterBinding.ensureInitialized();
  // REMOVIDO: Forçar a orientação para paisagem globalmente.
  // A orientação inicial será definida pela primeira tela (MainMenuScreen)
  // ou pelas configurações padrão do dispositivo se a primeira tela não especificar.
  // DEBUG: Teste de print inicialíssimo
  // print("--- MAIN FUNCTION STARTED ---");
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumir o ThemeNotifier para obter o themeMode atual
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      // title: 'Mapa HOK', // Removido para usar onGenerateTitle
      // Configuração de Localização
      localizationsDelegates: const [
        AppLocalizations.delegate, // Seu delegate de localizações
        GlobalMaterialLocalizations.delegate, // Traduções para widgets Material
        GlobalWidgetsLocalizations.delegate, // Traduções básicas de widgets
        GlobalCupertinoLocalizations
            .delegate, // Traduções para widgets Cupertino
      ],
      supportedLocales:
          AppLocalizations.supportedLocales, // Locales que você suporta
      onGenerateTitle: (BuildContext context) {
        // Usa o context para obter as strings localizadas
        return AppLocalizations.of(context).appName;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFa8e2f4),
          brightness: Brightness.light, // Especificar brilho para o tema claro
        ),
        fontFamily:
            'Radikal', // Definir Radikal como a fonte padrão para o tema claro
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(
          0xFFa8e2f4,
        ), // Fundo azul claro para modo claro
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFF7bbbfb,
          ), // Usar a mesma seed para consistência, ajustada pelo brilho
          brightness: Brightness.dark,
        ),
        fontFamily:
            'Radikal', // Definir Radikal como a fonte padrão para o tema escuro
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(
          0xFF162946,
        ), // Fundo azul escuro para modo escuro
      ),
      themeMode: themeNotifier.themeMode, // Usa o themeMode do Notifier
      home: const MainMenuScreen(), // Alterado para o menu principal
    );
  }
}
