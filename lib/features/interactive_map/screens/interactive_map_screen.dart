import 'package:flutter/material.dart';
import 'package:mapahok/features/interactive_map/widgets/elements_sidebar.dart';
import 'package:mapahok/features/interactive_map/models/map_element.dart';
import 'package:provider/provider.dart';
import 'package:mapahok/features/interactive_map/notifiers/map_state_notifier.dart'; // Para DrawingPath
import 'package:mapahok/features/interactive_map/widgets/map_painter.dart';
import 'package:flutter/services.dart'; // Para SystemChrome
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math'; // Para min() e pi
import 'package:mapahok/core/notifiers/theme_notifier.dart';
// Importe as localizações geradas (caminho de importação atualizado)
import 'package:mapahok/l10n/app_localizations.dart';

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  // Dimensões lógicas da imagem do mapa
  static const double _mapImageWidth = 4288.0;
  static const double _mapImageHeight = 3695.0;

  // Constantes para a barra lateral em modo paisagem
  static const double expandedSidebarWidthLandscape = 250.0;
  static const double minimizedSidebarWidthLandscape = 72.0;

  // Constantes para a barra lateral em modo retrato
  static const double expandedSidebarHeightPortrait = 300.0; // Altura aumentada
  static const double minimizedSidebarHeightPortrait = 115.0;
  // Aumentar a altura da barra minimizada (era 100.0)

  bool _isMapFlipped = false;
  bool _isSidebarExpanded = true; // Começa expandida por padrão
  MapElementType? _activeToolType;
  Color _currentDrawingColor = Colors.red;
  Color _currentTextColor = Colors.blue;
  final double _currentStrokeWidth = 5.0;

  final List<PlacedMapElement> _placedElements = [];
  final List<DrawingPath> _drawingPaths = [];
  final List<MapTextElement> _textElements = [];

  bool _disableMapInteraction = false;
  Path? _currentDrawingPath;
  Path? _currentEraserPath;
  final double _currentEraserBrushRadius = 10.0;
  MapTextElement? _draggingTextElement;

  final GlobalKey _mapAreaKey = GlobalKey();
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _interactiveViewerKey = GlobalKey();
  final GlobalKey _mapContentStackKey = GlobalKey();
  Key _customPaintKey = UniqueKey();
  Offset? _pendingTextTapPosition;
  final Set<int> _activePointerIds = {};

  @override
  void initState() {
    super.initState();
    // Garantir que esta tela permita todas as orientações
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        if (mounted && _interactiveViewerKey.currentContext != null) {
          _transformationController.value = _calculateCenteringMatrix();
        }
      });
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    // Ao sair desta tela, a MainMenuScreen (se for o destino)
    // irá redefinir a orientação para retrato em seu initState.
    // Se houver outros cenários de navegação, pode ser necessário
    // redefinir as orientações aqui de forma mais específica.
    // Por enquanto, deixar que a próxima tela gerencie está ok,
    // já que MainMenuScreen faz isso.
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  void _toggleSidebar() {
    final Matrix4 currentTransform = _transformationController.value.clone();
    final double actualCurrentScale = currentTransform.storage[0];
    final BuildContext? ivContext = _interactiveViewerKey.currentContext;
    Offset? topLeftVisibleInChildCoords;

    if (ivContext != null) {
      final RenderBox ivRenderBox = ivContext.findRenderObject() as RenderBox;
      final Size oldViewerSize = ivRenderBox.size;
      if (oldViewerSize.width > 0 && oldViewerSize.height > 0) {
        const Offset topLeftInViewerCoords = Offset.zero;
        if (actualCurrentScale.abs() > 1e-9) {
          try {
            final Matrix4 invertedCurrentTransform = Matrix4.inverted(
              currentTransform,
            );
            topLeftVisibleInChildCoords = MatrixUtils.transformPoint(
              invertedCurrentTransform,
              topLeftInViewerCoords,
            );
          } catch (e) {
            topLeftVisibleInChildCoords = null;
          }
        }
      }
    }
    setState(() => _isSidebarExpanded = !_isSidebarExpanded);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          final BuildContext? newIvContext =
              _interactiveViewerKey.currentContext;
          if (newIvContext != null && topLeftVisibleInChildCoords != null) {
            final RenderBox newIvRenderBox =
                newIvContext.findRenderObject() as RenderBox;
            final Size newViewerSize = newIvRenderBox.size;

            if (newViewerSize.width > 0 && newViewerSize.height > 0) {
              final double scale = actualCurrentScale;
              if (scale.abs() > 1e-9) {
                final double tx = -scale * topLeftVisibleInChildCoords.dx;
                final double ty = -scale * topLeftVisibleInChildCoords.dy;
                _transformationController.value =
                    Matrix4.identity()
                      ..translate(tx, ty)
                      ..scale(scale, scale);
              } else {
                _transformationController.value = currentTransform;
              }
            } else {
              _transformationController.value = currentTransform;
            }
          } else {
            _transformationController.value = currentTransform;
          }
        }
      });
    });
  }

  Future<void> _openColorPicker({
    required String title,
    required Color currentColor,
    required ValueSetter<Color> onColorSelected,
  }) async {
    Color pickerColor = currentColor;
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use o l10n do contexto do diálogo para as strings do diálogo
        final l10nDialog = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10nDialog.cancelButtonLabel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10nDialog.selectButtonLabel),
              onPressed: () {
                onColorSelected(pickerColor);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDraggableElementDragStarted() {
    // Se uma ferramenta que requer modo exclusivo (desenho, borracha, texto) estiver ativa,
    // desative-a para permitir que o mapa receba corretamente o item arrastado
    // e para evitar que a ferramenta interfira.
    if (_activeToolType == MapElementType.drawingTool ||
        _activeToolType == MapElementType.eraserTool ||
        _activeToolType == MapElementType.textTool) {
      setState(() {
        _activeToolType = null; // Desativa a ferramenta.
        // Quando uma ferramenta que desabilita a interação do mapa é desligada,
        // e não estamos em outro estado que desabilita a interação (como arrastar texto ou multi-toque),
        // reabilite a interação do mapa.
        if (_draggingTextElement == null && _activePointerIds.isEmpty) {
          _disableMapInteraction = false;
        }
      });
    }
    // Se _activeToolType já for nulo, ou alguma ferramenta não exclusiva, nenhuma mudança de estado é necessária aqui
    // em relação à desativação da ferramenta para este problema específico.
  }

  void _handleToolSelection(MapElementType toolType) {
    setState(() {
      if (toolType == MapElementType.clearTool) {
        _showClearAllConfirmationDialog(); // Alterado para mostrar diálogo de confirmação
        // _activeToolType = null; // Não desativa imediatamente, espera confirmação
      } else if (_activeToolType == toolType) {
        _activeToolType = null;
      } else {
        _activeToolType = toolType;
      }

      if (_activeToolType == MapElementType.drawingTool ||
          _activeToolType == MapElementType.eraserTool ||
          _activeToolType == MapElementType.textTool) {
        _disableMapInteraction = true;
      } else if (_activeToolType == null &&
          _draggingTextElement == null &&
          _activePointerIds.isEmpty) {
        _disableMapInteraction = false;
      }
    });
  }

  void _clearAllMapElements() {
    setState(() {
      _drawingPaths.clear();
      _textElements.clear();
      _placedElements.clear();
      _currentDrawingPath = null;
      _currentEraserPath = null;
      _customPaintKey = UniqueKey();
    });
  }

  Future<void> _showClearAllConfirmationDialog() async {
    final l10n = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.confirmarLimpeza),
          content: Text(l10n.confirmarLimparTudoDialogoMensagem),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancelar),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.limparOpcao),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _clearAllMapElements();
      setState(() {
        _activeToolType = null; // Desativa a ferramenta de limpar após o uso
      });
    }
  }

  Matrix4 _calculateCenteringMatrix() {
    if (!mounted) return Matrix4.identity();
    final BuildContext? ivContext = _interactiveViewerKey.currentContext;
    if (ivContext == null) return Matrix4.identity();

    final RenderBox ivRenderBox = ivContext.findRenderObject() as RenderBox;
    final Size ivSize = ivRenderBox.size;
    const Size contentBaseSize = Size(_mapImageWidth, _mapImageHeight);

    if (contentBaseSize.width <= 0 ||
        contentBaseSize.height <= 0 ||
        ivSize.width <= 0 ||
        ivSize.height <= 0) {
      return Matrix4.identity();
    }

    final double scaleX = ivSize.width / contentBaseSize.width;
    final double scaleY = ivSize.height / contentBaseSize.height;
    final double scaleToFit = min(scaleX, scaleY);
    const double desiredMinimumVisibleScale = 0.6;
    double finalAppliedScale = max(
      scaleToFit,
      desiredMinimumVisibleScale,
    ).clamp(0.1, 5.0);

    if (finalAppliedScale <= 0 ||
        finalAppliedScale.isNaN ||
        finalAppliedScale.isInfinite) {
      return Matrix4.identity();
    }

    final double scaledContentWidth = contentBaseSize.width * finalAppliedScale;
    final double scaledContentHeight =
        contentBaseSize.height * finalAppliedScale;
    final double finalTranslateX = (ivSize.width - scaledContentWidth) / 2.0;
    final double finalTranslateY = (ivSize.height - scaledContentHeight) / 2.0;

    return Matrix4.identity()
      ..translate(finalTranslateX, finalTranslateY)
      ..scale(finalAppliedScale, finalAppliedScale);
  }

  Offset _screenToMapCoordinates(Offset screenPosition) {
    final Matrix4 ivInverseMatrix = Matrix4.inverted(
      _transformationController.value,
    );
    Offset positionOnSizedBox = MatrixUtils.transformPoint(
      ivInverseMatrix,
      screenPosition,
    );
    Offset logicalPosition = positionOnSizedBox;

    if (_isMapFlipped) {
      logicalPosition = Offset(
        _mapImageWidth - logicalPosition.dx,
        _mapImageHeight - logicalPosition.dy,
      );
    }
    return logicalPosition;
  }

  Rect _getTextBounds(MapTextElement textElement) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: textElement.text,
        style: TextStyle(
          fontSize: textElement.fontSize,
          fontFamily: 'Radikal',
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return Rect.fromLTWH(
      textElement.position.dx,
      textElement.position.dy,
      textPainter.width,
      textPainter.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double currentMapScale =
        _transformationController.value.storage[0].isFinite &&
                _transformationController.value.storage[0] > 0.00001
            ? _transformationController.value.storage[0]
            : 1.0;
    final l10n = AppLocalizations.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final Orientation orientation = MediaQuery.of(context).orientation;

    Widget mapInteractiveWidget = Expanded(
      child: DragTarget<Map<String, dynamic>>(
        key: _mapAreaKey,
        onWillAcceptWithDetails:
            (details) =>
                details.data['type'] == MapElementType.hero ||
                details.data['type'] == MapElementType.minion,
        onAcceptWithDetails: (details) {
          final data = details.data;
          final String assetPath = data['path'] as String;
          final MapElementType elementType = data['type'] as MapElementType;
          final BuildContext? ivContext = _interactiveViewerKey.currentContext;
          if (ivContext == null) {
            return;
          }

          final RenderBox ivRenderBox =
              ivContext.findRenderObject() as RenderBox;
          final Offset localOffsetInViewer = ivRenderBox.globalToLocal(
            details.offset,
          );
          final Offset originalPosition = _screenToMapCoordinates(
            localOffsetInViewer,
          );

          setState(() {
            _placedElements.add(
              PlacedMapElement(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                assetPath: assetPath,
                position: originalPosition,
                type: elementType,
                borderColor: null,
                size:
                    elementType == MapElementType.minion
                        ? const Size(70, 70)
                        : const Size(50, 50),
              ),
            );
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              _activePointerIds.add(event.pointer);
              final Offset mapTouchPosition = _screenToMapCoordinates(
                event.localPosition,
              );
              bool hitDraggableElement = false;

              if (_activeToolType == null ||
                  _activeToolType == MapElementType.hero ||
                  _activeToolType == MapElementType.minion) {
                for (final element in List.from(_placedElements).reversed) {
                  final Rect originalElementBounds = Rect.fromCenter(
                    center: element.position,
                    width: element.size.width,
                    height: element.size.height,
                  );
                  final Rect tappableOriginalElementRect = originalElementBounds
                      .inflate(5.0 * (1 / currentMapScale));
                  if (tappableOriginalElementRect.contains(mapTouchPosition)) {
                    hitDraggableElement = true;
                    break;
                  }
                }
              }
              if (!hitDraggableElement &&
                  (_activeToolType == null ||
                      _activeToolType == MapElementType.textTool)) {
                for (final textEl in _textElements) {
                  if (_getTextBounds(textEl).contains(mapTouchPosition)) {
                    hitDraggableElement = true;
                    break;
                  }
                }
              }

              final bool toolRequiresExclusiveMode =
                  _activeToolType == MapElementType.drawingTool ||
                  _activeToolType == MapElementType.eraserTool ||
                  (_activeToolType == MapElementType.textTool &&
                      !hitDraggableElement);

              final bool shouldDisableMapInteraction =
                  hitDraggableElement || toolRequiresExclusiveMode;

              if (_disableMapInteraction != shouldDisableMapInteraction) {
                setState(
                  () => _disableMapInteraction = shouldDisableMapInteraction,
                );
              }

              if (_activePointerIds.length > 1) {
                if (_currentDrawingPath != null) _cancelDrawing();
                if (_currentEraserPath != null) _cancelEraser();
                _pendingTextTapPosition = null;
                if (_disableMapInteraction) {
                  setState(() => _disableMapInteraction = false);
                }
                return;
              }

              if (toolRequiresExclusiveMode && !hitDraggableElement) {
                if (_activeToolType == MapElementType.drawingTool) {
                  _handleDrawingStart(event.localPosition);
                } else if (_activeToolType == MapElementType.eraserTool) {
                  _handleEraserStart(event.localPosition);
                  _eraseTextNearPoint(mapTouchPosition, currentMapScale);
                } else if (_activeToolType == MapElementType.textTool) {
                  _pendingTextTapPosition = mapTouchPosition;
                }
              }
            },
            onPointerMove: (event) {
              if (_activePointerIds.length > 1 ||
                  !_activePointerIds.contains(event.pointer) ||
                  _draggingTextElement != null) {
                return;
              }
              final Offset mapMovePosition = _screenToMapCoordinates(
                event.localPosition,
              );
              if (_activeToolType == MapElementType.drawingTool &&
                  _currentDrawingPath != null) {
                _handleDrawingMove(event.localPosition);
              } else if (_activeToolType == MapElementType.eraserTool &&
                  _currentEraserPath != null) {
                _handleEraserMove(event.localPosition);
                _eraseTextNearPoint(mapMovePosition, currentMapScale);
              }
            },
            onPointerUp: (event) {
              if (!_activePointerIds.contains(event.pointer)) return;

              bool wasDrawing =
                  _currentDrawingPath != null && _activePointerIds.length == 1;
              bool wasErasing =
                  _currentEraserPath != null && _activePointerIds.length == 1;
              bool wasPendingText =
                  _pendingTextTapPosition != null &&
                  _activePointerIds.length == 1;

              _activePointerIds.remove(event.pointer);

              if (wasDrawing && _activeToolType == MapElementType.drawingTool) {
                _handleDrawingEnd();
              } else if (wasErasing &&
                  _activeToolType == MapElementType.eraserTool) {
                _handleEraserEnd();
              } else if (wasPendingText &&
                  _activeToolType == MapElementType.textTool &&
                  _draggingTextElement == null) {
                _showTextDialog(position: _pendingTextTapPosition!);
                _pendingTextTapPosition = null;
              }

              if (_activePointerIds.isEmpty && _draggingTextElement == null) {
                final bool toolRequiresExclusiveMode =
                    _activeToolType == MapElementType.drawingTool ||
                    _activeToolType == MapElementType.eraserTool ||
                    _activeToolType == MapElementType.textTool;

                if (_disableMapInteraction && !toolRequiresExclusiveMode) {
                  setState(() => _disableMapInteraction = false);
                } else if (_disableMapInteraction &&
                    toolRequiresExclusiveMode &&
                    _activeToolType != null) {
                  // Mantém desabilitado
                } else if (_disableMapInteraction) {
                  setState(() => _disableMapInteraction = false);
                }
              }
            },
            onPointerCancel: (event) {
              if (!_activePointerIds.contains(event.pointer)) return;
              _activePointerIds.remove(event.pointer);
              if (_currentDrawingPath != null) _cancelDrawing();
              if (_currentEraserPath != null) _cancelEraser();
              _pendingTextTapPosition = null;

              if (_activePointerIds.isEmpty && _draggingTextElement == null) {
                if (_disableMapInteraction) {
                  setState(() => _disableMapInteraction = false);
                }
              }
            },
            child: InteractiveViewer(
              key: _interactiveViewerKey,
              transformationController: _transformationController,
              panEnabled: !_disableMapInteraction,
              constrained: false,
              scaleEnabled: !_disableMapInteraction,
              boundaryMargin: EdgeInsets.zero,
              alignment: Alignment.topLeft,
              minScale: 0.1,
              maxScale: 5.0,
              child: AnimatedSwitcher(
                key: ValueKey<bool>(_isMapFlipped),
                duration: Duration.zero,
                child:
                    _isMapFlipped
                        ? Transform(
                          key: const ValueKey<String>('flipped_map_content'),
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(pi),
                          child: Stack(
                            key: _mapContentStackKey,
                            children: _buildMapContent(currentMapScale),
                          ),
                        )
                        : Stack(
                          key: const ValueKey<String>('normal_map_content'),
                          children: _buildMapContent(currentMapScale),
                        ),
              ),
            ),
          );
        },
      ),
    );

    Widget bodyContent;

    if (orientation == Orientation.landscape) {
      bodyContent = Row(
        children: [
          SizedBox(
            width:
                _isSidebarExpanded
                    ? expandedSidebarWidthLandscape
                    : minimizedSidebarWidthLandscape,
            child: Column(
              children: [
                Padding(
                  // Ajustar o padding para posicionar o botão mais acima
                  padding: const EdgeInsets.symmetric(
                    vertical: 1.0,
                  ), // Espaço vertical do botão reduzido
                  child: IconButton(
                    icon: Icon(
                      _isSidebarExpanded
                          ? Icons
                              .keyboard_arrow_left // Ícone para recolher painel lateral
                          : Icons
                              .keyboard_arrow_right, // Ícone para expandir painel lateral
                    ),
                    tooltip:
                        _isSidebarExpanded
                            ? l10n.toolTipCollapseSidePanel
                            : l10n.toolTipExpandSidePanel,
                    onPressed: _toggleSidebar,
                  ),
                ),
                // const Spacer(), // Removido para o botão subir, ou ajustar conforme necessário
                Expanded(
                  child: ElementsSidebar(
                    orientation: orientation, // Passar a orientação
                    isExpanded: _isSidebarExpanded,
                    activeToolType: _activeToolType,
                    currentDrawingColor: _currentDrawingColor,
                    currentTextColor: _currentTextColor,
                    onToolSelected: _handleToolSelection,
                    onDrawingColorSelectRequest:
                        () => _openColorPicker(
                          title: l10n.corDoPincel,
                          currentColor: _currentDrawingColor,
                          onColorSelected:
                              (color) =>
                                  setState(() => _currentDrawingColor = color),
                        ),
                    onTextColorSelectRequest:
                        () => _openColorPicker(
                          title: l10n.corDoTexto,
                          currentColor: _currentTextColor,
                          onColorSelected:
                              (color) =>
                                  setState(() => _currentTextColor = color),
                        ),
                    onClearAllHeroIcons: _showClearAllConfirmationDialog,
                    onDraggableElementDragStarted:
                        _handleDraggableElementDragStarted,
                  ),
                ),
              ],
            ),
          ),
          mapInteractiveWidget,
        ],
      );
    } else {
      // Modo Retrato
      bodyContent = Column(
        children: [
          mapInteractiveWidget, // Mapa em cima
          SizedBox(
            height:
                _isSidebarExpanded
                    ? expandedSidebarHeightPortrait
                    : minimizedSidebarHeightPortrait,
            width: double.infinity, // Ocupa toda a largura
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      _isSidebarExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                    ),
                    tooltip:
                        _isSidebarExpanded
                            ? l10n.toolTipCollapseBottomPanel
                            : l10n.toolTipExpandBottomPanel,
                    onPressed: _toggleSidebar,
                  ), // Closes IconButton
                ), // Closes Align
                const SizedBox(height: 1),
                Expanded(
                  child: ElementsSidebar(
                    orientation: orientation, // Passar a orientação
                    isExpanded: _isSidebarExpanded,
                    activeToolType: _activeToolType,
                    currentDrawingColor: _currentDrawingColor,
                    currentTextColor: _currentTextColor,
                    onToolSelected: _handleToolSelection,
                    onDrawingColorSelectRequest:
                        () => _openColorPicker(
                          title: l10n.corDoPincel,
                          currentColor: _currentDrawingColor,
                          onColorSelected:
                              (color) =>
                                  setState(() => _currentDrawingColor = color),
                        ),
                    onTextColorSelectRequest:
                        () => _openColorPicker(
                          title: l10n.corDoTexto,
                          currentColor: _currentTextColor,
                          onColorSelected:
                              (color) =>
                                  setState(() => _currentTextColor = color),
                        ),
                    onClearAllHeroIcons: _showClearAllConfirmationDialog,
                    onDraggableElementDragStarted:
                        _handleDraggableElementDragStarted,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(l10n.mapaInterativo),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.toolTipBackToMenu,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isMapFlipped
                  ? Icons.flip_camera_android_outlined
                  : Icons.flip_camera_android,
            ),
            tooltip: l10n.moverZoom, // Using existing key for map manipulation
            onPressed: () {
              setState(() {
                _isMapFlipped = !_isMapFlipped;
                // Inverte as coordenadas de todos os elementos ao virar o mapa
                for (int i = 0; i < _placedElements.length; i++) {
                  final element = _placedElements[i];
                  _placedElements[i] = element.copyWith(
                    position: Offset(
                      _mapImageWidth - element.position.dx,
                      _mapImageHeight - element.position.dy,
                    ),
                  );
                }

                for (int i = 0; i < _textElements.length; i++) {
                  final textEl = _textElements[i];
                  _textElements[i] = textEl.copyWith(
                    position: Offset(
                      _mapImageWidth - textEl.position.dx,
                      _mapImageHeight - textEl.position.dy,
                    ),
                  );
                }

                // Inverter caminhos desenhados é mais complexo e pode exigir transformar cada ponto do Path.
                // Por simplicidade, podemos optar por não inverter os desenhos ou limpá-los.
                // Aqui, vamos apenas forçar uma repintura.
                _customPaintKey = UniqueKey();

                if (_interactiveViewerKey.currentContext != null) {
                  _transformationController.value = _calculateCenteringMatrix();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(
              themeNotifier.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip:
                themeNotifier.themeMode == ThemeMode.dark
                    ? l10n.toolTipChangeToLightMode
                    : l10n.toolTipChangeToDarkMode,
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
      body: bodyContent,
    );
  }

  List<Widget> _buildMapContent(double currentMapScale) {
    return [
      Positioned.fill(
        child: Image.asset('assets/images/map.png', fit: BoxFit.fill),
      ),
      CustomPaint(
        size: const Size(_mapImageWidth, _mapImageHeight),
        key: _customPaintKey,
        isComplex: true,
        painter: MapPainter(
          paths: _drawingPaths,
          texts: _textElements, // Passar os textos para o MapPainter
          currentPath: _currentDrawingPath,
          currentEraserPath: _currentEraserPath,
          currentEraserBrushRadius: _currentEraserBrushRadius,
          currentDrawingColorForPath: _currentDrawingColor,
          isMapFlipped: _isMapFlipped,
          currentStrokeWidthForPath: _currentStrokeWidth,
          currentMapScale: currentMapScale,
          logicalMapWidth: _mapImageWidth,
          logicalMapHeight: _mapImageHeight,
        ),
      ),
      ..._placedElements.map((element) {
        // .toList() removido daqui
        return Positioned(
          left: element.position.dx - (element.size.width / 2),
          top: element.position.dy - (element.size.height / 2),
          width: element.size.width,
          height: element.size.height,
          child: Transform.scale(
            scale: 1.0 / currentMapScale,
            alignment: Alignment.center,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) {
                if (_activePointerIds.length > 1) return;

                // Desativa a ferramenta ativa (desenho, borracha, texto)
                // ao começar a arrastar um elemento já posicionado no mapa.
                _handleDraggableElementDragStarted();

                setState(() => _disableMapInteraction = true);
              },
              onPanUpdate: (details) {
                if (_activePointerIds.length > 1) return;
                Offset logicalDelta = Offset(
                  details.delta.dx / currentMapScale,
                  details.delta.dy / currentMapScale,
                );
                if (element.type == MapElementType.minion) {
                  logicalDelta = logicalDelta / 1.5;
                }
                if (_isMapFlipped) {
                  logicalDelta = Offset(-logicalDelta.dx, -logicalDelta.dy);
                }

                setState(() {
                  final int index = _placedElements.indexWhere(
                    (e) => e.id == element.id,
                  );
                  if (index != -1) {
                    _placedElements[index] = _placedElements[index].copyWith(
                      position: _placedElements[index].position + logicalDelta,
                    );
                  }
                });
              },
              onPanEnd: (_) {
                if (_activePointerIds.length > 1) return;
                final bool toolRequiresExclusiveMode =
                    _activeToolType == MapElementType.drawingTool ||
                    _activeToolType == MapElementType.eraserTool ||
                    _activeToolType == MapElementType.textTool;

                if (!toolRequiresExclusiveMode) {
                  setState(() => _disableMapInteraction = false);
                }
              },
              onDoubleTap: () {
                setState(() {
                  final int index = _placedElements.indexWhere(
                    (e) => e.id == element.id,
                  );
                  if (index != -1 && element.type == MapElementType.hero) {
                    Color? nextBorderColor;
                    if (element.borderColor == null) {
                      nextBorderColor = Colors.blue;
                    } else if (element.borderColor == Colors.blue) {
                      nextBorderColor = Colors.red;
                    } else {
                      nextBorderColor = null;
                    }
                    _placedElements[index] = element.copyWith(
                      borderColor: nextBorderColor,
                    );
                  }
                });
              },
              child: Transform.rotate(
                angle: _isMapFlipped ? pi : 0.0,
                alignment: Alignment.center,
                child: Container(
                  width: element.size.width,
                  height: element.size.height,
                  decoration: BoxDecoration(
                    shape:
                        element.type == MapElementType.hero
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                    border:
                        element.borderColor != null
                            ? Border.all(
                              color: element.borderColor!,
                              width: 1.5,
                            )
                            : null,
                  ),
                  child:
                      element.type == MapElementType.hero
                          ? ClipOval(
                            child: Image.asset(
                              element.assetPath,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Image.asset(element.assetPath, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      }),
      // Os MapTextElements agora são desenhados pelo MapPainter
    ];
  }

  void _handleDrawingStart(Offset screenPosition) {
    final Offset mapPosition = _screenToMapCoordinates(screenPosition);
    setState(() {
      _currentDrawingPath = Path()..moveTo(mapPosition.dx, mapPosition.dy);
      _customPaintKey = UniqueKey();
    });
  }

  void _handleDrawingMove(Offset screenPosition) {
    if (_currentDrawingPath == null) return;
    final Offset mapPosition = _screenToMapCoordinates(screenPosition);
    setState(() {
      _currentDrawingPath!.lineTo(mapPosition.dx, mapPosition.dy);
      _customPaintKey = UniqueKey();
    });
  }

  void _handleDrawingEnd() {
    if (_currentDrawingPath == null) return;
    setState(() {
      _drawingPaths.add(
        DrawingPath(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          path: _currentDrawingPath!,
          color: _currentDrawingColor,
          strokeWidth: _currentStrokeWidth,
          isEraser: false,
        ),
      );
      _currentDrawingPath = null;
      _customPaintKey = UniqueKey();
    });
  }

  void _cancelDrawing() {
    setState(() {
      _currentDrawingPath = null;
      _customPaintKey = UniqueKey();
    });
  }

  void _handleEraserStart(Offset screenPosition) {
    final double effectiveRadius =
        _currentEraserBrushRadius /
        (_transformationController.value.storage[0].isFinite &&
                _transformationController.value.storage[0] > 0.00001
            ? _transformationController.value.storage[0]
            : 1.0);
    final mapPosition = _screenToMapCoordinates(screenPosition);
    setState(() {
      _currentEraserPath =
          Path()..addOval(
            Rect.fromCircle(center: mapPosition, radius: effectiveRadius),
          );
      _customPaintKey = UniqueKey();
    });
  }

  void _handleEraserMove(Offset screenPosition) {
    if (_currentEraserPath == null) return;
    final double effectiveRadius =
        _currentEraserBrushRadius /
        (_transformationController.value.storage[0].isFinite &&
                _transformationController.value.storage[0] > 0.00001
            ? _transformationController.value.storage[0]
            : 1.0);
    final mapPosition = _screenToMapCoordinates(screenPosition);
    setState(() {
      _currentEraserPath = Path.combine(
        PathOperation.union,
        _currentEraserPath!,
        Path()..addOval(
          Rect.fromCircle(center: mapPosition, radius: effectiveRadius),
        ),
      );
      _customPaintKey = UniqueKey();
    });
  }

  void _handleEraserEnd() {
    if (_currentEraserPath == null) return;
    setState(() {
      _drawingPaths.add(
        DrawingPath(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          path: _currentEraserPath!,
          color: Colors.transparent,
          strokeWidth: _currentEraserBrushRadius * 2,
          isEraser: true,
        ),
      );
      _currentEraserPath = null;
      _customPaintKey = UniqueKey();
    });
  }

  void _cancelEraser() {
    setState(() {
      _currentEraserPath = null;
      _customPaintKey = UniqueKey();
    });
  }

  Future<void> _showTextDialog({
    MapTextElement? existingElement,
    Offset? position,
  }) async {
    final l10n = AppLocalizations.of(context);
    final bool isEditing = existingElement != null;
    final TextEditingController textController = TextEditingController(
      text: isEditing ? existingElement.text : "",
    );
    final String? newText = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? l10n.editarTexto : l10n.adicionarTexto),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.digiteOTexto),
            onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
          ),
          actions: <Widget>[
            if (isEditing)
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(l10n.remover),
                onPressed: () {
                  Navigator.of(dialogContext).pop('__DELETE__');
                },
              ),
            TextButton(
              child: Text(l10n.cancelar),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(isEditing ? l10n.salvar : l10n.adicionar),
              onPressed:
                  () => Navigator.of(dialogContext).pop(textController.text),
            ),
          ],
        );
      },
    );

    if (newText != null) {
      if (newText == '__DELETE__' && isEditing) {
        setState(
          () => _textElements.removeWhere((e) => e.id == existingElement.id),
        );
      } else if (newText.isNotEmpty) {
        setState(() {
          if (isEditing) {
            final index = _textElements.indexWhere(
              (e) => e.id == existingElement.id,
            );
            if (index != -1) {
              _textElements[index] = existingElement.copyWith(text: newText);
            }
          } else if (position != null) {
            _textElements.add(
              MapTextElement(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                text: newText,
                position: position,
                color: _currentTextColor,
                fontSize: 24.0,
              ),
            );
          }
        });
      } else if (newText.isEmpty && isEditing) {
        setState(
          () => _textElements.removeWhere((e) => e.id == existingElement.id),
        );
      }
    }
  }

  void _eraseTextNearPoint(Offset mapPosition, double currentMapScale) {
    if (_activeToolType != MapElementType.eraserTool) return;
    final double effectiveRadius =
        _currentEraserBrushRadius /
        (currentMapScale.isFinite && currentMapScale > 0.00001
            ? currentMapScale
            : 1.0);
    final eraserRect = Rect.fromCircle(
      center: mapPosition,
      radius: effectiveRadius,
    );

    final List<MapTextElement> textsToRemove = [];
    for (final textElement in _textElements) {
      final Rect textBounds = _getTextBounds(textElement);
      if (eraserRect.overlaps(textBounds)) {
        textsToRemove.add(textElement);
      }
    }
    if (textsToRemove.isNotEmpty) {
      setState(() {
        _textElements.removeWhere((element) => textsToRemove.contains(element));
      });
    }
  }
}
