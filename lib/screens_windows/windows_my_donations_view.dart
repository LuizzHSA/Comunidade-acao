import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/fluent_theme.dart';

class WindowsMyDonationsView extends StatelessWidget {
  final VoidCallback onExploreMore;

  const WindowsMyDonationsView({
    super.key,
    required this.onExploreMore,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final history = state.donationHistory;
    final user = state.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minhas Contribuições Solidárias',
                        style: FluentTheme.heading.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Histórico completo de doações, recibos de entrega e rastreamento de impacto comunitário.',
                        style: FluentTheme.body.copyWith(
                          color: FluentTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    _buildMetricBox(
                      '${user.donationsCount}',
                      'Doações Realizadas',
                      Icons.volunteer_activism,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricBox(
                      '${user.totalItemsDonated}',
                      'Itens Entregues',
                      Icons.inventory_2,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricBox(
                      '100%',
                      'Transparência Verificada',
                      Icons.verified,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tabela Fluent de Registros de Doação
          Container(
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Registros de Doações Recentes',
                        style: FluentTheme.subheading.copyWith(
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: onExploreMore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FluentTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              FluentTheme.radiusSm,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: Text(
                          'Apoiar Nova Campanha',
                          style: FluentTheme.captionBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  color: FluentTheme.hoverBg,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'CAMPANHA / CAUSA',
                          style: FluentTheme.captionBold.copyWith(
                            fontSize: 11,
                            color: FluentTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'DATA',
                          style: FluentTheme.captionBold.copyWith(
                            fontSize: 11,
                            color: FluentTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'ITENS DOADOS',
                          style: FluentTheme.captionBold.copyWith(
                            fontSize: 11,
                            color: FluentTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'STATUS',
                          style: FluentTheme.captionBold.copyWith(
                            fontSize: 11,
                            color: FluentTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'RECIBO / PROTOCOLO',
                          style: FluentTheme.captionBold.copyWith(
                            fontSize: 11,
                            color: FluentTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (history.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 48,
                            color: FluentTheme.textTertiary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhuma doação registrada ainda.',
                            style: FluentTheme.body.copyWith(
                              color: FluentTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...history.map((record) {
                    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(record.date);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: FluentTheme.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.campaignTitle,
                                  style: FluentTheme.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: FluentTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  record.deliveryMethod,
                                  style: FluentTheme.caption.copyWith(
                                    fontSize: 11,
                                    color: FluentTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(dateStr, style: FluentTheme.caption),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: record.itemsWithQty.entries.map((e) {
                                return Text(
                                  '• ${e.key}: ${e.value}',
                                  style: FluentTheme.caption.copyWith(
                                    color: FluentTheme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDFF6DD),
                                border: Border.all(
                                  color: const Color(0xFFBCE8BB),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                record.status,
                                style: FluentTheme.captionBold.copyWith(
                                  color: FluentTheme.primary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: FluentTheme.hoverBg,
                                  border: Border.all(
                                    color: FluentTheme.border,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  record.receiptCode,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: FluentTheme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
    );
  }

  Widget _buildMetricBox(String val, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: FluentTheme.hoverBg,
        border: Border.all(color: FluentTheme.border),
        borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: FluentTheme.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                val,
                style: FluentTheme.subheading.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FluentTheme.textPrimary,
                ),
              ),
              Text(
                label,
                style: FluentTheme.caption.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

