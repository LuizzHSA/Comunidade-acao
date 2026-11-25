class DonationItem {
  final String id;
  final String name;
  final String unitDescription;
  final String metaRemainingText;
  final int maxNeeded;
  final String iconType; // 'grain', 'eco', 'water_drop', 'local_cafe', etc.

  DonationItem({
    required this.id,
    required this.name,
    required this.unitDescription,
    required this.metaRemainingText,
    required this.maxNeeded,
    required this.iconType,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'unitDescription': unitDescription,
    'metaRemainingText': metaRemainingText,
    'maxNeeded': maxNeeded,
    'iconType': iconType,
  };

  factory DonationItem.fromMap(Map<String, dynamic> map) => DonationItem(
    id: map['id'] as String? ?? '',
    name: map['name'] as String? ?? '',
    unitDescription: map['unitDescription'] as String? ?? 'unidades',
    metaRemainingText: map['metaRemainingText'] as String? ?? '',
    maxNeeded: (map['maxNeeded'] as num?)?.toInt() ?? 0,
    iconType: map['iconType'] as String? ?? 'volunteer_activism',
  );
}

class Campaign {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String highlightText;
  final String organizationName;
  final String organizationYears;
  final bool isVerified;
  final String category; // 'Alimentos', 'Roupas & Agasalhos', 'Dinheiro / Pix', 'Voluntariado', 'Brinquedos'
  final String location;
  final String?
  urgencyBadge; // 'Urgência Média', 'Quase lá!', 'Destaque do Mês'
  final String? urgencyBadgeColor; // 'error', 'secondary', 'tertiary'
  final int daysLeft;
  final double progressPercent; // 0.0 to 1.0
  final String currentProgressLabel;
  final String targetProgressLabel;
  final int supportersCount;
  final List<String> imageUrls;
  final List<DonationItem> needItems;
  final String? pixKey;
  final int? volunteersNeeded;
  final String? volunteerDateInfo;

  Campaign({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.highlightText,
    required this.organizationName,
    required this.organizationYears,
    this.isVerified = true,
    required this.category,
    required this.location,
    this.urgencyBadge,
    this.urgencyBadgeColor,
    required this.daysLeft,
    required this.progressPercent,
    required this.currentProgressLabel,
    required this.targetProgressLabel,
    required this.supportersCount,
    required this.imageUrls,
    required this.needItems,
    this.pixKey,
    this.volunteersNeeded,
    this.volunteerDateInfo,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'highlightText': highlightText,
    'organizationName': organizationName,
    'organizationYears': organizationYears,
    'isVerified': isVerified,
    'category': category,
    'location': location,
    'urgencyBadge': urgencyBadge,
    'urgencyBadgeColor': urgencyBadgeColor,
    'daysLeft': daysLeft,
    'progressPercent': progressPercent,
    'currentProgressLabel': currentProgressLabel,
    'targetProgressLabel': targetProgressLabel,
    'supportersCount': supportersCount,
    'imageUrls': imageUrls,
    'needItems': needItems.map((i) => i.toMap()).toList(),
    'pixKey': pixKey,
    'volunteersNeeded': volunteersNeeded,
    'volunteerDateInfo': volunteerDateInfo,
    'createdAt': DateTime.now().toIso8601String(),
  };

  factory Campaign.fromMap(String id, Map<String, dynamic> map) => Campaign(
    id: id,
    title: map['title'] as String? ?? '',
    subtitle: map['subtitle'] as String? ?? '',
    description: map['description'] as String? ?? '',
    highlightText: map['highlightText'] as String? ?? '',
    organizationName: map['organizationName'] as String? ?? '',
    organizationYears: map['organizationYears'] as String? ?? '',
    isVerified: map['isVerified'] as bool? ?? true,
    category: map['category'] as String? ?? 'Alimentos',
    location: map['location'] as String? ?? '',
    urgencyBadge: map['urgencyBadge'] as String?,
    urgencyBadgeColor: map['urgencyBadgeColor'] as String?,
    daysLeft: (map['daysLeft'] as num?)?.toInt() ?? 0,
    progressPercent: (map['progressPercent'] as num?)?.toDouble() ?? 0,
    currentProgressLabel: map['currentProgressLabel'] as String? ?? '',
    targetProgressLabel: map['targetProgressLabel'] as String? ?? '',
    supportersCount: (map['supportersCount'] as num?)?.toInt() ?? 0,
    imageUrls:
        (map['imageUrls'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
    needItems:
        (map['needItems'] as List?)
            ?.map(
              (e) => DonationItem.fromMap(Map<String, dynamic>.from(e as Map)),
            )
            .toList() ??
        const [],
    pixKey: map['pixKey'] as String?,
    volunteersNeeded: (map['volunteersNeeded'] as num?)?.toInt(),
    volunteerDateInfo: map['volunteerDateInfo'] as String?,
  );
}

class DonationRecord {
  final String id;
  final String campaignId;
  final String campaignTitle;
  final DateTime date;
  final Map<String, int> itemsWithQty;
  final int totalCount;
  final String deliveryMethod; // 'Ponto de Coleta' or 'Retirada no Endereço'
  final String? address;
  final String status; // 'Confirmado', 'Agendado', 'Entregue'
  final String receiptCode;
  final String? userId;

  DonationRecord({
    required this.id,
    required this.campaignId,
    required this.campaignTitle,
    required this.date,
    required this.itemsWithQty,
    required this.totalCount,
    required this.deliveryMethod,
    this.address,
    required this.status,
    required this.receiptCode,
    this.userId,
  });

  Map<String, dynamic> toMap() => {
    'campaignId': campaignId,
    'campaignTitle': campaignTitle,
    'date': date.toIso8601String(),
    'itemsWithQty': itemsWithQty,
    'totalCount': totalCount,
    'deliveryMethod': deliveryMethod,
    'address': address,
    'status': status,
    'receiptCode': receiptCode,
    'userId': userId,
  };

  factory DonationRecord.fromMap(String id, Map<String, dynamic> map) {
    final items = (map['itemsWithQty'] as Map?) ?? const {};
    return DonationRecord(
      id: id,
      campaignId: map['campaignId'] as String? ?? '',
      campaignTitle: map['campaignTitle'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      itemsWithQty: Map<String, int>.from(
        items.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      ),
      totalCount: (map['totalCount'] as num?)?.toInt() ?? 0,
      deliveryMethod: map['deliveryMethod'] as String? ?? 'Ponto de Coleta',
      address: map['address'] as String?,
      status: map['status'] as String? ?? 'Confirmado',
      receiptCode: map['receiptCode'] as String? ?? '',
      userId: map['userId'] as String?,
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final String city;
  final String bio;
  final int donationsCount;
  final int totalItemsDonated;

  UserProfile({
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.city = '',
    this.bio = '',
    this.donationsCount = 0,
    this.totalItemsDonated = 0,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? city,
    String? bio,
    int? donationsCount,
    int? totalItemsDonated,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      donationsCount: donationsCount ?? this.donationsCount,
      totalItemsDonated: totalItemsDonated ?? this.totalItemsDonated,
    );
  }

  /// Iniciais usadas quando a foto não carrega.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }
}

/// Faixa de impacto do doador, calculada a partir do total de itens doados.
class ImpactLevel {
  final int level;
  final String title;
  final String emoji;
  final int minItems;
  final int nextLevelAt; // 0 quando é o nível mais alto.

  const ImpactLevel({
    required this.level,
    required this.title,
    required this.emoji,
    required this.minItems,
    this.nextLevelAt = 0,
  });

  static const List<ImpactLevel> levels = [
    ImpactLevel(
      level: 1,
      title: 'Semente',
      emoji: '🌱',
      minItems: 0,
      nextLevelAt: 10,
    ),
    ImpactLevel(
      level: 2,
      title: 'Broto',
      emoji: '🌿',
      minItems: 10,
      nextLevelAt: 30,
    ),
    ImpactLevel(
      level: 3,
      title: 'Colaborador',
      emoji: '🤝',
      minItems: 30,
      nextLevelAt: 60,
    ),
    ImpactLevel(
      level: 4,
      title: 'Agente de Mudança',
      emoji: '⭐',
      minItems: 60,
      nextLevelAt: 100,
    ),
    ImpactLevel(level: 5, title: 'Transformador', emoji: '🏆', minItems: 100),
  ];

  static ImpactLevel forItems(int items) {
    var current = levels.first;
    for (final level in levels) {
      if (items >= level.minItems) current = level;
    }
    return current;
  }

  bool get isMax => nextLevelAt == 0;

  /// Progresso (0.0 a 1.0) dentro do nível atual.
  double progressFor(int items) {
    if (isMax) return 1;
    final span = nextLevelAt - minItems;
    if (span <= 0) return 1;
    return ((items - minItems) / span).clamp(0.0, 1.0);
  }

  int itemsToNextLevel(int items) {
    if (isMax) return 0;
    return (nextLevelAt - items).clamp(0, nextLevelAt);
  }
}

/// Conquista exibida no perfil.
class Achievement {
  final String title;
  final String description;
  final String emoji;
  final bool unlocked;

  const Achievement({
    required this.title,
    required this.description,
    required this.emoji,
    required this.unlocked,
  });
}
