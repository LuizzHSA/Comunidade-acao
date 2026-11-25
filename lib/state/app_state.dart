import 'package:flutter/foundation.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

import '../models/models.dart';
import '../services/firestore_service.dart';

class AppState extends ChangeNotifier {
  final _service = FirestoreService.instance;
  StreamSubscription? _campaignsSub;
  StreamSubscription? _donationsSub;
  String? _currentUserId;

  bool get isCloudConnected => _currentUserId != null;

  /// Perfil de demonstração usado ao abrir o app e após sair da conta.
  static UserProfile _demoProfile() => UserProfile(
    name: 'Ana Paula',
    email: 'ana.paula@exemplo.com.br',
    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBa0dQYvBfViFE6fzjplsP-d9tgmdwFZPIXemVuPCQJOT7eDxjr2ssLnzx3EsEcjKisUYQcs2ptbQeaf24je_oclmSfCRlQHvgFBVa3SAFZVytpu0nL1DKJlrEf3JDcImD9EZ2LouAeSj2DbOok0M67avyAQm9zBnmK9NZlUUko7QQuXX9JC_9jPT-mtur4tsYk5y54ji8s_ouGIFiUNa-V3GoC5JUUlo_bjvdqxwE',
    city: 'São Paulo, SP',
    donationsCount: 6,
    totalItemsDonated: 42,
  );

  UserProfile _user = _demoProfile();

  bool _isAuthenticated = false;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  String _selectedDeliveryMethod = 'point'; // 'point' or 'pickup'
  String _pickupAddress = '';
  int _currentNavIndex = 0;
  bool _hasUnreadNotifications = true;

  // Preferências do perfil.
  bool _isProfilePublic = true;
  bool _notifyNewCampaigns = true;
  bool _notifyDonationStatus = true;
  bool _shareCity = true;

  // Selected quantities for donation items matching Screen 4 defaults
  final Map<String, int> _itemQuantities = {
    'item-1': 2,
    'item-2': 4,
    'item-3': 0,
    'item-4': 6,
  };

  final List<DonationRecord> _donationHistory = [
    DonationRecord(
      id: 'DON-2025-091',
      campaignId: 'horta-heliopolis',
      campaignTitle: 'Horta Comunitária Heliópolis',
      date: DateTime.now().subtract(const Duration(days: 3)),
      itemsWithQty: {
        'Arroz tipo 1 (pacote 5kg)': 2,
        'Feijão carioca (pacote 1kg)': 2,
      },
      totalCount: 4,
      deliveryMethod: 'Ponto de Coleta',
      address: 'Rua das Flores, 120 - Heliópolis',
      status: 'Entregue com Sucesso',
      receiptCode: 'CMP-88319-HEL',
    ),
    DonationRecord(
      id: 'DON-2025-084',
      campaignId: 'campanha-agasalho',
      campaignTitle: 'Campanha do Agasalho 2025',
      date: DateTime.now().subtract(const Duration(days: 12)),
      itemsWithQty: {'Casaco de Inverno Adulto': 2, 'Cobertor Térmico': 3},
      totalCount: 5,
      deliveryMethod: 'Ponto de Coleta',
      address: 'Estação Brás - Ponto Solidário',
      status: 'Entregue com Sucesso',
      receiptCode: 'CMP-77402-AGA',
    ),
  ];

  late List<Campaign> _campaigns;

  AppState() {
    _initCampaigns();
  }

