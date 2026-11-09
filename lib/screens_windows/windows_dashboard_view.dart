import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/fluent_theme.dart';
import '../widgets/custom_image.dart';

class WindowsDashboardView extends StatelessWidget {
  final Function(Campaign campaign) onOpenCampaignDetails;
  final Function(Campaign campaign, {bool startOnPix}) onOpenDonate;
  final VoidCallback onOpenCreateCampaign;

  const WindowsDashboardView({
    super.key,
    required this.onOpenCampaignDetails,
    required this.onOpenDonate,
    required this.onOpenCreateCampaign,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final campaigns = state.filteredCampaigns;

    final categories = [
      'Todas as Causas',
      'Segurança Alimentar',
      'Agasalho & Inverno',
      'Educação & Crianças',
      'Voluntariado',
      'Urgência Alta',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner / Stats Overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: FluentTheme.sidebarBg,
                          borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                          border: Border.all(color: FluentTheme.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: FluentTheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'ZONA SUL E REGIÃO METROPOLITANA',
                                style: FluentTheme.label.copyWith(
                                  color: FluentTheme.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: FluentTheme.headlineLg,
                          children: [
                            TextSpan(text: 'Olá, ${state.user.name}! '),
                            const TextSpan(
                              text: '14 iniciativas',
                              style: TextStyle(color: FluentTheme.primary),
                            ),
                            const TextSpan(text: ' precisam de apoio perto de você.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Veja as campanhas ativas esta semana e ajude a transformar realidades locais através de doações via Pix transparente ou voluntariado presencial.',
                        style: FluentTheme.bodyMuted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // 3 Metric Cards
                Row(
                  children: [
                    _buildMetricCard(
                      icon: Icons.payments,
                      value: 'R\$ 38.450',
                      label: 'Arrecadado no mês',
                      sublabel: '+12% vs mês anterior',
                      sublabelColor: FluentTheme.primary,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricCard(
                      icon: Icons.groups,
                      value: '1.420',
                      label: 'Famílias apoiadas',
                      sublabel: '+85 cadastradas',
                      sublabelColor: FluentTheme.primary,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricCard(
                      icon: Icons.volunteer_activism,
                      value: '85',
                      label: 'Voluntários ativos',
                      sublabel: 'Em 12 ações de campo',
                      sublabelColor: FluentTheme.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Filter bar & Category Pills
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = (cat == 'Todas as Causas' &&
                              state.selectedCategory == 'Todos') ||
                          (cat == 'Segurança Alimentar' &&
                              state.selectedCategory == 'Alimentos') ||
                          (cat == 'Agasalho & Inverno' &&
                              state.selectedCategory == 'Roupas & Agasalhos') ||
                          (cat == 'Educação & Crianças' &&
                              state.selectedCategory == 'Brinquedos') ||
                          (cat == 'Voluntariado' &&
                              state.selectedCategory == 'Voluntariado');

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            if (cat == 'Todas as Causas') {
                              state.setSelectedCategory('Todos');
                            } else if (cat == 'Segurança Alimentar') {
                              state.setSelectedCategory('Alimentos');
                            } else if (cat == 'Agasalho & Inverno') {
                              state.setSelectedCategory('Roupas & Agasalhos');
                            } else if (cat == 'Educação & Crianças') {
                              state.setSelectedCategory('Brinquedos');
                            } else if (cat == 'Voluntariado') {
                              state.setSelectedCategory('Voluntariado');
                            }
                          },
                          borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                              border: Border.all(
                                color: isSelected
                                    ? FluentTheme.borderStrong
                                    : FluentTheme.border,
                              ),
                              boxShadow: isSelected ? FluentTheme.cardShadow : null,
                            ),
                            child: Text(
                              cat,
                              style: FluentTheme.body.copyWith(
                                fontSize: 12,
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected
                                    ? FluentTheme.primary
                                    : FluentTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${campaigns.length} iniciativas encontradas',
                style: FluentTheme.label,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Responsive Grid of Campaign Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100 ? 3 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.88,
                ),
                itemCount: campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];
                  return _buildWindowsCampaignCard(context, campaign);
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required String sublabel,
    required Color sublabelColor,
  }) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.sidebarBg,
        borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
        border: Border.all(color: FluentTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              border: Border.all(color: FluentTheme.border),
            ),
            child: Icon(icon, color: FluentTheme.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: FluentTheme.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: FluentTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: sublabelColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowsCampaignCard(BuildContext context, Campaign campaign) {
    return Container(
      decoration: BoxDecoration(
        color: FluentTheme.cardBg,
        borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
        border: Border.all(color: FluentTheme.border),
        boxShadow: FluentTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlay tags
          Stack(
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: CustomImage(
                  url: campaign.imageUrls.first,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black45, Colors.transparent, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Category and Location Badges
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                        border: Border.all(color: FluentTheme.border),
                      ),
                      child: Text(
                        campaign.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: FluentTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                        border: Border.all(color: FluentTheme.border),
                      ),
                      child: Text(
                        campaign.location.split(',').first,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom stats on image
              Positioned(
                bottom: 8,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${campaign.daysLeft} dias restantes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(campaign.progressPercent * 100).toInt()}% atingido',
                      style: const TextStyle(
                        color: Color(0xFF96F7AF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Content body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: FluentTheme.title.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  campaign.subtitle,
                  style: FluentTheme.bodyMuted,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        campaign.currentProgressLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: FluentTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      campaign.targetProgressLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: FluentTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: campaign.progressPercent,
                    minHeight: 6,
                    backgroundColor: FluentTheme.sidebarBg,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      FluentTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Desktop Action Bar matching Fluent design
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FluentTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(32),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(FluentTheme.radiusSm),
                            side: const BorderSide(
                              color: FluentTheme.primaryBorder,
                            ),
                          ),
                        ),
                        onPressed: () => onOpenDonate(campaign),
                        child: Text(
                          campaign.category == 'Voluntariado'
                              ? 'Ser Voluntário'
                              : 'Doar Agora',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: FluentTheme.cardBg,
                        foregroundColor: FluentTheme.textPrimary,
                        minimumSize: const Size(80, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(FluentTheme.radiusSm),
                        ),
                        side: const BorderSide(color: FluentTheme.borderStrong),
                      ),
                      onPressed: () => onOpenCampaignDetails(campaign),
                      child: const Text(
                        'Detalhes',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

