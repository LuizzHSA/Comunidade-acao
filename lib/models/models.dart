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
  final String? urgencyBadge; // 'Urgência Média', 'Quase lá!', 'Destaque do Mês'
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
  });
}

class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final String city;
  final int donationsCount;
  final int totalItemsDonated;

  UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.city,
    required this.donationsCount,
    required this.totalItemsDonated,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? city,
    int? donationsCount,
    int? totalItemsDonated,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      donationsCount: donationsCount ?? this.donationsCount,
      totalItemsDonated: totalItemsDonated ?? this.totalItemsDonated,
    );
  }
}