  void _initCampaigns() {
    _campaigns = [
      Campaign(
        id: 'horta-heliopolis',
        title: 'Horta Solidária e Cestas Básicas para 120 Famílias',
        subtitle: 'Distribuição semanal de alimentos frescos e oficinas de agricultura sustentável para famílias periféricas.',
        description: 'A fome não pode esperar. Em Heliópolis, unimos a colheita fresca da nossa horta agroecológica com alimentos não perecíveis essenciais para garantir segurança alimentar e dignidade a 120 lares chefiados por mulheres em situação de vulnerabilidade extrema.',
        highlightText: 'Cada cesta inclui legumes sem agrotóxicos cultivados por agricultores urbanos locais + mantimentos secos essenciais para 30 dias de sustento familiar.',
        organizationName: 'ONG Mãos Dadas',
        organizationYears: 'Atuando há 8 anos na comunidade',
        isVerified: true,
        category: 'Alimentos',
        location: 'Heliópolis, São Paulo - SP',
        urgencyBadge: null,
        daysLeft: 12,
        progressPercent: 0.78,
        currentProgressLabel: '390 cestas arrecadadas',
        targetProgressLabel: 'Meta: 500 cestas',
        supportersCount: 142,
        imageUrls: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAaTSkNcQAJ801onqGs3ydQX5lZUg3k3_0F0ilTnC9t_c-fDYZ_NgihjUuoEJU3ZTrD0uEXogF_OymTurf08m2Tk2kAgo1LV6p23TohT9sLDbBvxLHRNY95mSBozeFEnZ8t8YKQAk_UkxWHZ7122xvtxhVWN0aG_LhnkLCesdPcLZbhYxod6ZYGBfprSyxud1vgwIe0d5QS42v2oONnNoLi0OuiXbNrQ6L5dH7Kc7U',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDyiOnsxcqBaHM6TVWZne13yj9YwzPy8yWi6kotOTf76fp1qHCvoxRoREyCPx-37ZZpX1-7x9lCPSLOdEziepIbwCiSwcGxqAtub0sQ3OvCfWpNdZSio5s9Wo7F6XtzH6t6Mhry_UrbAPgidV6iwNE6flmmQXTKowgcFslfRj7PF_7018TolQeV1Su55xHzb7KCTf7Q7Qr1gUsiX0egNLTR7QkVQ1sZ6z6JPaZGRPA',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD7i_J30TI90IkF6O-klVfUPsPrOoMRs9mE-0AZswS6sC2hmWgPbbPzEck1-YE63uKAhnchdYFtIdVwFCoEU13UTSxqU7LPiJ0uxEZCaeh8o4H5_7Skxo3ow3VF8X4gvqM1NqWIdOZ7CoWfuexKItv5j8AkyGEGK2uIjkfWblPGkx_-24SpZ0R3Y_JFvNUkgz4OrdM_PU3kv8Ge1vxgc2EL7IKTwto7cMil21-kuO4',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB7ny5FnP_MQg-fFGb4ZHwcpwdYINPo_8VRIsjKv1FPEwm2FDq6QYV8-tF0harE5OoEzS3Sl8i_1Au_rGu9Q6_mi0IRbs5aDn1T7N-lbh-g6ONn9_lCqbXNULcTpDbWQgXAwFDwAU7WTXHwQyZRKPbr1BuKKuKI9uVZgPSOsd5m39sHOFLwo3Qx1PAqb0zml4NQLykiC152ObMm6viD4WFfkIRpnqXzeFH7kX8PyIw',
        ],
        needItems: [
          DonationItem(
            id: 'item-1',
            name: 'Arroz tipo 1 (pacote 5kg)',
            unitDescription: 'pacotes',
            metaRemainingText: '15 pacotes',
            maxNeeded: 15,
            iconType: 'grain',
          ),
          DonationItem(
            id: 'item-2',
            name: 'Feijão carioca (pacote 1kg)',
            unitDescription: 'pacotes',
            metaRemainingText: '30 pacotes',
            maxNeeded: 30,
            iconType: 'eco',
          ),
          DonationItem(
            id: 'item-3',
            name: 'Óleo de soja (900ml)',
            unitDescription: 'unidades',
            metaRemainingText: '20 un',
            maxNeeded: 20,
            iconType: 'water_drop',
          ),
          DonationItem(
            id: 'item-4',
            name: 'Leite integral (caixa 1L)',
            unitDescription: 'unidades',
            metaRemainingText: '50 un',
            maxNeeded: 50,
            iconType: 'local_cafe',
          ),
        ],
        pixKey: 'pix@maosdadas-heliopolis.org.br',
        volunteersNeeded: 5,
        volunteerDateInfo: 'Neste sábado, 08h às 13h',
      ),
      Campaign(
        id: 'campanha-agasalho',
        title: 'Campanha do Agasalho 2025',
        subtitle: 'Meta de aquecer 1.200 famílias em situação de vulnerabilidade extrema na Grande São Paulo.',
        description: 'Com a chegada das noites geladas de inverno, muitas pessoas em abrigos e comunidades carentes enfrentam frio intenso sem agasalho ou cobertores adequados. Doe agasalhos, meias e cobertores em bom estado.',
        highlightText: 'Todos os agasalhos doados são triados, higienizados e entregues diretamente com apoio das lideranças comunitárias locais.',
        organizationName: 'Rede Solidária SP',
        organizationYears: 'Atuando há 12 anos na capital',
        isVerified: true,
        category: 'Roupas & Agasalhos',
        location: 'Grande São Paulo, SP',
        urgencyBadge: 'Destaque do Mês',
        urgencyBadgeColor: 'tertiary',
        daysLeft: 6,
        progressPercent: 0.85,
        currentProgressLabel: '1.020 agasalhos arrecadados',
        targetProgressLabel: 'Meta: 1.200 agasalhos',
        supportersCount: 82,
        imageUrls: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBfZb2DCxgpzJ78QBt2P-lYHh3vSP3t07t786c_YD0SrUe3aY93a-Sx9TsZTd4Dmt9Y1mUKuLZ3wuhaX0zHqIaELZ54DT7t0LOYr38rUbXQf6tj4Oo-egmmDH2G4gWgQjA-SWoe16aXUdyXkaRhqBgkon8usB4RsKByGcAofulv6QKAojToXTtsrD6RVRzchr4psMCP7yNmVyg3NwyS5E92EtBBFL4aqxyPQH3CgSY',
        ],
        needItems: [
          DonationItem(
            id: 'agasalho-1',
            name: 'Casacos e Moletons',
            unitDescription: 'peças',
            metaRemainingText: '100 peças',
            maxNeeded: 100,
            iconType: 'checkroom',
          ),
          DonationItem(
            id: 'agasalho-2',
            name: 'Cobertores Térmicos',
            unitDescription: 'unidades',
            metaRemainingText: '80 un',
            maxNeeded: 80,
            iconType: 'bed',
          ),
        ],
        pixKey: 'doacoes@redesolidariasp.org',
      ),
      Campaign(
        id: 'reforma-creche',
        title: 'Reforma da Creche Esperança',
        subtitle: 'Necessitamos de tintas, mão de obra voluntária para reparo do teto e troca de fiação antes do retorno das aulas.',
        description: 'A Creche Esperança atende 85 crianças enquanto suas mães trabalham. O telhado sofreu infiltrações graves e a parte elétrica requer reforma urgente para segurança de todas as crianças.',
        highlightText: 'Com a sua doação ou voluntariado no mutirão, as salas serão reabertas a tempo do ano letivo com total conforto e segurança.',
        organizationName: 'Associação Creche Esperança',
        organizationYears: '15 anos de história',
        isVerified: true,
        category: 'Voluntariado',
        location: 'Rio de Janeiro, RJ',
        urgencyBadge: 'Urgência Média',
        urgencyBadgeColor: 'error',
        daysLeft: 10,
        progressPercent: 0.45,
        currentProgressLabel: 'R\$ 5.400 de R\$ 12.000',
        targetProgressLabel: '45% arrecadado',
        supportersCount: 95,
        imageUrls: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTJuLrN7MJuwDqVNyoKefU4Uv-SWf3PYemUoahtf4UE-_3EDZXY43KilowXo57zCe50rcLOInpTdRPkrPD9j9v4RZR8Vk51nwHF_X6HO4e1F6WbKsSCrTWf9R_ETaTUagdvIKP_cUIA6cHSTdboqo4DnyiKJug3t9nrP0CnUoyLcRF46NgCO-azr2acyfLjvCggU0a3utIMPytuEdMzEbmLBWqj8Z6IWO75tA30Wo',
        ],
        needItems: [
          DonationItem(
            id: 'creche-1',
            name: 'Lata de Tinta Acrílica 18L',
            unitDescription: 'latas',
            metaRemainingText: '6 latas',
            maxNeeded: 6,
            iconType: 'format_paint',
          ),
          DonationItem(
            id: 'creche-2',
            name: 'Cabos Flexíveis 2.5mm (rolo)',
            unitDescription: 'rolos',
            metaRemainingText: '4 rolos',
            maxNeeded: 4,
            iconType: 'cable',
          ),
        ],
        pixKey: 'financeiro@crecheesperanca.org.br',
        volunteersNeeded: 18,
        volunteerDateInfo: 'Mutirão marcado para este sábado (8h às 14h)',
      ),
      Campaign(
        id: 'kits-aleman',
        title: 'Kits Escolares para o Alemão',
        subtitle: 'Mochilas com cadernos, lápis de cor e estojos completos para incentivar a permanência de 200 crianças na escola.',
        description: 'A educação é a ferramenta mais transformadora para quebrar ciclos de pobreza. Nosso objetivo é garantir que nenhuma criança comece as aulas sem o material básico necessário.',
        highlightText: 'Cada kit contém: mochila resistente, 4 cadernos capa dura, estojo com lápis de cor, canetas, régua, borracha e tesoura sem ponta.',
        organizationName: 'Vozes da Comunidade Alemão',
        organizationYears: '6 anos promovendo educação',
        isVerified: true,
        category: 'Brinquedos',
        location: 'Complexo do Alemão, RJ',
        urgencyBadge: 'Quase lá!',
        urgencyBadgeColor: 'secondary',
        daysLeft: 8,
        progressPercent: 0.92,
        currentProgressLabel: '184 de 200 kits garantidos',
        targetProgressLabel: '92% concluído',
        supportersCount: 310,
        imageUrls: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCrnug221KOqGwzUrTesVxa0X1PKwjlz5HX4Nc6iWfWWbJGgqF7n4gH-VH4JjQJ4g0b_WDtGm3uD8T1mY66-iYjG_Ur5ANDIfHRWU0lUoqy2F-VqyZMDhAULB6YHwLlafPDkiFM9CI7HXfceQdN_qq6dcHUgBJrGaBRFUNGvSNEuAuzpNhzTsFIZQp0ACi62HdQKmZlspczJD6RIFgjzodCX2CzcIdvJ9oEBIU2ZbE',
        ],
        needItems: [
          DonationItem(
            id: 'kit-1',
            name: 'Kit Escolar Completo',
            unitDescription: 'kits',
            metaRemainingText: '16 kits',
            maxNeeded: 16,
            iconType: 'backpack',
          ),
        ],
        pixKey: 'pix@vozesdoalemao.org.br',
      ),
    ];
  }

  // Getters
  UserProfile get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get selectedDeliveryMethod => _selectedDeliveryMethod;
  String get pickupAddress => _pickupAddress;
  int get currentNavIndex => _currentNavIndex;
  bool get hasUnreadNotifications => _hasUnreadNotifications;
  Map<String, int> get itemQuantities => _itemQuantities;
  List<DonationRecord> get donationHistory => _donationHistory;

  bool get isProfilePublic => _isProfilePublic;
  bool get notifyNewCampaigns => _notifyNewCampaigns;
  bool get notifyDonationStatus => _notifyDonationStatus;
  bool get shareCity => _shareCity;

  /// Nível de impacto calculado pelos itens realmente doados.
  ImpactLevel get impactLevel => ImpactLevel.forItems(_user.totalItemsDonated);

  /// Quantidade de campanhas diferentes que já receberam doações.
  int get campaignsSupported =>
      _donationHistory.map((d) => d.campaignId).toSet().length;

  /// Doação mais recente, ou null quando ainda não houve nenhuma.
  DonationRecord? get lastDonation {
    if (_donationHistory.isEmpty) return null;
    return _donationHistory.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }

  /// Conquistas derivadas do histórico real do usuário.
  List<Achievement> get achievements {
    final donations = _user.donationsCount;
    final items = _user.totalItemsDonated;
    return [
      Achievement(
        title: 'Primeira Doação',
        description: 'Você já deu o primeiro passo.',
        emoji: '🎁',
        unlocked: donations >= 1,
      ),
      Achievement(
        title: 'Doador Frequente',
        description: '5 doações registradas.',
        emoji: '💚',
        unlocked: donations >= 5,
      ),
      Achievement(
        title: '10 Itens',
        description: '10 itens doados para a comunidade.',
        emoji: '📦',
        unlocked: items >= 10,
      ),
      Achievement(
        title: '50 Itens',
        description: '50 itens doados para a comunidade.',
        emoji: '🚚',
        unlocked: items >= 50,
      ),
      Achievement(
        title: 'Multi-causas',
        description: 'Apoiou 2 campanhas diferentes.',
        emoji: '🌍',
        unlocked: campaignsSupported >= 2,
      ),
      Achievement(
        title: 'Guardião do Impacto',
        description: 'Alcançou o nível Transformador.',
        emoji: '🏆',
        unlocked: items >= 100,
      ),
    ];
  }

  int get totalSelectedItemsCount {
    return _itemQuantities.values.fold(0, (sum, count) => sum + count);
  }

  List<Campaign> get filteredCampaigns {
    return _campaigns.where((campaign) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          campaign.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          campaign.location.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          campaign.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'Todos' ||
          campaign.category.toLowerCase() == _selectedCategory.toLowerCase() ||
          (_selectedCategory == 'Dinheiro / Pix' && campaign.pixKey != null);

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Campaign get featuredCampaign => _campaigns.firstWhere(
    (c) => c.id == 'campanha-agasalho',
    orElse: () => _campaigns.first,
  );

  Campaign get mainCampaign => _campaigns.firstWhere(
    (c) => c.id == 'horta-heliopolis',
    orElse: () => _campaigns.first,
  );

  // Actions
  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  /// Atualiza os dados editáveis do perfil.
  void updateProfile({String? name, String? city, String? bio}) {
    _user = _user.copyWith(
      name: name?.trim().isEmpty == true ? _user.name : name?.trim(),
      city: city?.trim().isEmpty == true ? _user.city : city?.trim(),
      bio: bio?.trim(),
    );
    notifyListeners();
  }

  void setProfilePublic(bool value) {
    _isProfilePublic = value;
    notifyListeners();
  }

  void setNotifyNewCampaigns(bool value) {
    _notifyNewCampaigns = value;
    notifyListeners();
  }

  void setNotifyDonationStatus(bool value) {
    _notifyDonationStatus = value;
    notifyListeners();
  }

  void setShareCity(bool value) {
    _shareCity = value;
    notifyListeners();
  }

  /// Login via Firebase Auth. Retorna mensagem de erro ou null em caso de sucesso.
  /// A conta de demonstração continua funcionando: se `ana.paula@exemplo.com.br`
  /// com senha `123456` ainda não existir no Firebase, é criada automaticamente.
  Future<String?> login(String email, String password) async {
    try {
      final cred = await _service.signIn(email, password);
      _currentUserId = cred.user?.uid;
      _isAuthenticated = true;
      _user = _user.copyWith(email: email);
      _startSync();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha incorretos.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'user-disabled':
          return 'Conta desativada.';
        case 'weak-password':
          return 'A senha precisa ter no mínimo 6 caracteres.';
        case 'network-request-failed':
          return 'Sem conexão. Verifique sua internet.';
        default:
          return 'Não foi possível entrar: ${e.message ?? e.code}';
      }
    } catch (_) {
      // Firebase indisponível: modo demo offline.
      _isAuthenticated = true;
      _user = _user.copyWith(email: email);
      notifyListeners();
      return null;
    }
  }

  /// Login com Google via Firebase Auth.
  /// Retorna uma mensagem de erro ou null em caso de sucesso.
  Future<String?> loginWithGoogle() async {
    try {
      final cred = await _service.signInWithGoogle();
      final googleUser = cred.user;
      _currentUserId = googleUser?.uid;
      _isAuthenticated = true;

      final displayName = googleUser?.displayName?.trim() ?? '';
      final email = googleUser?.email ?? '';
      _user = UserProfile(
        name: displayName.isNotEmpty
            ? displayName
            : (email.contains('@') ? email.split('@').first : 'Doador'),
        email: email,
        avatarUrl: googleUser?.photoURL ?? '',
        city: '',
      );

      _startSync();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          return 'O login com Google não está ativado neste projeto Firebase.';
        case 'account-exists-with-different-credential':
          return 'Já existe uma conta com este e-mail usando senha. Entre com e-mail e senha.';
        case 'network-request-failed':
          return 'Sem conexão. Verifique sua internet.';
        case 'popup-closed-by-user':
        case 'cancelled':
          return 'Login com Google cancelado.';
        default:
          return 'Não foi possível entrar com Google: ${e.message ?? e.code}';
      }
    } on UnsupportedError {
      return 'Login com Google está disponível no Android, iOS e Web. '
          'No computador, use e-mail e senha.';
    } catch (e) {
      // Firebase indisponível ou recurso não suportado nesta plataforma.
      final text = e.toString().toLowerCase();
      if (text.contains('unsupported') ||
          text.contains('not supported') ||
          text.contains('notimplemented') ||
          text.contains('missingplugin')) {
        return 'Login com Google está disponível no Android, iOS e Web. '
            'No computador, use e-mail e senha.';
      }
      return 'Não foi possível entrar com Google. Tente novamente.';
    }
  }

  /// Inicia as streams do Firestore. Em caso de falha, o app segue
  /// funcionando com os dados demo em memória.
  void _startSync() {
    _campaignsSub?.cancel();
    _donationsSub?.cancel();

    try {
      _campaignsSub = _service.campaignsStream().listen((remote) {
        if (remote.isNotEmpty) {
          _campaigns = remote;
          notifyListeners();
        }
      }, onError: (_) {});

      final uid = _currentUserId;
      if (uid != null) {
        _donationsSub = _service.donationsStream(uid).listen((remote) {
          if (remote.isNotEmpty) {
            _donationHistory
              ..clear()
              ..addAll(remote);
            notifyListeners();
          }
        }, onError: (_) {});
      }

      // Seed inicial (ignora falhas: segue em modo demo).
      _service.seedIfEmpty(demoCampaigns: _campaigns).catchError((_) {});
    } catch (_) {
      // Firestore não disponível — modo demo.
    }
  }

  void logout() {
    _campaignsSub?.cancel();
    _donationsSub?.cancel();
    _campaignsSub = null;
    _donationsSub = null;
    _currentUserId = null;
    _isAuthenticated = false;
    _currentNavIndex = 0;
    _user = _demoProfile();
    notifyListeners();
    try {
      _service.signOut().catchError((_) {});
    } catch (_) {}
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setDeliveryMethod(String method) {
    _selectedDeliveryMethod = method;
    notifyListeners();
  }

  void setPickupAddress(String address) {
    _pickupAddress = address;
    notifyListeners();
  }

  void updateItemQuantity(String itemId, int delta) {
    final current = _itemQuantities[itemId] ?? 0;
    final next = (current + delta).clamp(0, 99);
    _itemQuantities[itemId] = next;
    notifyListeners();
  }

  void clearNotificationsBadge() {
    _hasUnreadNotifications = false;
    notifyListeners();
  }

  DonationRecord confirmCurrentDonation({
    required Campaign campaign,
    String? customAddress,
  }) {
    final total = totalSelectedItemsCount;
    final itemsCopy = <String, int>{};

    for (var item in campaign.needItems) {
      final qty = _itemQuantities[item.id] ?? 0;
      if (qty > 0) {
        itemsCopy[item.name] = qty;
      }
    }

    final newRecord = DonationRecord(
      id: 'DON-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      campaignId: campaign.id,
      campaignTitle: campaign.title,
      date: DateTime.now(),
      itemsWithQty: itemsCopy.isNotEmpty
          ? itemsCopy
          : {'Alimentos Essenciais Diversos': total > 0 ? total : 1},
      totalCount: total > 0 ? total : 1,
      deliveryMethod: _selectedDeliveryMethod == 'point'
          ? 'Ponto de Coleta'
          : 'Retirada no Endereço',
      address: _selectedDeliveryMethod == 'point'
          ? 'Rua das Flores, 120 - Heliópolis'
          : (customAddress ?? _pickupAddress),
      status: 'Confirmado com Sucesso',
      receiptCode:
          'REC-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
    );

    _donationHistory.insert(0, newRecord);
    _user = _user.copyWith(
      donationsCount: _user.donationsCount + 1,
      totalItemsDonated: _user.totalItemsDonated + (total > 0 ? total : 1),
    );

    // Grava no Firestore (silencioso: se falhar, segue com dado local).
    if (isCloudConnected) {
      _service
          .addDonation(
            DonationRecord(
              id: newRecord.id,
              campaignId: newRecord.campaignId,
              campaignTitle: newRecord.campaignTitle,
              date: newRecord.date,
              itemsWithQty: newRecord.itemsWithQty,
              totalCount: newRecord.totalCount,
              deliveryMethod: newRecord.deliveryMethod,
              address: newRecord.address,
              status: newRecord.status,
              receiptCode: newRecord.receiptCode,
              userId: _currentUserId,
            ),
          )
          .catchError((_) {});
    }

    notifyListeners();
    return newRecord;
  }

  void addNewCampaign({
    required String title,
    required String subtitle,
    required String category,
    required String location,
    required String targetLabel,
  }) {
    final newCampaign = Campaign(
      id: 'campaign-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      description: subtitle,
      highlightText: 'Iniciativa cadastrada recentemente pela comunidade.',
      organizationName: _user.name,
      organizationYears: 'Nova iniciativa',
      isVerified: true,
      category: category,
      location: location,
      urgencyBadge: 'Nova Causa',
      urgencyBadgeColor: 'secondary',
      daysLeft: 30,
      progressPercent: 0.05,
      currentProgressLabel: 'Iniciando arrecadações',
      targetProgressLabel: targetLabel,
      supportersCount: 1,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAaTSkNcQAJ801onqGs3ydQX5lZUg3k3_0F0ilTnC9t_c-fDYZ_NgihjUuoEJU3ZTrD0uEXogF_OymTurf08m2Tk2kAgo1LV6p23TohT9sLDbBvxLHRNY95mSBozeFEnZ8t8YKQAk_UkxWHZ7122xvtxhVWN0aG_LhnkLCesdPcLZbhYxod6ZYGBfprSyxud1vgwIe0d5QS42v2oONnNoLi0OuiXbNrQ6L5dH7Kc7U',
      ],
      needItems: [
        DonationItem(
          id: 'item-custom-1',
          name: 'Itens essenciais',
          unitDescription: 'unidades',
          metaRemainingText: '50 un',
          maxNeeded: 50,
          iconType: 'volunteer_activism',
        ),
      ],
    );

    _campaigns.insert(0, newCampaign);

    // Grava no Firestore (silencioso: se falhar, segue com dado local).
    if (isCloudConnected) {
      _service.addCampaign(newCampaign).catchError((_) {});
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _campaignsSub?.cancel();
    _donationsSub?.cancel();
    super.dispose();
  }
}
