// c:\Users\jkesl\mapahok\lib\features\interactive_map\models\map_element.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // Importar para Color e Offset

// Tipos de elementos que podem ser colocados no mapa
enum MapElementType {
  hero,
  minion,
  monster,
  drawingTool,
  textTool,
  clearTool,
  eraserTool,
}

// Representa um elemento que foi colocado no mapa
class PlacedMapElement {
  final String id; // Identificador único
  final String assetPath; // Caminho para o ícone do asset
  final Offset
  position; // Posição no "mundo" do mapa (canto top esquerdo do ícone)
  final MapElementType type;
  final Color? borderColor; // Cor do contorno, nulo se não houver contorno
  final Size size; // Tamanho do ícone no mapa

  PlacedMapElement({
    required this.id,
    required this.assetPath,
    required this.position,
    required this.type,
    this.borderColor,
    this.size = const Size(40, 40), // Tamanho padrão para os ícones no mapa
  });

  PlacedMapElement copyWith({
    String? id,
    String? assetPath,
    Offset? position,
    MapElementType? type,
    Color? borderColor,
    Size? size,
  }) {
    return PlacedMapElement(
      id: id ?? this.id,
      assetPath: assetPath ?? this.assetPath,
      position: position ?? this.position,
      type: type ?? this.type,
      borderColor: borderColor ?? this.borderColor,
      size: size ?? this.size,
    );
  }
}

class MapTextElement {
  final String id;
  final String text;
  final Offset
  position; // Posição no "mundo" do mapa (canto top esquerdo do texto)
  final Color color;
  final double fontSize; // Tamanho da fonte em unidades lógicas do mapa

  MapTextElement({
    required this.id,
    required this.text,
    required this.position,
    required this.color,
    this.fontSize = 24.0, // Tamanho de fonte padrão (lógico)
  });

  MapTextElement copyWith({
    String? id,
    String? text,
    Offset? position,
    Color? color,
    double? fontSize,
  }) {
    return MapTextElement(
      id: id ?? this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

enum HeroRoute { top, jg, mid, adc, sup }

class RouteDisplayData {
  final String name;
  final String iconNormalPath;
  final String iconDarkPath;
  final Color color;
  final HeroRoute route;

  const RouteDisplayData({
    required this.name,
    required this.iconNormalPath,
    required this.iconDarkPath,
    required this.color,
    required this.route,
  });
}

// Dados para cada rota
final Map<HeroRoute, RouteDisplayData> heroRouteData = {
  HeroRoute.top: const RouteDisplayData(
    name: 'Superior',
    iconNormalPath: 'assets/icons/routes/top_normal.PNG',
    iconDarkPath: 'assets/icons/routes/top_dark.PNG',
    color: Color(0xFFc94cae),
    route: HeroRoute.top,
  ),
  HeroRoute.jg: const RouteDisplayData(
    name: 'Caça',
    iconNormalPath: 'assets/icons/routes/jg_normal.PNG',
    iconDarkPath: 'assets/icons/routes/jg_dark.PNG',
    color: Color(0xFFf8bc55),
    route: HeroRoute.jg,
  ),
  HeroRoute.mid: const RouteDisplayData(
    name: 'Meio',
    iconNormalPath: 'assets/icons/routes/mid_normal.PNG',
    iconDarkPath: 'assets/icons/routes/mid_dark.PNG',
    color: Color(0xFF00bf77),
    route: HeroRoute.mid,
  ),
  HeroRoute.adc: const RouteDisplayData(
    name: 'Inferior',
    iconNormalPath: 'assets/icons/routes/adc_normal.PNG',
    iconDarkPath: 'assets/icons/routes/adc_dark.PNG',
    color: Color(0xFFbc3a59),
    route: HeroRoute.adc,
  ),
  HeroRoute.sup: const RouteDisplayData(
    name: 'Suporte',
    iconNormalPath: 'assets/icons/routes/sup_normal.PNG',
    iconDarkPath: 'assets/icons/routes/sup_dark.PNG',
    color: Color(0xFF5f469f),
    route: HeroRoute.sup,
  ),
};

// Times dos Minions
enum MinionTeam { blue, red }

// Sufixos dos arquivos de imagem dos minions (sem a parte do time e extensão)
// Ex: 'cannonfront' para 'bluecannonfront.png' e 'redcannonfront.png'
const List<String> minionImageSuffixes = [
  'cannonfront',
  'magefront',
  'meleefront',
  'siegefront',
  // Adicione mais sufixos se tiver outros tipos de minions (ex: 'super')
  // ou variações (ex: 'cannonmid', 'cannonback')
];

class MinionTeamDisplayData {
  final String name;
  final Color color;
  final MinionTeam team;

  const MinionTeamDisplayData({
    required this.name,
    required this.color,
    required this.team,
  });
}

final Map<MinionTeam, MinionTeamDisplayData> minionTeamDisplayInfo = {
  MinionTeam.blue: const MinionTeamDisplayData(
    name: 'Time Azul',
    color: Color(0xFF0077C9), // Um tom de azul
    team: MinionTeam.blue,
  ),
  MinionTeam.red: const MinionTeamDisplayData(
    name: 'Time Vermelho',
    color: Color(0xFFD52B1E), // Um tom de vermelho
    team: MinionTeam.red,
  ),
};
