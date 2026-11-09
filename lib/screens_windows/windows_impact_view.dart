import 'package:flutter/material.dart';
import '../theme/fluent_theme.dart';

class WindowsImpactView extends StatelessWidget {
  const WindowsImpactView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.query_stats, color: FluentTheme.primary, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Impacto Social & Transparência Pública',
                      style: FluentTheme.heading.copyWith(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Acompanhamento em tempo real de arrecadações comunitárias, notas fiscais e relatórios auditáveis.',
                  style: FluentTheme.body.copyWith(
                    color: FluentTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildBigCard(
                '14.820',
                'Quilos de Alimentos Entregues',
                '+18% este mês',
                Icons.restaurant,
              ),
              const SizedBox(width: 16),
              _buildBigCard(
                '1.240',
                'Famílias Beneficiadas',
                'Em 8 bairros periféricos',
                Icons.people,
              ),
              const SizedBox(width: 16),
              _buildBigCard(
                'R\$ 86.400',
                'Arrecadação Direta via Pix',
                '100% prestado em notas fiscais',
                Icons.payments,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comprovações e Prestações de Contas Recentes',
                  style: FluentTheme.subheading,
                ),
                const SizedBox(height: 12),
                _buildReceiptRow(
                  'Compra de Cestas Agroecológicas Heliópolis',
                  'Associação Mãos Dadas • Nota Fiscal nº 008129',
                  'R\$ 4.250,00',
                  'Aprovado pelo Conselho Comunitário',
                ),
                const Divider(height: 16),
                _buildReceiptRow(
                  'Aquisição de Telhas e Cimento para Creche Esperança',
                  'Comunidade Paraisópolis • Recibo nº 33104',
                  'R\$ 2.180,00',
                  'Aprovado pelo Conselho Comunitário',
                ),
                const Divider(height: 16),
                _buildReceiptRow(
                  'Distribuição de Cobertores Campanha Inverno',
                  'Cruz Vermelha / Ponto Brás • Relatório Fotográfico',
                  '450 un entregues',
                  'Auditado',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigCard(String value, String title, String subtitle, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: FluentTheme.cardBg,
          borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
          border: Border.all(color: FluentTheme.border),
          boxShadow: FluentTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: FluentTheme.hoverBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: FluentTheme.border),
              ),
              child: Icon(icon, color: FluentTheme.primary, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: FluentTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(title, style: FluentTheme.bodyBold),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: FluentTheme.caption.copyWith(color: FluentTheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String title, String desc, String value, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: FluentTheme.bodyBold),
            Text(desc, style: FluentTheme.caption),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: FluentTheme.bodyBold.copyWith(color: FluentTheme.primary)),
            Text(status, style: FluentTheme.caption.copyWith(color: FluentTheme.textSecondary)),
          ],
        ),
      ],
    );
  }
}

