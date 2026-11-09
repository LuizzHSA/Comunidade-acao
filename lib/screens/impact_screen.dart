import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_image.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface.withOpacity(0.85),
        elevation: 0,
        title: const Text('Impacto Comunitário'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Impact Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: AppTheme.secondaryFixed, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'TRANSPARÊNCIA TOTAL',
                        style: TextStyle(
                          color: AppTheme.secondaryFixed,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '+1.400 Famílias Apoiadas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dados auditados e prestação de contas aberta para toda a comunidade.',
                    style: TextStyle(
                      color: Color(0xFFCBFFC2),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildMetricItem('38 Ton', 'Alimentos doados'),
                      Container(
                        width: 1,
                        height: 36,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      _buildMetricItem('850+', 'Voluntários ativos'),
                      Container(
                        width: 1,
                        height: 36,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      _buildMetricItem('100%', 'Entregas auditadas'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Histórias de Transformação',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            _buildStoryCard(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDtO-4ZYCRk1F7nljUlzFX2M1ZSeKmwwpGgp6YBauWMxKHxWrrcMKJR4GgYKJrTv4tQeTMKyFc6aoAaTH0MTjR-wdbPU9uY-XYe9n1Pm1M1Y-GKvRLge_AH1gbf-nOLa5KO-W9MagJahegtRh3nN55raCKMNTC0tLEW7hr-CHLzCrs7-2sGFzVTs3klzgaQiurEQAfSWTTyx6CbD4mQJpGI6SXbx5EYamSifUz97xg',
              title: 'Horta Agroecológica Heliópolis',
              quote:
                  '“Com as cestas verdes entregues a cada 15 dias, pude alimentar meus 3 filhos com saúde e dignidade.”',
              author: 'Dona Carmen, moradora há 14 anos',
            ),
            const SizedBox(height: 14),

            _buildStoryCard(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCrnug221KOqGwzUrTesVxa0X1PKwjlz5HX4Nc6iWfWWbJGgqF7n4gH-VH4JjQJ4g0b_WDtGm3uD8T1mY66-iYjG_Ur5ANDIfHRWU0lUoqy2F-VqyZMDhAULB6YHwLlafPDkiFM9CI7HXfceQdN_qq6dcHUgBJrGaBRFUNGvSNEuAuzpNhzTsFIZQp0ACi62HdQKmZlspczJD6RIFgjzodCX2CzcIdvJ9oEBIU2ZbE',
              title: 'Volta às Aulas no Complexo do Alemão',
              quote:
                  '“Ver os olhos dos pequenos brilhando ao abrir as mochilas novinhas não tem preço.”',
              author: 'Marcos, voluntário e educador comunitário',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFCBFFC2),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryCard({
    required String imageUrl,
    required String title,
    required String quote,
    required String author,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomImage(url: imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  author,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

