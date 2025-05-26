// c:\Users\jkesl\mapahok\lib\features\interactive_map\widgets\map_painter.dart
import 'dart:math'; // For pi
import 'package:flutter/material.dart';
import 'package:mapahok/features/interactive_map/models/map_element.dart';
import 'package:mapahok/features/interactive_map/notifiers/map_state_notifier.dart';

class MapPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final Path? currentPath;
  final Color currentDrawingColorForPath;
  final double currentStrokeWidthForPath;
  final Path? currentEraserPath;
  final double currentMapScale;
  final bool isMapFlipped;
  final double currentEraserBrushRadius;
  final List<MapTextElement> texts;
  final double logicalMapWidth; // Nova propriedade
  final double logicalMapHeight; // Nova propriedade

  MapPainter({
    required this.paths,
    required this.texts,
    this.currentPath,
    this.currentEraserPath,
    required this.currentEraserBrushRadius,
    required this.currentDrawingColorForPath,
    required this.currentStrokeWidthForPath,
    required this.currentMapScale,
    required this.isMapFlipped,
    required this.logicalMapWidth, // Adicionar ao construtor
    required this.logicalMapHeight, // Adicionar ao construtor
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double effectiveScale =
        currentMapScale.isFinite && currentMapScale > 0.00001
            ? currentMapScale
            : 1.0;

    // Camada para desenho, para que o BlendMode.clear funcione corretamente
    // O 'size' aqui é o _displayedMapWidth, _displayedMapHeight
    canvas.saveLayer(Offset.zero & size, Paint());

    // Calcular o fator de escala do lógico para o display
    final double scaleX = size.width / logicalMapWidth;
    final double scaleY = size.height / logicalMapHeight;

    canvas.save(); // Salva o estado antes de escalar
    canvas.scale(scaleX, scaleY); // Escala o canvas

    // 1. Desenhar caminhos salvos
    for (var drawingPath in paths) {
      final paint =
          Paint()
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

      if (drawingPath.isEraser) {
        paint
          ..blendMode = BlendMode.clear
          ..style = PaintingStyle.fill
          // strokeWidth para eraser é mais um raio de preenchimento,
          // já está em unidades lógicas, será escalado pelo canvas.scale
          ..strokeWidth = (drawingPath.strokeWidth);
      } else {
        paint
          ..color = drawingPath.color
          ..strokeWidth =
              drawingPath.strokeWidth /
              effectiveScale // strokeWidth em unidades lógicas, ajustado pelo zoom do IV
          ..style = PaintingStyle.stroke
          ..blendMode = BlendMode.srcOver;
      }
      canvas.drawPath(drawingPath.path, paint);
    }

    // 2. Desenhar caminho de tinta atual (em progresso)
    if (currentPath != null && currentEraserPath == null) {
      final currentPaint =
          Paint()
            ..color = currentDrawingColorForPath
            ..strokeWidth = currentStrokeWidthForPath / effectiveScale
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..blendMode = BlendMode.srcOver;
      canvas.drawPath(currentPath!, currentPaint);
    }
    // 3. Desenhar caminho de borracha atual (em progresso)
    else if (currentEraserPath != null && currentPath == null) {
      final currentEraserPaint =
          Paint()
            ..blendMode = BlendMode.clear
            ..style = PaintingStyle.fill;
      canvas.drawPath(currentEraserPath!, currentEraserPaint);
    }

    // 4. Desenhar textos
    for (var textElement in texts) {
      final textStyle = TextStyle(
        color: textElement.color,
        // fontSize em unidades lógicas, ajustado pelo zoom do IV
        fontSize: textElement.fontSize / effectiveScale,
        fontFamily: 'Radikal',
        fontWeight: FontWeight.bold,
      );
      final textSpan = TextSpan(text: textElement.text, style: textStyle);

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      // maxWidth para layout do texto deve ser em unidades lógicas escaladas pelo zoom do IV
      textPainter.layout(
        minWidth: 0,
        maxWidth: (logicalMapWidth / scaleX) * effectiveScale,
      );

      final outlineStyle = textStyle.copyWith(
        foreground:
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth =
                  (1.5 /
                      effectiveScale) // strokeWidth em unidades lógicas, ajustado pelo zoom do IV
              ..color = Color.fromARGB((0.8 * 255).round(), 0, 0, 0),
      );
      final outlineTextSpan = TextSpan(
        text: textElement.text,
        style: outlineStyle,
      );
      final outlineTextPainter = TextPainter(
        text: outlineTextSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      outlineTextPainter.layout(
        minWidth: 0,
        maxWidth: (logicalMapWidth / scaleX) * effectiveScale,
      );

      // Posição do canto superior esquerdo do texto no sistema de coordenadas lógico do mapa
      final Offset textTopLeft = textElement.position;

      // Calcular o centro do texto para rotação (baseado nas dimensões do textPainter principal)
      // textPainter.width e textPainter.height são as dimensões do texto após o layout,
      // e já estão na escala correta para o desenho no canvas (após canvas.scale(scaleX, scaleY)).
      final double textCenterX = textTopLeft.dx + textPainter.width / 2;
      final double textCenterY = textTopLeft.dy + textPainter.height / 2;

      if (isMapFlipped) {
        canvas.save();
        // Mover a origem do canvas para o centro lógico do texto
        canvas.translate(textCenterX, textCenterY);
        // Rotacionar o canvas localmente por PI (180 graus)
        // Isso anula a rotação global do mapa para este texto
        canvas.rotate(pi);

        // A origem do canvas agora está no centro lógico do texto, e o sistema de coordenadas local está "de cabeça para cima".
        // Para desenhar o texto (e seu contorno) de forma que ele apareça centralizado
        // em torno desta nova origem, precisamos desenhá-los em (-width/2, -height/2).
        outlineTextPainter.paint(
          canvas,
          Offset(-outlineTextPainter.width / 2, -outlineTextPainter.height / 2),
        );
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );

        canvas.restore();
      } else {
        // Desenhar normalmente, com o canto superior esquerdo em textTopLeft (coordenadas lógicas)
        outlineTextPainter.paint(canvas, textTopLeft);
        textPainter.paint(canvas, textTopLeft);
      }
    }

    canvas.restore(); // Restaura do canvas.scale(scaleX, scaleY)
    canvas.restore(); // Restaura da saveLayer para blend modes
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.paths != paths ||
        oldDelegate.texts != texts ||
        oldDelegate.currentPath != currentPath ||
        oldDelegate.currentEraserPath != currentEraserPath ||
        oldDelegate.currentEraserBrushRadius != currentEraserBrushRadius ||
        oldDelegate.currentMapScale != currentMapScale ||
        oldDelegate.isMapFlipped != isMapFlipped ||
        oldDelegate.currentDrawingColorForPath != currentDrawingColorForPath ||
        oldDelegate.currentStrokeWidthForPath != currentStrokeWidthForPath ||
        oldDelegate.logicalMapWidth != logicalMapWidth || // Checar novas props
        oldDelegate.logicalMapHeight != logicalMapHeight; // Checar novas props
  }
}
