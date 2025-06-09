import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('tr'),
    Locale('es'),
    Locale('fil'),
    Locale('de'),
    Locale('fr'),
    Locale('ms'),
    Locale('zh'),
  ];

  /// No description provided for @adicionar.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get adicionar;

  /// No description provided for @adicionarTexto.
  ///
  /// In en, this message translates to:
  /// **'Add Text'**
  String get adicionarTexto;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'HoK Pocket'**
  String get appName;

  /// No description provided for @arcanas.
  ///
  /// In en, this message translates to:
  /// **'Arcanas'**
  String get arcanas;

  /// No description provided for @atualizacoes.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get atualizacoes;

  /// No description provided for @borracha.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get borracha;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @cancelButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonLabel;

  /// No description provided for @cancelar.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelar;

  /// No description provided for @configuracoes.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get configuracoes;

  /// No description provided for @confirmar.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmar;

  /// No description provided for @confirmarLimpeza.
  ///
  /// In en, this message translates to:
  /// **'Confirm Clear'**
  String get confirmarLimpeza;

  /// No description provided for @confirmarLimparTudoDialogoMensagem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all drawings, texts, and icons from the map? This action cannot be undone.'**
  String get confirmarLimparTudoDialogoMensagem;

  /// No description provided for @confirmarRemocao.
  ///
  /// In en, this message translates to:
  /// **'Confirm Removal'**
  String get confirmarRemocao;

  /// No description provided for @confirmarRemoverItemDialogo.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this item?'**
  String get confirmarRemoverItemDialogo;

  /// No description provided for @confirmarRemoverTodosIconesDialogo.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove ALL icons from the map? This action cannot be undone.'**
  String get confirmarRemoverTodosIconesDialogo;

  /// No description provided for @composicoes.
  ///
  /// In en, this message translates to:
  /// **'Compositions'**
  String get composicoes;

  /// No description provided for @corDoPincel.
  ///
  /// In en, this message translates to:
  /// **'Brush Color'**
  String get corDoPincel;

  /// No description provided for @corDoTexto.
  ///
  /// In en, this message translates to:
  /// **'Text Color'**
  String get corDoTexto;

  /// No description provided for @desfazer.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get desfazer;

  /// No description provided for @digiteOTexto.
  ///
  /// In en, this message translates to:
  /// **'Enter text'**
  String get digiteOTexto;

  /// No description provided for @editarTexto.
  ///
  /// In en, this message translates to:
  /// **'Edit Text'**
  String get editarTexto;

  /// No description provided for @estruturas.
  ///
  /// In en, this message translates to:
  /// **'Structures'**
  String get estruturas;

  /// No description provided for @funcionalidadeNaoImplementada.
  ///
  /// In en, this message translates to:
  /// **'Feature not yet implemented.'**
  String get funcionalidadeNaoImplementada;

  /// No description provided for @herois.
  ///
  /// In en, this message translates to:
  /// **'Heroes'**
  String get herois;

  /// No description provided for @heroisSecao.
  ///
  /// In en, this message translates to:
  /// **'Heroes'**
  String get heroisSecao;

  /// No description provided for @inibidores.
  ///
  /// In en, this message translates to:
  /// **'Inhibitors'**
  String get inibidores;

  /// Snackbar message when a menu item is tapped but its action is not implemented.
  ///
  /// In en, this message translates to:
  /// **'{itemName} selected! (Action not implemented)'**
  String itemSelecionadoAcaoNaoImplementada(String itemName);

  /// No description provided for @itens.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itens;

  /// No description provided for @limparDesenhos.
  ///
  /// In en, this message translates to:
  /// **'Clear Drawings'**
  String get limparDesenhos;

  /// No description provided for @limparIcones.
  ///
  /// In en, this message translates to:
  /// **'Clear Icons'**
  String get limparIcones;

  /// No description provided for @limparOpcao.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get limparOpcao;

  /// No description provided for @limparTextos.
  ///
  /// In en, this message translates to:
  /// **'Clear Texts'**
  String get limparTextos;

  /// No description provided for @limparTudo.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get limparTudo;

  /// No description provided for @mapa.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapa;

  /// No description provided for @mapaInterativo.
  ///
  /// In en, this message translates to:
  /// **'Interactive Map'**
  String get mapaInterativo;

  /// No description provided for @matchUps.
  ///
  /// In en, this message translates to:
  /// **'Match-ups'**
  String get matchUps;

  /// No description provided for @midia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get midia;

  /// No description provided for @minions.
  ///
  /// In en, this message translates to:
  /// **'Minions'**
  String get minions;

  /// No description provided for @minionsSecao.
  ///
  /// In en, this message translates to:
  /// **'Minions'**
  String get minionsSecao;

  /// No description provided for @monstros.
  ///
  /// In en, this message translates to:
  /// **'Monsters'**
  String get monstros;

  /// No description provided for @moverZoom.
  ///
  /// In en, this message translates to:
  /// **'Move/Zoom'**
  String get moverZoom;

  /// No description provided for @nexus.
  ///
  /// In en, this message translates to:
  /// **'Nexus'**
  String get nexus;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @pincel.
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get pincel;

  /// No description provided for @preferencias.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencias;

  /// No description provided for @refazer.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get refazer;

  /// No description provided for @remover.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remover;

  /// No description provided for @rotaAdc.
  ///
  /// In en, this message translates to:
  /// **'ADC'**
  String get rotaAdc;

  /// No description provided for @rotaJungle.
  ///
  /// In en, this message translates to:
  /// **'Jungle'**
  String get rotaJungle;

  /// No description provided for @rotaMid.
  ///
  /// In en, this message translates to:
  /// **'Mid'**
  String get rotaMid;

  /// No description provided for @rotaSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get rotaSupport;

  /// No description provided for @rotaTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get rotaTop;

  /// No description provided for @sair.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get sair;

  /// No description provided for @salvar.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get salvar;

  /// No description provided for @selectButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectButtonLabel;

  /// No description provided for @selecioneUmaCategoria.
  ///
  /// In en, this message translates to:
  /// **'Select a category above.'**
  String get selecioneUmaCategoria;

  /// No description provided for @selecioneUmaCor.
  ///
  /// In en, this message translates to:
  /// **'Select a Color'**
  String get selecioneUmaCor;

  /// No description provided for @selecioneUmaRota.
  ///
  /// In en, this message translates to:
  /// **'Select a lane to see heroes.'**
  String get selecioneUmaRota;

  /// No description provided for @selecioneUmTime.
  ///
  /// In en, this message translates to:
  /// **'Select a team to see minions.'**
  String get selecioneUmTime;

  /// No description provided for @selva.
  ///
  /// In en, this message translates to:
  /// **'Jungle'**
  String get selva;

  /// No description provided for @sobre.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sobre;

  /// No description provided for @texto.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get texto;

  /// No description provided for @toolTipBackToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to main menu'**
  String get toolTipBackToMenu;

  /// No description provided for @toolTipChangeToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Change to dark mode'**
  String get toolTipChangeToDarkMode;

  /// No description provided for @toolTipChangeToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Change to light mode'**
  String get toolTipChangeToLightMode;

  /// No description provided for @toolTipCollapseBottomPanel.
  ///
  /// In en, this message translates to:
  /// **'Collapse bottom panel'**
  String get toolTipCollapseBottomPanel;

  /// No description provided for @toolTipCollapseSidePanel.
  ///
  /// In en, this message translates to:
  /// **'Collapse side panel'**
  String get toolTipCollapseSidePanel;

  /// No description provided for @toolTipExpandBottomPanel.
  ///
  /// In en, this message translates to:
  /// **'Expand bottom panel'**
  String get toolTipExpandBottomPanel;

  /// No description provided for @toolTipExpandSidePanel.
  ///
  /// In en, this message translates to:
  /// **'Expand side panel'**
  String get toolTipExpandSidePanel;

  /// No description provided for @torneios.
  ///
  /// In en, this message translates to:
  /// **'Tournaments'**
  String get torneios;

  /// No description provided for @torres.
  ///
  /// In en, this message translates to:
  /// **'Towers'**
  String get torres;

  /// No description provided for @todosTabLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get todosTabLabel;

  /// No description provided for @fisicoTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get fisicoTabLabel;

  /// No description provided for @magicoTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Magical'**
  String get magicoTabLabel;

  /// No description provided for @defesaTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get defesaTabLabel;

  /// No description provided for @movimentoTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get movimentoTabLabel;

  /// No description provided for @cacaTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Jungle'**
  String get cacaTabLabel;

  /// No description provided for @apoioTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get apoioTabLabel;

  /// No description provided for @erroAoCarregarItens.
  ///
  /// In en, this message translates to:
  /// **'Error loading items'**
  String get erroAoCarregarItens;

  /// No description provided for @nenhumItemEncontrado.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get nenhumItemEncontrado;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fil',
    'fr',
    'ms',
    'pt',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'ms':
      return AppLocalizationsMs();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
