// c:\Users\jkesl\mapahok\lib\features\interactive_map\widgets\elements_sidebar.dart
import 'package:flutter/material.dart' as mat; // Usar prefixo para clareza
import 'package:flutter/widgets.dart'
    as wdg; // Usar prefixo para clareza, especialmente para pointerDragAnchorStrategy
// Importe a lista de itens arrastáveis do novo arquivo
import 'package:mapahok/features/interactive_map/widgets/draggable_map_item.dart';
import 'package:mapahok/l10n/app_localizations.dart'; // Importar localizações
import 'package:mapahok/features/interactive_map/models/map_element.dart'; // Contém MapElementType, HeroRoute, RouteDisplayData, heroRouteData, MinionTeam, MinionTeamDisplayInfo

// --------- DEFINIÇÕES DE ESTILO INSPIRADAS NA UI DE JOGO ---------
const mat.Color gameUINavbarBgColor = mat.Color(
  0xFF1A222D,
); // Fundo principal da sidebar (azul escuro/cinza)
const mat.Color gameUIContentBgColor = mat.Color(
  0xFF202938,
); // Fundo para seções internas ou cards (um pouco mais claro)
const mat.Color gameUISelectedItemColor = mat.Color(
  0xFF007ACC,
); // Azul vibrante para itens selecionados
const mat.Color gameUISelectedItemTextIconColor = mat.Colors.white;
const mat.Color gameUIDefaultTextColor = mat.Color(
  0xFFB0BEC5,
); // Texto padrão (cinza azulado claro)
const mat.Color gameUIDefaultIconColor = mat.Color(
  0xFF78909C,
); // Ícone padrão (cinza azulado)
const mat.Color gameUIDividerColor = mat.Color(
  0xFF2A394D,
); // Cor para divisórias
const mat.Color gameUIBorderColor = mat.Color(
  0xFF37474F,
); // Cor para bordas sutis
const mat.Color gameUITransparentColor = mat.Colors.transparent;
// -------------------------------------------------------------------

enum _SidebarSection { heroes, minions }

class ElementsSidebar extends mat.StatefulWidget {
  // Convertido para StatefulWidget
  final bool isExpanded;
  final wdg.Orientation orientation; // Nova propriedade para orientação
  final void Function(MapElementType toolType)? onToolSelected;
  final MapElementType? activeToolType;
  final mat.Color currentDrawingColor;
  final mat.Color currentTextColor;
  final void Function()? onDrawingColorSelectRequest;
  final void Function()? onTextColorSelectRequest;
  final mat.VoidCallback? onClearAllHeroIcons; // Novo callback
  final mat.VoidCallback?
  onDraggableElementDragStarted; // Novo callback para notificar o início do arraste

  const ElementsSidebar({
    super.key,
    required this.isExpanded,
    required this.orientation, // Adicionar ao construtor
    this.onToolSelected,
    required this.currentDrawingColor,
    required this.currentTextColor,
    this.onDrawingColorSelectRequest,
    this.onTextColorSelectRequest,
    this.activeToolType,
    this.onClearAllHeroIcons, // Adicionar ao construtor
    this.onDraggableElementDragStarted, // Adicionar ao construtor
  });

  @override
  mat.State<ElementsSidebar> createState() => _ElementsSidebarState();
}

class _ElementsSidebarState extends mat.State<ElementsSidebar> {
  HeroRoute? _selectedRoute; // Estado para a rota selecionada
  _SidebarSection _activeSection =
      _SidebarSection.heroes; // Começar com heróis por padrão
  MinionTeam? _selectedMinionTeam; // Estado para o time de minions selecionado

