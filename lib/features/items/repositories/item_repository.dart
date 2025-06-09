// lib/features/items/repositories/item_repository.dart
import 'package:mapahok/features/items/models/item_category.dart';
import 'package:mapahok/features/items/models/item_model.dart';
import 'package:uuid/uuid.dart';

class ItemRepository {
  final Uuid _uuid = const Uuid();

  // Lista de simulação de itens
  // Em um app real, isso viria de um backend, arquivo local, ou manifesto de assets.
  // Os caminhos dos assets são exemplos.
  late final List<ItemModel> _allItems;

  ItemRepository() {
    _allItems = _generateMockItems();
  }

  List<ItemModel> _generateMockItems() {
    return [
      // Físico
      _createItem(
        'abóbada_celeste.png',
        'Abóbada Celeste',
        ItemCategory.physical,
      ),
      _createItem('adaga.png', 'Adaga', ItemCategory.physical),
      _createItem(
        'adaga_relâmpago.png',
        'Adaga Relâmpago',
        ItemCategory.physical,
      ),
      _createItem(
        'alma_de_sangue.png',
        'Alma de Sangue',
        ItemCategory.physical,
      ),
      _createItem('alvorada.png', 'Alvorada', ItemCategory.physical),
      _createItem('apocalipse.png', 'Apocalipse', ItemCategory.physical),
      _createItem(
        'arco_celestial.png',
        'Arco Celestial',
        ItemCategory.physical,
      ),
      _createItem('arco_solar.png', 'Arco Solar', ItemCategory.physical),
      _createItem('arma_solar.png', 'Arma Solar', ItemCategory.physical),
      _createItem('cerco_gélido.png', 'Cerco Gélido', ItemCategory.physical),
      _createItem('céu_limpo.png', 'Céu Limpo', ItemCategory.physical),
      _createItem('destino.png', 'Destino', ItemCategory.physical),
      _createItem('destruidor.png', 'Destruidor', ItemCategory.physical),
      _createItem(
        'espada_da_tempestade.png',
        'Espada da Tempestade',
        ItemCategory.physical,
      ),
      _createItem(
        'espada_de_ferro.png',
        'Espada de Ferro',
        ItemCategory.physical,
      ),
      _createItem('espada_mestra.png', 'Espada Mestra', ItemCategory.physical),
      _createItem(
        'espadas_gêmeas_da_destruição.png',
        'Espadas Gêmeas da Destruição',
        ItemCategory.physical,
      ),
      _createItem(
        'foice_das_sombras.png',
        'Foice das Sombras',
        ItemCategory.physical,
      ),
      _createItem(
        'foice_vampirica.png',
        'Foice Vampírica',
        ItemCategory.physical,
      ),
      _createItem(
        'forjado_em_sonhos_perfura-céu.png',
        'Forjado em Sonhos - Perfura-céu',
        ItemCategory.physical,
      ),
      _createItem(
        'forjado_em_sonhos_tempestade.png',
        'Forjado em Sonhos - Tempestade',
        ItemCategory.physical,
      ),
      _createItem('garra_furiosa.png', 'Garra Furiosa', ItemCategory.physical),
      _createItem(
        'lâmina_do_trovão.png',
        'Lâmina do Trovão',
        ItemCategory.physical,
      ),
      _createItem('lâmina_eterna.png', 'Lâmina Eterna', ItemCategory.physical),
      _createItem('lâmina_mortal.png', 'Lâmina Mortal', ItemCategory.physical),
      _createItem(
        'lâmina_sangrenta.png',
        'Lâmina Sangrenta',
        ItemCategory.physical,
      ),
      _createItem(
        'lança_da_agilidade.png',
        'Lança da Agilidade',
        ItemCategory.physical,
      ),
      _createItem('lança_veloz.png', 'Lança Veloz', ItemCategory.physical),
      _createItem(
        'machado_do_tormento.png',
        'Machado do Tormento',
        ItemCategory.physical,
      ),
      _createItem(
        'manopla_do_pugilista.png',
        'Manopla do Pugilista',
        ItemCategory.physical,
      ),
      _createItem('meteoro.png', 'Meteoro', ItemCategory.physical),
      _createItem('piscina_solar.png', 'Piscina Solar', ItemCategory.physical),
      _createItem(
        'quebra_estrelas.png',
        'Quebra Estrelas',
        ItemCategory.physical,
      ),
      _createItem(
        'ruína_demoníaca.png',
        'Ruína Demoníaca',
        ItemCategory.physical,
      ),

      // Mágico
      _createItem(
        'amuleto_do_alquimista.png',
        'Amuleto do Alquimista',
        ItemCategory.magical,
      ),
      _createItem(
        'báculo_do_vácuo.png',
        'Báculo do Vácuo',
        ItemCategory.magical,
      ),
      _createItem('bastão_nebulon.png', 'Bastão Nebulon', ItemCategory.magical),
      _createItem(
        'cajado_peçonhento.png',
        'Cajado Peçonhento',
        ItemCategory.magical,
      ),
      _createItem(
        'cajados_da_feitiçaria.png',
        'Cajados da Feitiçaria',
        ItemCategory.magical,
      ),
      _createItem(
        'cálice_fragmentado.png',
        'Cálice Fragmentado',
        ItemCategory.magical,
      ),
      _createItem(
        'cetro_da_reverberação.png',
        'Cetro da Reverberação',
        ItemCategory.magical,
      ),
      _createItem(
        'cetro_primordial.png',
        'Cetro Primordial',
        ItemCategory.magical,
      ),
      _createItem(
        'códice_do_sábio.png',
        'Códice do Sábio',
        ItemCategory.magical,
      ),
      _createItem(
        'cristal_da_evolução.png',
        'Cristal da Evolução',
        ItemCategory.magical,
      ),
      _createItem('deusa_da_lua.png', 'Deusa da Lua', ItemCategory.magical),
      _createItem(
        'dominador_ardente.png',
        'Dominador Ardente',
        ItemCategory.magical,
      ),
      _createItem(
        'espada_da_glória.png',
        'Espada da Glória',
        ItemCategory.magical,
      ),
      _createItem(
        'fluxo_crepuscular.png',
        'Fluxo Crepuscular',
        ItemCategory.magical,
      ),
      _createItem('fúria_do_sábio.png', 'Fúria do Sábio', ItemCategory.magical),
      _createItem('grande_báculo.png', 'Grande Báculo', ItemCategory.magical),
      _createItem(
        'grimório_do_sangue.png',
        'Grimório do Sangue',
        ItemCategory.magical,
      ),
      _createItem('hálito_gelado.png', 'Hálito Gelado', ItemCategory.magical),
      _createItem('lâmina_dourada.png', 'Lâmina Dourada', ItemCategory.magical),
      _createItem(
        'livro_de_feitiços.png',
        'Livro de Feitiços',
        ItemCategory.magical,
      ),
      _createItem(
        'manto_da_ruptura.png',
        'Manto da Ruptura',
        ItemCategory.magical,
      ),
      _createItem(
        'máscara_da_agonia.png',
        'Máscara da Agonia',
        ItemCategory.magical,
      ),
      _createItem(
        'pedra_da_feitiçaria.png',
        'Pedra da Feitiçaria',
        ItemCategory.magical,
      ),
      _createItem('resplendor.png', 'Resplendor', ItemCategory.magical),
      _createItem(
        'safira_brilhante.png',
        'Safira Brilhante',
        ItemCategory.magical,
      ),
      _createItem('santo_graal.png', 'Santo Graal', ItemCategory.magical),
      _createItem(
        'tomo_da_sabedoria.png',
        'Tomo da Sabedoria',
        ItemCategory.magical,
      ),
      _createItem(
        'tomo_insaciável.png',
        'Tomo Insaciável',
        ItemCategory.magical,
      ),
      _createItem(
        'visão_do_profeta.png',
        'Visão do Profeta',
        ItemCategory.magical,
      ),

      // Defesa
      _createItem(
        'armadura_de_espinhos.png',
        'Armadura de Espinhos',
        ItemCategory.defense,
      ),
      _createItem('escudo_de_gaia.png', 'Escudo de Gaia', ItemCategory.defense),
      _createItem(
        'medalhao_de_troia.png',
        'Medalhão de Troia',
        ItemCategory.defense,
      ),

      // Movimento
      _createItem(
        'botas_da_agilidade.png',
        'Botas da Agilidade',
        ItemCategory.movement,
      ),
      _createItem(
        'botas_da_destreza.png',
        'Botas da Destreza',
        ItemCategory.movement,
      ),
      _createItem(
        'botas_da_fortitude.png',
        'Botas da Fortitude',
        ItemCategory.movement,
      ),
      _createItem(
        'botas_da_resistência.png',
        'Botas da Resistência',
        ItemCategory.movement,
      ),
      _createItem(
        'botas_da_tranquilidade.png',
        'Botas da Tranquilidade',
        ItemCategory.movement,
      ),
      _createItem(
        'botas_do_arcano.png',
        'Botas do Arcano',
        ItemCategory.movement,
      ),
      _createItem(
        'botas_ligeiras.png',
        'Botas Ligeiras',
        ItemCategory.movement,
      ),

      // Caça (Jungle)
      _createItem(
        'armadura_do_gigante.png',
        'Armadura do Gigante',
        ItemCategory.jungle,
      ),
      _createItem(
        'espada_de_runas.png',
        'Espada de Runas',
        ItemCategory.jungle,
      ),
      _createItem('faca_de_caça.png', 'Faça de Caça', ItemCategory.jungle),
      _createItem(
        'lâmina_inexorável.png',
        'Lâmina Inexorável',
        ItemCategory.jungle,
      ),
      _createItem(
        'machado_de_patrulha.png',
        'Machado de Patrulha',
        ItemCategory.jungle,
      ),
      _createItem(
        'machete_de_guerrilha.png',
        'Machete de Guerrilha',
        ItemCategory.jungle,
      ),
      _createItem('mordida_voraz.png', 'Mordida Voraz', ItemCategory.jungle),

      // Apoio
      _createItem(
        'gema_da_sabedoria.png',
        'Gema da Sabedoria',
        ItemCategory.support,
      ),
      _createItem('guardião.png', 'Guardião', ItemCategory.support),
      _createItem(
        'guardião_brilho_da_primavera.png',
        'Guardião - Brilho da Primavera',
        ItemCategory.support,
      ),
      _createItem(
        'guardião_esplendor.png',
        'Guardião - Esplendor',
        ItemCategory.support,
      ),
      _createItem(
        'guardião_redenção.png',
        'Guardião - Redenção',
        ItemCategory.support,
      ),
      _createItem('guardião_uivo.png', 'Guardião - Uivo', ItemCategory.support),
      _createItem(
        'sombra_carmesim.png',
        'Sombra Carmesim',
        ItemCategory.support,
      ),
      _createItem(
        'sombra_carmesim_brilho_da_primavera.png',
        'Sombra Carmesim - Brilho da Primavera',
        ItemCategory.support,
      ),
      _createItem(
        'sombra_carmesim_esplendor.png',
        'Sombra Carmesim - Esplendor',
        ItemCategory.support,
      ),
      _createItem(
        'sombra_carmesim_redenção.png',
        'Sombra Carmesim - Redenção',
        ItemCategory.support,
      ),
      _createItem(
        'sombra_carmesim_uivo.png',
        'Sombra Carmesim - Uivo',
        ItemCategory.support,
      ),
    ];
  }

