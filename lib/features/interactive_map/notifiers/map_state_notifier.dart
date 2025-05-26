// c:\Users\jkesl\mapahok\lib\features\interactive_map\notifiers\map_state_notifier.dart
import 'package:flutter/material.dart';
import 'package:mapahok/features/interactive_map/models/map_element.dart';
import 'package:uuid/uuid.dart';

class DrawingPath {
  final String id; // Adicionar o campo id
  final Path path;
  final Color color;
  final double strokeWidth;
  final bool isEraser; // Adicionar campo para distinguir traços de borracha

  DrawingPath({
    required this.id, // Adicionar o parâmetro id ao construtor
    required this.path,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false, // Padrão é false
  });
}

class MapStateNotifier extends ChangeNotifier {
  final List<PlacedMapElement> _placedElements = [];
  final TransformationController _transformationController =
      TransformationController();
  final Uuid _uuid = const Uuid(); // Instância do Uuid

  // Estados para ferramentas de desenho
  MapElementType? _activeTool;
  final List<DrawingPath> _drawnPaths = [];
  final List<MapTextElement> _placedTexts = [];
  Color _currentDrawingColor = Colors.red; // Cor padrão para desenho
  Color _currentTextColor =
      Colors.red; // Cor padrão para texto (pode ser diferente)
  double _currentStrokeWidth = 3.0; // Espessura padrão do traço
  double _currentEraserBrushRadius = 8.0; // Raio do "pincel" do apagador

  // Getters
  List<PlacedMapElement> get placedElements =>
      List.unmodifiable(_placedElements);
  TransformationController get transformationController =>
      _transformationController;
  MapElementType? get activeTool => _activeTool;
  List<DrawingPath> get drawnPaths => List.unmodifiable(_drawnPaths);
  List<MapTextElement> get placedTexts => List.unmodifiable(_placedTexts);
  Color get currentDrawingColor => _currentDrawingColor;
  Color get currentTextColor => _currentTextColor;
  double get currentStrokeWidth => _currentStrokeWidth;
  double get currentEraserBrushRadius => _currentEraserBrushRadius;