  mat.Widget _buildExpandedContent(mat.BuildContext context) {
    final List<Map<String, dynamic>> allItems =
        draggableItemsData; // Supondo que draggableItemsData está disponível
    List<Map<String, dynamic>> itemsForGrid = [];
    MapElementType? currentGridType;

    if (_activeSection == _SidebarSection.heroes) {
      currentGridType = MapElementType.hero;
      if (_selectedRoute != null) {
        itemsForGrid =
            allItems.where((item) {
              if (item['type'] == MapElementType.hero) {
                final heroRoutes = item['route'];
                // Verifica se 'route' é uma lista e se contém a rota selecionada
                if (heroRoutes is List<HeroRoute> &&
                    heroRoutes.contains(_selectedRoute)) {
                  return true;
                }
              }
              return false;
            }).toList();
      }
    } else if (_activeSection == _SidebarSection.minions) {
      currentGridType = MapElementType.minion;
      if (_selectedMinionTeam != null) {
        itemsForGrid =
            allItems
                .where(
                  (item) =>
                      item['type'] == MapElementType.minion &&
                      item['team'] == _selectedMinionTeam,
                )
                .toList();
      }
    }

    return mat.Column(
      children: [
        _buildSectionToggleTabs(context), // Abas para Heróis/Minions
        const mat.Divider(color: gameUIDividerColor, height: 1),
        if (_activeSection == _SidebarSection.heroes) ...[
          _buildRouteTabs(context), // Abas de rotas dos heróis
          const mat.Divider(color: gameUIDividerColor, height: 1),
        ] else if (_activeSection == _SidebarSection.minions) ...[
          _buildMinionTeamTabs(context), // Abas de times de minions
          const mat.Divider(color: gameUIDividerColor, height: 1),
        ],
        mat.Expanded(
          child: _buildItemsGrid(context, itemsForGrid, currentGridType),
        ),
      ],
    );
  }