  ItemModel _createItem(
    String fileName,
    String displayName, // Alterado de defaultName para displayName para clareza
    ItemCategory category,
  ) {
    return ItemModel(
      id: _uuid.v4(),
      name: displayName, // Usar o displayName diretamente
      imagePath: 'assets/icons/items/${category.assetFolderName}/$fileName',
      category: category,
    );
  }

  // String _formatItemName(String fileName, String defaultName) {
  //   try {
  //     // Remove a extensão .png e substitui underscores por espaços
  //     String nameWithoutExtension = fileName.toLowerCase().replaceAll(
  //       '.png',
  //       '',
  //     );
  //     List<String> words = nameWithoutExtension.split('_');
  //     // Capitaliza cada palavra
  //     String formattedName = words
  //         .map((word) {
  //           if (word.isEmpty) return '';
  //           return word[0].toUpperCase() + word.substring(1);
  //         })
  //         .join(' ');
  //     return formattedName.isNotEmpty ? formattedName : defaultName;
  //   } catch (e) {
  //     return defaultName; // Retorna o nome padrão em caso de erro
  //   }
  // }

  Future<List<ItemModel>> getItemsByCategory(ItemCategory category) async {
    // Simula um atraso de rede
    await Future.delayed(const Duration(milliseconds: 100));

    if (category == ItemCategory.all) {
      return List.unmodifiable(_allItems);
    }
    return List.unmodifiable(
      _allItems.where((item) => item.category == category).toList(),
    );
  }

  Future<List<ItemModel>> getAllItems() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_allItems);
  }
}
