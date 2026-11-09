import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/fluent_theme.dart';
import '../widgets/custom_image.dart';

class WindowsCampaignDetailsView extends StatefulWidget {
  final Campaign campaign;
  final VoidCallback onBackToFeed;
  final Function(Campaign campaign, {bool startOnPix}) onOpenDonate;

  const WindowsCampaignDetailsView({
    super.key,
    required this.campaign,
    required this.onBackToFeed,
    required this.onOpenDonate,
  });

  @override
  State<WindowsCampaignDetailsView> createState() =>
      _WindowsCampaignDetailsViewState();
}

class _WindowsCampaignDetailsViewState
    extends State<WindowsCampaignDetailsView> {
  int _selectedPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;
    final images = campaign.imageUrls;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Navigation
          Row(
            children: [
              InkWell(
                onTap: widget.onBackToFeed,
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: FluentTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Voltar para o Feed',
                        style: FluentTheme.body.copyWith(
                          color: FluentTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/',
                style: TextStyle(color: FluentTheme.borderStrong),
              ),
              const SizedBox(width: 8),
              Text(
                campaign.category,
                style: FluentTheme.bodyMuted,
              ),
              const SizedBox(width: 8),
              Text(
                '/',
                style: TextStyle(color: FluentTheme.borderStrong),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  campaign.title,
                  style: FluentTheme.body.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Two-column Desktop Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (Media, Overview, Details, Table)
              Expanded(
                flex: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Photo Display
                    Container(
                      height: 380,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(FluentTheme.radiusCard),
                        border: Border.all(color: FluentTheme.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CustomImage(
                        url: images[_selectedPhotoIndex.clamp(0, images.length - 1)],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Photo Thumbnails Row
                    if (images.length > 1)
                      Row(
                        children: List.generate(images.length, (idx) {
                          final isSelected = _selectedPhotoIndex == idx;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPhotoIndex = idx;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 64,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(FluentTheme.radiusSm),
                                border: Border.all(
                                  color: isSelected
                                      ? FluentTheme.primary
                                      : FluentTheme.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CustomImage(
                                url: images[idx],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                      ),
                    const SizedBox(height: 16),

                    // Tags & Title Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: FluentTheme.primaryLight,
                            borderRadius:
                                BorderRadius.circular(FluentTheme.radiusSm),
                          ),
                          child: Text(
                            campaign.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: FluentTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: FluentTheme.sidebarBg,
                            borderRadius:
                                BorderRadius.circular(FluentTheme.radiusSm),
                            border: Border.all(color: FluentTheme.border),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.shield,
                                size: 12,
                                color: FluentTheme.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Auditoria 100% Transparente',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: FluentTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      campaign.title,
                      style: FluentTheme.headlineLg.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: FluentTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          campaign.location,
                          style: FluentTheme.bodyMuted.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Organizer Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: FluentTheme.cardBg,
                        borderRadius:
                            BorderRadius.circular(FluentTheme.radiusCard),
                        border: Border.all(color: FluentTheme.border),
                        boxShadow: FluentTheme.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: FluentTheme.primaryLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FluentTheme.border,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.verified_user,
                                color: FluentTheme.primary,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      campaign.organizationName,
                                      style: FluentTheme.title,
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      size: 15,
                                      color: FluentTheme.primary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  campaign.organizationYears,
                                  style: FluentTheme.bodyMuted,
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: FluentTheme.textPrimary,
                              side: const BorderSide(
                                color: FluentTheme.borderStrong,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(FluentTheme.radiusSm),
                              ),
                              minimumSize: const Size(120, 32),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Canal de mensagem com ${campaign.organizationName} aberto.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 14),
                            label: const Text(
                              'Mensagem para ONG',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Description: "Sobre a Iniciativa"
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FluentTheme.cardBg,
                        borderRadius:
                            BorderRadius.circular(FluentTheme.radiusCard),
                        border: Border.all(color: FluentTheme.border),
                        boxShadow: FluentTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sobre a Iniciativa',
                            style: FluentTheme.headlineMd.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            campaign.description,
                            style: FluentTheme.body.copyWith(height: 1.5),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: FluentTheme.sidebarBg,
                              borderRadius:
                                  BorderRadius.circular(FluentTheme.radiusSm),
                              border: Border.all(color: FluentTheme.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.eco,
                                  color: FluentTheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    campaign.highlightText,
                                    style: FluentTheme.bodyMuted.copyWith(
                                      color: FluentTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Urgent Needs Table
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FluentTheme.cardBg,
                        borderRadius:
                            BorderRadius.circular(FluentTheme.radiusCard),
                        border: Border.all(color: FluentTheme.border),
                        boxShadow: FluentTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Necessidades em Aberto',
                                style: FluentTheme.headlineMd.copyWith(fontSize: 16),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDE7E9),
                                  borderRadius: BorderRadius.circular(
                                    FluentTheme.radiusSm,
                                  ),
                                ),
                                child: const Text(
                                  'Meta Crítica',
                                  style: TextStyle(
                                    color: FluentTheme.accentRed,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...campaign.needItems.map((item) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: FluentTheme.sidebarBg,
                                borderRadius:
                                    BorderRadius.circular(FluentTheme.radiusSm),
                                border: Border.all(color: FluentTheme.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        FluentTheme.radiusSm,
                                      ),
                                      border:
                                          Border.all(color: FluentTheme.border),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2,
                                      color: FluentTheme.primary,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: FluentTheme.body.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Meta restante: ${item.metaRemainingText}',
                                          style: FluentTheme.bodyMuted,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: FluentTheme.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      minimumSize: const Size(90, 28),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          FluentTheme.radiusSm,
                                        ),
                                      ),
                                    ),
                                    onPressed: () => widget.onOpenDonate(
                                      campaign,
                                      startOnPix: false,
                                    ),
                                    child: const Text(
                                      'Doar Item',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              // Right Column (Sticky Summary & Actions Card)
              Expanded(
                flex: 35,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: FluentTheme.cardBg,
                    borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
                    border: Border.all(color: FluentTheme.border),
                    boxShadow: FluentTheme.elevationShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progresso da Arrecadação',
                        style: FluentTheme.label,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'R\$ 14.500',
                            style: FluentTheme.headlineLg.copyWith(
                              fontSize: 26,
                              color: FluentTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'de R\$ 20.000',
                            style: TextStyle(
                              color: FluentTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: const LinearProgressIndicator(
                          value: 0.72,
                          minHeight: 8,
                          backgroundColor: FluentTheme.sidebarBg,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FluentTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '72% da meta atingida',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: FluentTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '${campaign.daysLeft} dias restantes',
                            style: const TextStyle(
                              fontSize: 12,
                              color: FluentTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: FluentTheme.border),
                      const SizedBox(height: 20),

                      // CTA Buttons
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FluentTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(FluentTheme.radiusSm),
                          ),
                        ),
                        onPressed: () =>
                            widget.onOpenDonate(campaign, startOnPix: false),
                        icon: const Icon(Icons.inventory_2, size: 18),
                        label: const Text(
                          'Doar Itens Físicos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: FluentTheme.sidebarBg,
                          foregroundColor: FluentTheme.primary,
                          side: const BorderSide(color: FluentTheme.primary),
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(FluentTheme.radiusSm),
                          ),
                        ),
                        onPressed: () =>
                            widget.onOpenDonate(campaign, startOnPix: true),
                        icon: const Icon(Icons.qr_code_2, size: 18),
                        label: const Text(
                          'Doar com Pix Direto',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: FluentTheme.textPrimary,
                          side: const BorderSide(
                            color: FluentTheme.borderStrong,
                          ),
                          minimumSize: const Size.fromHeight(38),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(FluentTheme.radiusSm),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Inscrição como voluntário confirmada para o mutirão de sábado!',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.handyman, size: 16),
                        label: const Text(
                          'Quero ser Voluntário(a)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Social Proof
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: FluentTheme.sidebarBg,
                          borderRadius:
                              BorderRadius.circular(FluentTheme.radiusSm),
                          border: Border.all(color: FluentTheme.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.groups,
                              size: 18,
                              color: FluentTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+${campaign.supportersCount} vizinhos apoiaram',
                              style: FluentTheme.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