  mat.Widget _buildItemsGrid(
    mat.BuildContext context,
    List<Map<String, dynamic>> items,
    MapElementType? gridItemType,
  ) {
    final l10n = AppLocalizations.of(context);
    if (gridItemType == null || items.isEmpty) {
      String message = l10n.selecioneUmaCategoria;
      if (widget.isExpanded &&
          _activeSection == _SidebarSection.heroes &&
          _selectedRoute == null) {
        message = l10n.selecioneUmaRota;
      } else if (widget.isExpanded &&
          _activeSection == _SidebarSection.minions &&
          _selectedMinionTeam == null) {
        message = l10n.selecioneUmTime;
      }
      return mat.Center(
        child: mat.Text(
          message,
          style: const mat.TextStyle(
            color: gameUIDefaultTextColor,
            fontSize: 14,
          ),
        ),
      );
    }

    final bool isLightMode =
        mat.Theme.of(context).brightness == mat.Brightness.light;

    // Configuração do tema da barra de rolagem
    final mat.ScrollbarThemeData scrollbarThemeData = mat.ScrollbarThemeData(
      thumbVisibility: mat.WidgetStateProperty.all(true), // Sempre visível
      trackVisibility: mat.WidgetStateProperty.all(true), // Sempre visível
      thickness: mat.WidgetStateProperty.all(10.0), // Espessura
      interactive: true, // Permite interação com a barra
      radius: const mat.Radius.circular(5.0), // Bordas arredondadas
      thumbColor: mat.WidgetStateProperty.resolveWith<mat.Color?>((
        Set<mat.WidgetState> states,
      ) {
        if (isLightMode) {
          return mat.Colors.grey[700]; // Polegar escuro para modo claro
        }
        return mat.Colors.grey[400]; // Polegar claro para modo escuro
      }),
      trackColor: mat.WidgetStateProperty.resolveWith<mat.Color?>((
        Set<mat.WidgetState> states,
      ) {
        if (isLightMode) {
          return mat.Colors.grey[300]; // Trilha clara para modo claro
        }
        return mat.Colors.grey[800]; // Trilha escura para modo escuro
      }),
    );

    return mat.ScrollbarTheme(
      data: scrollbarThemeData,
      child: mat.Scrollbar(
        // O widget Scrollbar em si. Ele pegará os estilos do ScrollbarTheme.
        // Não é necessário definir as propriedades de estilo aqui novamente,
        // a menos que queira sobrescrever algo específico para esta instância,
        // o que geralmente não é o caso quando se usa ScrollbarTheme.
        child: mat.GridView.builder(
          // GridView.builder é o filho do Scrollbar
          padding: const mat.EdgeInsets.fromLTRB(
            8.0,
            4.0,
            8.0,
            8.0,
          ), // Padding ajustado (topo reduzido)
          gridDelegate: mat.SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                widget.orientation == wdg.Orientation.portrait
                    ? 8 // 8 ícones por linha no modo retrato
                    : 6, // 6 ícones por linha no modo paisagem
            childAspectRatio: 1.0, // Ícones quadrados
            mainAxisSpacing: 8.0,
            crossAxisSpacing:
                widget.orientation == wdg.Orientation.portrait ? 6.0 : 8.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final itemData = items[index];
            final String assetPath = itemData['path'] as String;
            final MapElementType elementType =
                itemData['type'] as MapElementType;
            // final String itemName = itemData['name'] as String; // Nome não é mais necessário para heróis na grade

            final double itemIconSize =
                widget.orientation == wdg.Orientation.portrait
                    ? 26.0
                    : 34.0; // Ícone do herói maior em paisagem
            final double feedbackIconSize = itemIconSize + 5.0;

            // Renderizar apenas o ícone do herói, menor
            return mat.Draggable<Map<String, dynamic>>(
              data: {
                'path': assetPath,
                'type': elementType,
                // Adicionar 'team' se o DragTarget precisar diferenciar minions
                if (elementType == MapElementType.minion)
                  'team': itemData['team'],
              },
              onDragStarted: () {
                // Notifica o InteractiveMapScreen que um elemento começou a ser arrastado
                widget.onDraggableElementDragStarted?.call();
              },
              dragAnchorStrategy: wdg.pointerDragAnchorStrategy,
              feedbackOffset: mat.Offset(
                -feedbackIconSize / 2,
                -feedbackIconSize / 2,
              ),
              feedback: mat.Material(
                elevation: 6.0, // Sombra um pouco mais destacada
                color: gameUITransparentColor,
                child: mat.Opacity(
                  opacity: 0.9, // Opacidade um pouco maior para o feedback
                  child: mat.Container(
                    width: feedbackIconSize,
                    height: feedbackIconSize,
                    decoration: mat.BoxDecoration(
                      borderRadius: mat.BorderRadius.circular(
                        6.0,
                      ), // Bordas mais arredondadas
                      image: mat.DecorationImage(
                        image: mat.AssetImage(assetPath),
                        fit: mat.BoxFit.contain,
                      ),
                      boxShadow: [
                        // Adiciona uma sombra sutil para destacar
                        mat.BoxShadow(
                          color: mat.Colors.black.withAlpha(
                            (255 * 0.5).round(),
                          ), // Corrigido
                          blurRadius: 4,
                          offset: const mat.Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              childWhenDragging: mat.Opacity(
                opacity: 0.4, // Mais transparente quando arrastando
                child: _buildItemIcon(
                  assetPath,
                  itemIconSize,
                  isDragging: true,
                ),
              ),
              child: _buildItemIcon(assetPath, itemIconSize),
            );
          },
        ),
      ),
    );
  }

  mat.Widget _buildSectionToggleTabs(mat.BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return mat.Padding(
      padding: const mat.EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ), // Padding vertical reduzido
      child: mat.Row(
        mainAxisAlignment:
            mat.MainAxisAlignment.spaceEvenly, // Distribuição mais uniforme
        children: [
          _buildSectionTab(
            context,
            l10n.heroisSecao,
            _SidebarSection.heroes,
            mat.Icons.people_alt_outlined,
          ),
          _buildSectionTab(
            context,
            l10n.minionsSecao,
            _SidebarSection.minions,
            mat.Icons.smart_toy_outlined,
          ),
        ],
      ),
    );
  }

  mat.Widget _buildSectionTab(
    mat.BuildContext context,
    String title,
    _SidebarSection section,
    mat.IconData icon,
  ) {
    final bool isSelected = _activeSection == section;
    return mat.Expanded(
      // Para que as abas ocupem espaço similar
      child: mat.InkWell(
        onTap: () {
          setState(() {
            if (_activeSection != section) {
              _activeSection = section;
              if (section == _SidebarSection.heroes) {
                _selectedMinionTeam = null;
              } else if (section == _SidebarSection.minions) {
                _selectedRoute = null;
              }
            }
          });
        },
        borderRadius: mat.BorderRadius.circular(8.0), // Borda para o InkWell
        child: mat.Container(
          padding: const mat.EdgeInsets.symmetric(
            vertical: 6.0, // Padding vertical interno reduzido
            horizontal: 10.0,
          ),
          // margin: const mat.EdgeInsets.symmetric(horizontal: 4.0,
          decoration: mat.BoxDecoration(
            color:
                isSelected
                    ? gameUISelectedItemColor
                    : gameUIContentBgColor, // Cor de fundo da aba
            borderRadius: mat.BorderRadius.circular(8.0),
            border: mat.Border.all(
              // Borda sutil para abas não selecionadas
              color: isSelected ? gameUISelectedItemColor : gameUIBorderColor,
              width: 1,
            ),
          ),
          child: mat.Row(
            mainAxisAlignment: mat.MainAxisAlignment.center,
            children: [
              mat.Icon(
                icon,
                size: 20, // Tamanho do ícone
                color:
                    isSelected
                        ? gameUISelectedItemTextIconColor
                        : gameUIDefaultIconColor,
              ),
              const mat.SizedBox(width: 8),
              mat.Flexible(
                // Adicionado Flexible em volta do Text
                child: mat.Text(
                  title,
                  style: mat.TextStyle(
                    fontSize: 14, // Tamanho da fonte
                    fontWeight:
                        isSelected
                            ? mat.FontWeight.bold
                            : mat.FontWeight.normal,
                    color:
                        isSelected
                            ? gameUISelectedItemTextIconColor
                            : gameUIDefaultTextColor,
                  ),
                  overflow:
                      mat
                          .TextOverflow
                          .ellipsis, // Opcional: para textos muito longos
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  mat.Widget _buildItemIcon(
    String assetPath,
    double iconSize, {
    bool isDragging = false,
  }) {
    return mat.Container(
      width: iconSize,
      height: iconSize,
      decoration: mat.BoxDecoration(
        color:
            isDragging // Corrigido
                ? gameUIDefaultIconColor.withAlpha((255 * 0.1).round())
                : gameUITransparentColor, // Fundo sutil se estiver sendo arrastado do local original
        borderRadius: mat.BorderRadius.circular(
          6.0,
        ), // Bordas mais arredondadas
        border: mat.Border.all(
          color: gameUIBorderColor, // Cor da borda padrão
          width: 1.0, // Espessura da borda
        ),
        image: mat.DecorationImage(
          image: mat.AssetImage(assetPath),
          fit: mat.BoxFit.contain,
        ),
      ),
    );
  }

  mat.Widget _buildSingleRouteTabWidget(
    HeroRoute route,
    mat.BuildContext context,
  ) {
    final data = heroRouteData[route]!;
    final bool isSelected = _selectedRoute == route;
    final routeColor = data.color;

    return mat.InkWell(
      onTap: () {
        setState(() {
          if (_selectedRoute == route) {
            _selectedRoute = null;
          } else {
            _selectedRoute = route;
          }
        });
      },
      borderRadius: mat.BorderRadius.circular(8.0),
      child: mat.Container(
        margin: const mat.EdgeInsets.symmetric(
          horizontal: 0.0,
        ), // Mantido como 0 para Expanded funcionar bem
        padding: mat.EdgeInsets.all(
          // Padding interno ajustado pela orientação
          widget.orientation == wdg.Orientation.portrait ? 6.0 : 4.0,
        ),
        decoration: mat.BoxDecoration(
          color:
              isSelected
                  ? routeColor.withAlpha((255 * 0.9).round())
                  : gameUIContentBgColor,
          borderRadius: mat.BorderRadius.circular(8.0),
          border: mat.Border.all(
            color:
                isSelected
                    ? mat.Colors.white.withAlpha((255 * 0.8).round())
                    : gameUIBorderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow:
              isSelected
                  ? [
                    mat.BoxShadow(
                      color: routeColor.withAlpha((255 * 0.5).round()),
                      blurRadius: 6,
                      offset: const mat.Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: mat.Image.asset(
          mat.Theme.of(context).brightness == mat.Brightness.dark
              ? data.iconDarkPath
              : data.iconNormalPath,
          width:
              widget.orientation == wdg.Orientation.portrait
                  ? 36
                  : 38, // Aumentado um pouco mais para paisagem
          height:
              widget.orientation == wdg.Orientation.portrait
                  ? 36
                  : 38, // Aumentado um pouco mais para paisagem
          color: isSelected ? null : routeColor.withAlpha((255 * 0.7).round()),
          colorBlendMode: isSelected ? null : mat.BlendMode.srcATop,
        ),
      ),
    );
  }

  mat.Widget _buildRouteTabs(mat.BuildContext context) {
    return mat.Container(
      padding: const mat.EdgeInsets.only(
        top: 6.0,
        bottom: 6.0,
        left:
            0, // Reduzido o padding esquerdo para compensar a margin do item (era 8.0)
        right: 8.0,
      ),
      height:
          widget.orientation == wdg.Orientation.portrait
              ? 60 // Altura maior para modo retrato
              : 50, // Altura para modo paisagem
      child:
          widget.orientation == wdg.Orientation.portrait
              ? mat.Row(
                children:
                    HeroRoute.values
                        .map(
                          (route) => mat.Expanded(
                            child: _buildSingleRouteTabWidget(route, context),
                          ),
                        )
                        .toList(),
              )
              : mat.ListView.builder(
                padding: wdg.EdgeInsets.zero,
                scrollDirection: mat.Axis.horizontal,
                itemCount: HeroRoute.values.length,
                itemBuilder: (context, index) {
                  final route = HeroRoute.values[index];
                  // No ListView, não usamos Expanded, apenas o widget da aba.
                  return _buildSingleRouteTabWidget(route, context);
                },
              ),
    );
  }

  mat.Widget _buildMinionTeamTabs(mat.BuildContext context) {
    // Supondo que MinionTeam.values e minionTeamDisplayInfo estão definidos
    // e minionTeamDisplayInfo[team] tem .color
    return mat.Container(
      padding: const mat.EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 8.0,
      ), // Padding vertical reduzido
      height: 52, // Altura reduzida
      child: mat.ListView.builder(
        scrollDirection: mat.Axis.horizontal,
        itemCount: MinionTeam.values.length,
        itemBuilder: (context, index) {
          final team = MinionTeam.values[index];
          final data = minionTeamDisplayInfo[team]!; // Assumindo que não é nulo
          final bool isSelected = _selectedMinionTeam == team;
          final teamColor = data.color;

          return mat.InkWell(
            onTap: () {
              setState(() {
                if (_selectedMinionTeam == team) {
                  _selectedMinionTeam = null;
                } else {
                  _selectedMinionTeam = team;
                }
              });
            },
            borderRadius: mat.BorderRadius.circular(
              25.0,
            ), // Para um círculo perfeito no InkWell
            child: mat.Container(
              margin: const mat.EdgeInsets.symmetric(horizontal: 6.0),
              padding: const mat.EdgeInsets.all(
                4.0, // Padding para a borda de seleção
              ),
              decoration: mat.BoxDecoration(
                color:
                    isSelected
                        ? teamColor.withAlpha((255 * 0.3).round()) // Corrigido
                        : gameUITransparentColor, // Corrigido
                shape:
                    mat
                        .BoxShape
                        .circle, // Garante que a decoração seja circular
                border: mat.Border.all(
                  color: isSelected ? teamColor : gameUIBorderColor,
                  width: isSelected ? 2.5 : 1.5,
                ),
              ),
              child: mat.CircleAvatar(
                backgroundColor: teamColor,
                radius: 16, // Raio do círculo de cor
                child:
                    isSelected
                        ? mat.Icon(
                          mat.Icons.check,
                          size: 18,
                          color: mat.Colors.white.withAlpha(
                            (255 * 0.9).round(),
                          ), // Corrigido
                        )
                        : null,
              ),
            ),
          );
        },
      ),
    );
  }

  mat.Widget _buildMinimizedContent(
    mat.BuildContext context,
    wdg.Orientation orientation,
  ) {
    final l10n = AppLocalizations.of(context);
    final List<mat.Widget> toolButtons = [
      _buildToolIconButton(
        context: context,
        icon: mat.Icons.brush,
        tooltip: l10n.pincel,
        toolType: MapElementType.drawingTool,
        isActive: widget.activeToolType == MapElementType.drawingTool,
        onPressed:
            () => widget.onToolSelected?.call(MapElementType.drawingTool),
      ),
      _buildToolIconButton(
        context: context,
        icon: mat.Icons.cleaning_services,
        tooltip: l10n.borracha,
        toolType: MapElementType.eraserTool,
        isActive: widget.activeToolType == MapElementType.eraserTool,
        onPressed: () => widget.onToolSelected?.call(MapElementType.eraserTool),
      ),
      _buildToolIconButton(
        context: context,
        icon: mat.Icons.text_fields,
        tooltip: l10n.texto,
        toolType: MapElementType.textTool,
        isActive: widget.activeToolType == MapElementType.textTool,
        onPressed: () => widget.onToolSelected?.call(MapElementType.textTool),
      ),
      _buildColorIconButton(
        context: context,
        tooltip: l10n.corDoPincel,
        currentColor: widget.currentDrawingColor,
        onTap: widget.onDrawingColorSelectRequest ?? () {},
        toolIcon: mat.Icons.brush,
        toolIconTooltip: l10n.corDoPincel,
      ),
      _buildColorIconButton(
        context: context,
        tooltip: l10n.corDoTexto,
        currentColor: widget.currentTextColor,
        toolIcon: mat.Icons.text_fields,
        toolIconTooltip: l10n.corDoTexto,
        onTap: widget.onTextColorSelectRequest ?? () {},
      ),
      _buildToolIconButton(
        context: context,
        icon: mat.Icons.delete_sweep,
        tooltip: l10n.limparTudo,
        toolType: MapElementType.clearTool,
        isActive: false, // A ferramenta de limpar não fica "ativa"
        onPressed: () => widget.onToolSelected?.call(MapElementType.clearTool),
      ),
    ];

    if (orientation == wdg.Orientation.portrait) {
      // Layout horizontal para modo retrato minimizado (barra inferior)
      return mat.SingleChildScrollView(
        scrollDirection: mat.Axis.horizontal,
        padding: const mat.EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: mat.Row(
          mainAxisAlignment:
              mat.MainAxisAlignment.spaceAround, // Alinhar à esquerda
          crossAxisAlignment: mat.CrossAxisAlignment.center,
          // mainAxisAlignment: mat.MainAxisAlignment.spaceAround, // Ou .start
          children:
              toolButtons
                  .map(
                    (button) => mat.Padding(
                      padding: const mat.EdgeInsets.symmetric(horizontal: 4.0),
                      child: button,
                    ),
                  )
                  .toList()
                ..add(
                  mat.Padding(
                    padding: const mat.EdgeInsets.only(right: 10),
                    child:
                        wdg.SizedBox.shrink(), // SizedBox.shrink() is effectively an empty widget
                  ),
                ),
        ),
      );
    } else {
      // Layout vertical para modo paisagem minimizado (barra lateral esquerda)
      return mat.Padding(
        padding: const mat.EdgeInsets.symmetric(vertical: 8.0),
        child: mat.SingleChildScrollView(
          // Adicionado SingleChildScrollView
          child: mat.Column(
            mainAxisAlignment: mat.MainAxisAlignment.start,
            crossAxisAlignment: mat.CrossAxisAlignment.center,
            children: <mat.Widget>[
              const mat.SizedBox(
                height: 2,
              ), // Espaço no topo da lista de ferramentas reduzido
              ...toolButtons.expand(
                (button) => [
                  button,
                  const mat.SizedBox(height: 10), // Espaço entre botões
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  mat.Widget _buildToolIconButton({
    required mat.BuildContext context,
    required mat.IconData icon,
    required String tooltip,
    required MapElementType
    toolType, // Não usado diretamente no estilo, mas mantido para lógica
    required bool isActive,
    required void Function() onPressed,
  }) {
    return mat.IconButton(
      icon: mat.Icon(icon),
      iconSize: isActive ? 28 : 24, // Ícone um pouco maior se ativo
      color:
          isActive ? gameUISelectedItemTextIconColor : gameUIDefaultIconColor,
      tooltip: tooltip,
      style: mat.IconButton.styleFrom(
        // Adiciona um estilo base
        backgroundColor:
            isActive
                ? gameUISelectedItemColor.withAlpha(
                  (255 * 0.15).round(),
                ) // Corrigido
                : gameUITransparentColor, // Corrigido
        padding: const mat.EdgeInsets.all(
          10.0,
        ), // Padding para aumentar a área de toque
        side:
            isActive
                ? mat.BorderSide(color: gameUISelectedItemColor, width: 1)
                : const mat.BorderSide(color: gameUIBorderColor, width: 1),
      ).copyWith(
        foregroundColor: mat.WidgetStateProperty.resolveWith<mat.Color?>((
          Set<mat.WidgetState> states,
        ) {
          // if (states.contains(mat.WidgetState.pressed)) {
          //   return isActive
          //       ? gameUISelectedItemTextIconColor.withAlpha((255 * 0.8).round())
          //       : gameUIDefaultIconColor.withAlpha((255 * 0.8).round());
          // }
          return isActive
              ? gameUISelectedItemTextIconColor
              : gameUIDefaultIconColor;
        }),
        backgroundColor: mat.WidgetStateProperty.resolveWith<mat.Color?>((
          Set<mat.WidgetState> states,
        ) {
          if (states.contains(mat.WidgetState.pressed)) {
            return isActive
                ? gameUISelectedItemColor.withAlpha((255 * 0.25).round())
                : gameUIBorderColor.withAlpha((255 * 0.5).round());
          }
          return isActive
              ? gameUISelectedItemColor.withAlpha((255 * 0.15).round())
              : gameUITransparentColor;
        }),
      ),
      onPressed: onPressed,
    );
  }

  mat.Widget _buildColorIconButton({
    required mat.BuildContext context,
    required String tooltip,
    required mat.Color currentColor,
    required mat.IconData toolIcon,
    required String
    toolIconTooltip, // Mantido para consistência, mas tooltip principal é no wrapper
    required mat.VoidCallback onTap,
  }) {
    return mat.Tooltip(
      message: tooltip,
      child: mat.InkWell(
        onTap: onTap,
        borderRadius: mat.BorderRadius.circular(24),
        child: mat.Container(
          width: 48,
          height: 48,
          alignment: mat.Alignment.center,
          decoration: mat.BoxDecoration(
            // Adiciona uma borda sutil ao redor do InkWell
            shape: mat.BoxShape.circle,
            border: mat.Border.all(color: gameUIBorderColor, width: 1),
            color: gameUIContentBgColor.withAlpha(
              (255 * 0.5).round(),
            ), // Corrigido // Um fundo sutil
          ),
          child: mat.Stack(
            alignment: mat.Alignment.center,
            children: [
              mat.Container(
                width:
                    26, // Círculo de cor um pouco menor para caber o ícone sobreposto melhor
                height: 26,
                decoration: mat.BoxDecoration(
                  color: currentColor,
                  shape: mat.BoxShape.circle,
                  border: mat.Border.all(
                    color: mat.Colors.white.withAlpha(
                      (255 * 0.7).round(),
                    ), // Corrigido // Borda branca para destacar a cor
                    width: 1.5,
                  ),
                ),
              ),
              mat.Icon(
                // Ícone sobreposto para indicar a qual ferramenta a cor se aplica
                toolIcon,
                size: 16,
                color:
                    currentColor.computeLuminance() > 0.5
                        ? mat.Colors.black87
                        : mat
                            .Colors
                            .white, // Cor do ícone contrasta com a cor de fundo
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  mat.Widget build(mat.BuildContext context) {
    return mat.Container(
      decoration: mat.BoxDecoration(
        // Volta a usar a cor de fundo do scaffold do tema para a sidebar inteira
        color: mat.Theme.of(context).scaffoldBackgroundColor,
        // A largura é controlada pelo widget pai (InteractiveMapScreen)
      ),
      // O padding é aplicado dentro de _buildMinimizedContent ou _buildExpandedContent
      // conforme necessário para cada layout.
      clipBehavior: mat.Clip.antiAlias,
      child:
          widget
                  .isExpanded // Usar widget.isExpanded
              ? _buildExpandedContent(context)
              : _buildMinimizedContent(context, widget.orientation),
    );
  }
}