  void addElementOnMap(
    String assetPath,
    Offset globalPosition, // Posição do drop na tela
    MapElementType elementType,
    GlobalKey interactiveViewerKey, // Chave para converter coordenadas
  ) {
    final BuildContext? context = interactiveViewerKey.currentContext;
    if (context == null) {
      // print("Contexto do InteractiveViewerKey é nulo.");
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    // Converte a posição global do drop para uma posição local dentro do conteúdo do InteractiveViewer
    final Offset localPosition = renderBox.globalToLocal(globalPosition);

    _placedElements.add(
      PlacedMapElement(
        id: _uuid.v4(),
        assetPath: assetPath,
        position: localPosition, // Posição já é local para o conteúdo
        type: elementType,
        // O tamanho padrão é definido em PlacedMapElement
      ),
    );
    // print(
    //     "Elemento adicionado: $assetPath em $localPosition (global: $globalPosition)");
    notifyListeners();
  }

  void clearElements() {
    _placedElements.clear();
    notifyListeners();
  }

  // Métodos para ferramentas
  void setActiveTool(MapElementType? tool) {
    _activeTool = tool;
    notifyListeners();
  }

  void setCurrentDrawingColor(Color color) {
    _currentDrawingColor = color;
    notifyListeners();
  }

  void setCurrentTextColor(Color color) {
    _currentTextColor = color;
    notifyListeners();
  }

  void setCurrentEraserBrushRadius(double radius) {
    _currentEraserBrushRadius = radius;
    notifyListeners();
  }

  void setCurrentStrokeWidth(double width) {
    _currentStrokeWidth = width;
    notifyListeners();
  }

  void startDrawing(Offset startPoint) {
    if (_activeTool != MapElementType.drawingTool) {
      return;
    }
    // DEBUG: Confirmar início do desenho
    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    _drawnPaths.add(
      DrawingPath(
        id: _uuid.v4(), // Adicionar o ID aqui
        path: path,
        color: _currentDrawingColor,
        strokeWidth: _currentStrokeWidth,
      ),
    );
    notifyListeners();
  }

  void updateDrawing(Offset nextPoint) {
    if (_activeTool != MapElementType.drawingTool || _drawnPaths.isEmpty) {
      return;
    }
    // DEBUG: Confirmar atualização do desenho (pode ser verboso, mas útil inicialmente)
    // print("[MapStateNotifier] updateDrawing to $nextPoint");
    _drawnPaths.last.path.lineTo(nextPoint.dx, nextPoint.dy);
    notifyListeners();
  }

  void clearDrawings() {
    _drawnPaths.clear();
    notifyListeners();
  }

  void addTextElement(
    String text,
    Offset position,
    Color color,
    double fontSize,
  ) {
    if (text.isEmpty) {
      return;
    }
    _placedTexts.add(
      MapTextElement(
        id: _uuid.v4(),
        text: text,
        position: position,
        color: _currentTextColor, // Usar a cor de texto definida
        fontSize: fontSize,
      ),
    );
    // print("[MapStateNotifier] addTextElement: '$text' at $position with color $color",);
    notifyListeners();
  }

  void clearTexts() {
    _placedTexts.clear();
    notifyListeners();
    // print("[MapStateNotifier] clearTexts called.");
  }

  void eraseTextNearPoint(Offset erasePoint, double tapRadius) {
    if (_activeTool != MapElementType.eraserTool) {
      return;
    }

    // Define a área de toque para encontrar textos próximos
    final Rect tapRect = Rect.fromCircle(center: erasePoint, radius: tapRadius);
    MapTextElement? textToRemove;
    double closestDistance = double.infinity;

    // Encontra o texto mais próximo dentro do raio de toque
    for (final textElement in _placedTexts) {
      // Verifica se a posição do texto está dentro da área de toque
      if (tapRect.contains(textElement.position)) {
        final distance = (textElement.position - erasePoint).distance;
        if (distance < closestDistance) {
          closestDistance = distance;
          textToRemove = textElement;
        }
      }
    }

    if (textToRemove != null) {
      _placedTexts.remove(textToRemove);
      // print("[MapStateNotifier] Erased text at ${textToRemove.position}");
      notifyListeners();
    }
  }

  void eraseAtPoint(Offset erasePoint) {
    if (_activeTool != MapElementType.eraserTool) {
      return;
    }

    // Cria um retângulo pequeno representando a área do apagador
    final Path eraserBrushShape =
        Path()..addOval(
          Rect.fromCircle(
            center: erasePoint,
            radius: _currentEraserBrushRadius,
          ),
        );

    List<DrawingPath> updatedPaths = [];
    bool atLeastOnePathModified = false;

    for (final drawingPath in _drawnPaths) {
      // Calcula a diferença entre o caminho existente e a área do apagador
      Path resultPath = Path.combine(
        PathOperation.difference,
        drawingPath.path,
        eraserBrushShape,
      );

      // Verifica se o caminho resultante ainda tem conteúdo visível
      bool isEmpty = true;
      var metrics =
          resultPath
              .computeMetrics()
              .toList(); // Materializa a lista de métricas
      if (metrics.isNotEmpty) {
        for (var metric in metrics) {
          if (metric.length > 0.001) {
            // Um pequeno limiar para considerar não vazio
            isEmpty = false;
            break;
          }
        }
      }

      if (!isEmpty) {
        updatedPaths.add(
          DrawingPath(
            id:
                drawingPath
                    .id, // Preservar o ID original ou gerar um novo se for um "novo" segmento
            path: resultPath,
            color: drawingPath.color,
            strokeWidth: drawingPath.strokeWidth,
          ),
        );
        // Heurística para verificar se houve modificação real
        if (metrics.length != drawingPath.path.computeMetrics().length ||
            resultPath.getBounds() != drawingPath.path.getBounds()) {
          atLeastOnePathModified = true;
        }
      } else {
        // O caminho foi completamente apagado pela forma do apagador
        atLeastOnePathModified = true;
      }
    }

    // Apenas atualiza e notifica se houve uma mudança real no número de caminhos ou em algum caminho
    if (atLeastOnePathModified || updatedPaths.length != _drawnPaths.length) {
      _drawnPaths.clear();
      _drawnPaths.addAll(updatedPaths);
      // print("[MapStateNotifier] Applied eraser at $erasePoint. New path count: ${_drawnPaths.length}",);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }
}
