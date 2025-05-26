// c:\Users\jkesl\mapahok\lib\features\interactive_map\widgets\draggable_map_item.dart
import 'package:mapahok/features/interactive_map/models/map_element.dart';

// Helper para capitalizar strings (pode ser movido para um arquivo de utils se preferir)
extension StringExtension on String {
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                  : '',
        )
        .join(' ');
  }
}

List<Map<String, dynamic>> _generateHeroAndToolItems() => [
  // Ferramentas (para a barra lateral minimizada e potencialmente outros usos)
  {
    'name': 'Pincel',
    'path': 'assets/tools/brush_icon.png', // Ajuste o caminho se necessário
    'type': MapElementType.drawingTool,
  },
  {
    'name': 'Apagador',
    'path': 'assets/tools/eraser_icon.png', // Ajuste o caminho se necessário
    'type': MapElementType.eraserTool,
  },
  {
    'name': 'Texto',
    'path': 'assets/tools/text_icon.png', // Ajuste o caminho se necessário
    'type': MapElementType.textTool,
  },
  {
    'name': 'Limpar',
    'path': 'assets/tools/clear_icon.png', // Ajuste o caminho se necessário
    'type': MapElementType.clearTool,
  },

  // Heróis organizados por rota
  // Certifique-se de que os caminhos ('path') para as imagens dos heróis estão corretos.
  // A convenção usada aqui é 'assets/icons/heroes/nome_do_heroi.png'.
  {
    'name': 'Allain',
    'path': 'assets/icons/heroes/allain.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Angela',
    'path': 'assets/icons/heroes/angela.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Arke',
    'path': 'assets/icons/heroes/arke.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Arthur',
    'path': 'assets/icons/heroes/arthur.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.jg],
  },
  {
    'name': 'Ata',
    'path': 'assets/icons/heroes/ata.jpg',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.jg],
  },
  {
    'name': 'Athena',
    'path': 'assets/icons/heroes/athena.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Augran',
    'path': 'assets/icons/heroes/augran.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg, HeroRoute.top],
  },
  {
    'name': 'Bai Qi',
    'path': 'assets/icons/heroes/baiqi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Dr. Bian',
    'path': 'assets/icons/heroes/bianque.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Biron',
    'path': 'assets/icons/heroes/biron.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Butterfly',
    'path': 'assets/icons/heroes/butterfly.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Cao Cao',
    'path': 'assets/icons/heroes/caocao.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  // {
  //   'name': 'Chang\'e',
  //   'path': 'assets/icons/heroes/change.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.jg, HeroRoute.top, HeroRoute.mid],
  // },
  {
    'name': 'Chano',
    'path': 'assets/icons/heroes/chano.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Charlotte',
    'path': 'assets/icons/heroes/charlotte.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Cirrus',
    'path': 'assets/icons/heroes/cirrus.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Consorte',
    'path': 'assets/icons/heroes/consorte.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Daji',
    'path': 'assets/icons/heroes/daji.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Da Qiao',
    'path': 'assets/icons/heroes/daqiao.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup, HeroRoute.mid],
  },
  {
    'name': 'Dharma',
    'path': 'assets/icons/heroes/dharma.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Dian Wei',
    'path': 'assets/icons/heroes/dianwei.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Diaochan',
    'path': 'assets/icons/heroes/diaochan.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.mid],
  },
  {
    'name': 'Di Renjie',
    'path': 'assets/icons/heroes/direnjie.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Dolia',
    'path': 'assets/icons/heroes/dolia.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Dun',
    'path': 'assets/icons/heroes/dun.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.jg, HeroRoute.sup],
  },
  // {
  //   'name': 'Dun Shan',
  //   'path': 'assets/icons/heroes/dunshan.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.sup],
  // },
  {
    'name': 'Dyadia',
    'path': 'assets/icons/heroes/dyadia.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Donghuang',
    'path': 'assets/icons/heroes/taiyi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup, HeroRoute.top],
  },
  {
    'name': 'Erin',
    'path': 'assets/icons/heroes/erin.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Fang',
    'path': 'assets/icons/heroes/fang.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc, HeroRoute.jg],
  },
  {
    'name': 'Feyd',
    'path': 'assets/icons/heroes/feyd.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Fuzi',
    'path': 'assets/icons/heroes/fuzi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Gan & Mo',
    'path': 'assets/icons/heroes/ganmo.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Gao Jianli',
    'path': 'assets/icons/heroes/gaojianli.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Garo',
    'path': 'assets/icons/heroes/garo.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  // {
  //   'name': 'Ge Ya',
  //   'path': 'assets/icons/heroes/geya.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.adc],
  // },
  {
    'name': 'Guan Yu',
    'path': 'assets/icons/heroes/guanyu.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Guiguzi',
    'path': 'assets/icons/heroes/guiguzi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  // {
  //   'name': 'Hai Yue',
  //   'path': 'assets/icons/heroes/haiyue.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.mid],
  // },
  {
    'name': 'Han Xin',
    'path': 'assets/icons/heroes/hanxin.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Heino',
    'path': 'assets/icons/heroes/heino.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid, HeroRoute.jg, HeroRoute.top],
  },
  {
    'name': 'Hou Yi',
    'path': 'assets/icons/heroes/houyi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Huang Zhong',
    'path': 'assets/icons/heroes/huangzhong.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  // {
  //   'name': 'Jin Chan',
  //   'path': 'assets/icons/heroes/jinchan.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.mid],
  // },
  {
    'name': 'Jing',
    'path': 'assets/icons/heroes/jing.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Kaizer',
    'path': 'assets/icons/heroes/kaiser.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg, HeroRoute.top],
  },
  // {
  //   'name': 'Kongkonger',
  //   'path': 'assets/icons/heroes/kongkonger.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.sup],
  // },
  {
    'name': 'Kongming',
    'path': 'assets/icons/heroes/kongming.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid, HeroRoute.jg],
  },
  {
    'name': 'Kui',
    'path': 'assets/icons/heroes/kui.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Lady Sun',
    'path': 'assets/icons/heroes/ladysun.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Lady Zhen',
    'path': 'assets/icons/heroes/ladyzhen.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Lam',
    'path': 'assets/icons/heroes/lam.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Lanling',
    'path': 'assets/icons/heroes/lanling.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg, HeroRoute.sup],
  },
  {
    'name': 'Liang',
    'path': 'assets/icons/heroes/liang.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid, HeroRoute.sup],
  },
  {
    'name': 'Lian Po',
    'path': 'assets/icons/heroes/lianpo.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.sup],
  },
  {
    'name': 'Li Bai',
    'path': 'assets/icons/heroes/libai.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Liu Bang',
    'path': 'assets/icons/heroes/liubang.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.sup],
  },
  {
    'name': 'Liu Bei',
    'path': 'assets/icons/heroes/liubei.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Liu Shan',
    'path': 'assets/icons/heroes/liushan.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Li Xin',
    'path': 'assets/icons/heroes/lixin.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Long',
    'path': 'assets/icons/heroes/loong.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Luara',
    'path': 'assets/icons/heroes/luara.jpg',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Luban',
    'path': 'assets/icons/heroes/luban.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Lu Bu',
    'path': 'assets/icons/heroes/lubu.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Luna',
    'path': 'assets/icons/heroes/luna.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  // {
  //   'name': 'Ma Chao',
  //   'path': 'assets/icons/heroes/machao.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top],
  // },
  {
    'name': 'Mai',
    'path': 'assets/icons/heroes/mai.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Marco Polo',
    'path': 'assets/icons/heroes/marcopolo.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Mayene',
    'path': 'assets/icons/heroes/mayene.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  // {
  //   'name': 'Meng Tian',
  //   'path': 'assets/icons/heroes/mengtian.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top],
  // },
  // {
  //   'name': 'Meng Xi',
  //   'path': 'assets/icons/heroes/mengxi.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.mid],
  // },
  {
    'name': 'Meng Ya',
    'path': 'assets/icons/heroes/mengya.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  {
    'name': 'Menki',
    'path': 'assets/icons/heroes/menki.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  // {
  //   'name': 'Mestre Luban',
  //   'path': 'assets/icons/heroes/mestreluban.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.sup],
  // },
  {
    'name': 'Milady',
    'path': 'assets/icons/heroes/milady.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Ming',
    'path': 'assets/icons/heroes/ming.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Mi Yue',
    'path': 'assets/icons/heroes/miyue.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.jg],
  },
  {
    'name': 'Mozi',
    'path': 'assets/icons/heroes/mozi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup, HeroRoute.mid],
  },
  {
    'name': 'Mulan',
    'path': 'assets/icons/heroes/mulan.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Musashi',
    'path': 'assets/icons/heroes/musashi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Nakoruru',
    'path': 'assets/icons/heroes/nakoruru.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Nezha',
    'path': 'assets/icons/heroes/nezha.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.jg],
  },
  // {
  //   'name': 'Niu Mo',
  //   'path': 'assets/icons/heroes/niumo.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.sup],
  // },
  {
    'name': 'Nuwa',
    'path': 'assets/icons/heroes/nuwa.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  // {
  //   'name': 'Pangu',
  //   'path': 'assets/icons/heroes/pangu.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.jg, HeroRoute.top],
  // },
  {
    'name': 'Pei',
    'path': 'assets/icons/heroes/pei.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Princesa Gélida',
    'path': 'assets/icons/heroes/princesagelida.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Sakeer',
    'path': 'assets/icons/heroes/sakeer.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  // {
  //   'name': 'Shadow',
  //   'path': 'assets/icons/heroes/shadow.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top],
  // },
  {
    'name': 'Shangguan',
    'path': 'assets/icons/heroes/shangguan.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Shi',
    'path': 'assets/icons/heroes/shi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Shouyue',
    'path': 'assets/icons/heroes/shouyue.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.adc],
  },
  // {
  //   'name': 'Sikong',
  //   'path': 'assets/icons/heroes/sikong.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top],
  // },
  {
    'name': 'Sima Yi',
    'path': 'assets/icons/heroes/simayi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  // {
  //   'name': 'Su Li',
  //   'path': 'assets/icons/heroes/sulie.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.sup],
  // },
  {
    'name': 'Sun Bin',
    'path': 'assets/icons/heroes/sunbin.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Sun Ce',
    'path': 'assets/icons/heroes/sunce.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.jg],
  },
  {
    'name': 'Ukyo',
    'path': 'assets/icons/heroes/ukyo.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top, HeroRoute.jg],
  },
  {
    'name': 'Wenji',
    'path': 'assets/icons/heroes/wenji.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Wukong',
    'path': 'assets/icons/heroes/wukong.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Wuyan',
    'path': 'assets/icons/heroes/wuyan.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  // {
  //   'name': 'Wu Zetian',
  //   'path': 'assets/icons/heroes/wuzetian.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.mid],
  // },
  {
    'name': 'Xiang Yu',
    'path': 'assets/icons/heroes/xiangyu.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Xiao Qiao',
    'path': 'assets/icons/heroes/xiaoqiao.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Xuance',
    'path': 'assets/icons/heroes/xuance.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  {
    'name': 'Yan Jiang',
    'path': 'assets/icons/heroes/yangjiang.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.top],
  },
  {
    'name': 'Yao',
    'path': 'assets/icons/heroes/yao.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  // {
  //   'name': 'Yaojin',
  //   'path': 'assets/icons/heroes/yaojin.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top],
  // },
  {
    'name': 'Yaria',
    'path': 'assets/icons/heroes/yaria.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup],
  },
  {
    'name': 'Ying',
    'path': 'assets/icons/heroes/ying.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg],
  },
  // {
  //   'name': 'Ying Zheng',
  //   'path': 'assets/icons/heroes/yingzheng.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.mid],
  // },
  // {
  //   'name': 'Yuan Ge',
  //   'path': 'assets/icons/heroes/yuange.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top],
  // },
  // {
  //   'name': 'Yuan Liu',
  //   'path': 'assets/icons/heroes/yuanliu.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top, HeroRoute.mid, HeroRoute.sup, HeroRoute.adc],
  // },
  {
    'name': 'Yuhuan',
    'path': 'assets/icons/heroes/yuhuan.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg, HeroRoute.mid],
  },
  // {
  //   'name': 'Zhang Fei', // Zhang Fei também estava na lista para ocultar, mas não tinha 'isHidden'
  //   'path': 'assets/icons/heroes/zhangfei.png',
  //   'type': MapElementType.hero,
  //   'route': [HeroRoute.sup],
  // },
  // {
  //   'name': 'Zhao Huaizhen',
  //   'path': 'assets/icons/heroes/zhaohuaizhen.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.top],
  // },
  // {
  //   'name': 'Zhenren',
  //   'path': 'assets/icons/heroes/zhenren.png',
  //   'type': MapElementType.hero,
  //   // 'isHidden': true, // Comentado para ocultar
  //   'route': [HeroRoute.sup],
  // },
  {
    'name': 'Zhou Yu',
    'path': 'assets/icons/heroes/zhouyu.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid],
  },
  {
    'name': 'Zhuangzi',
    'path': 'assets/icons/heroes/zhuangzi.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.sup, HeroRoute.top],
  },
  {
    'name': 'Zilong',
    'path': 'assets/icons/heroes/zilong.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.jg, HeroRoute.top],
  },
  {
    'name': 'Ziya',
    'path': 'assets/icons/heroes/ziya.png',
    'type': MapElementType.hero,
    'route': [HeroRoute.mid, HeroRoute.sup],
  },

  // Minions - Time Azul
  {
    'name': 'Canhão Azul',
    'path': 'assets/icons/minions/bluecannon.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.blue,
  },
  {
    'name': 'Mago Azul',
    'path': 'assets/icons/minions/bluemage.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.blue,
  },
  {
    'name': 'Guerreiro Azul',
    'path': 'assets/icons/minions/bluemelee.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.blue,
  },
  {
    'name': 'Super Minion Azul',
    'path': 'assets/icons/minions/bluesuper.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.blue,
  },
  // Adicione outros minions azuis aqui se necessário

  // Minions - Time Vermelho
  {
    'name': 'Canhão Vermelho',
    'path': 'assets/icons/minions/redcannon.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.red,
  },
  {
    'name': 'Mago Vermelho',
    'path': 'assets/icons/minions/redmage.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.red,
  },
  {
    'name': 'Guerreiro Vermelho',
    'path': 'assets/icons/minions/redmelee.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.red,
  },
  {
    'name': 'Super Minion Vermelho',
    'path': 'assets/icons/minions/redsuper.PNG',
    'type': MapElementType.minion,
    'team': MinionTeam.red,
  },
  // Adicione outros minions vermelhos aqui se necessário
];

// Combina todos os itens
final List<Map<String, dynamic>> draggableItemsData = [
  ..._generateHeroAndToolItems(),
  // A função _generateMinionItems() foi removida,
  // os minions agora estão incluídos em _generateHeroAndToolItems()
];

// Lembre-se de que o enum HeroRoute e MapElementType devem estar definidos em:
// c:\Users\jkesl\mapahok\lib\features\interactive_map\models\map_element.dart
// Exemplo de como HeroRoute pode ser definido:
/*
enum HeroRoute {
  top,
  mid,
  adc,
  sup,
  jg,
}

enum MapElementType {
  hero,
  minion, // Exemplo
  monster, // Exemplo
  drawingTool,
  eraserTool,
  textTool,
  clearTool,
  // Adicione outros tipos conforme necessário
}
*/
