import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_image.dart';
import '../widgets/pix_modal.dart';
import 'donate_items_screen.dart';

class CampaignDetailsScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailsScreen({
    super.key,
    required this.campaign,
  });

  @override
  State<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showContactDialog() {
    final messageController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const ClipOval(
                  child: CustomImage(
                    url:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuA0hI8JiFr09NU92GL3tsIIXG69uT910pSgHrtw1-FHIGOozIzZ_AXpayfl3-4i9NQQx5Tp4ckBZrwiUuF5R5rc77zeotpmF-mOPJh-rH5oLPXps1j_Z0ZBjVkFjyMBIz-EmC4DBOG0CU98-QaWECxSyOTekMtCu604yVLnhAp63-xNhO0fuvvAI72PfKs8J6wR7Fty26m_jKMqTbJhL8zRnVCnUi4IBmagDFuqzfE',
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Falar com ${widget.campaign.organizationName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Respondemos geralmente em menos de 2 horas',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escreva sua mensagem ou dúvida sobre a campanha...',
                filled: true,
                fillColor: AppTheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mensagem enviada para a coordenação da campanha!'),
                  ),
                );
              },
              child: const Text(
                'Enviar Mensagem',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVolunteerConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism, color: AppTheme.primary),
            SizedBox(width: 8),
            Text('Seja Bem-vindo(a)!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você está se candidatando como voluntário(a) para: "${widget.campaign.title}".',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações do Mutirão:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.campaign.volunteerDateInfo ??
                        'Neste sábado, 08h às 13h - Heliópolis, SP',
                    style: const TextStyle(
                      color: AppTheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.onPrimary,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppTheme.primaryContainer,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Inscrição confirmada! Você receberá detalhes no WhatsApp.'),
                ),
              );
            },
            child: const Text('Confirmar Presença'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;
    final state = context.watch<AppState>();
    final images = campaign.imageUrls.isNotEmpty
        ? campaign.imageUrls
        : [
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAaTSkNcQAJ801onqGs3ydQX5lZUg3k3_0F0ilTnC9t_c-fDYZ_NgihjUuoEJU3ZTrD0uEXogF_OymTurf08m2Tk2kAgo1LV6p23TohT9sLDbBvxLHRNY95mSBozeFEnZ8t8YKQAk_UkxWHZ7122xvtxhVWN0aG_LhnkLCesdPcLZbhYxod6ZYGBfprSyxud1vgwIe0d5QS42v2oONnNoLi0OuiXbNrQ6L5dH7Kc7U'
          ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface.withOpacity(0.85),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detalhes Da Campanha'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ClipOval(
              child: CustomImage(
                url: state.user.avatarUrl,
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Carousel
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (idx) {
                      setState(() {
                        _currentSlide = idx;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CustomImage(
                        url: images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black26,
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Floating counter badge: "1/4 📷"
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.inverseSurface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.photo_camera,
                            size: 14,
                            color: AppTheme.inverseOnSurface,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_currentSlide + 1}/${images.length}',
                            style: const TextStyle(
                              color: AppTheme.inverseOnSurface,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dot indicators
                  Positioned(
                    bottom: 14,
                    left: 16,
                    child: Row(
                      children: List.generate(images.length, (idx) {
                        final isSelected = _currentSlide == idx;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          width: isSelected ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Header tags
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.eco,
                        size: 14,
                        color: AppTheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${campaign.category} & Nutrição',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onSecondaryContainer,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 14,
                        color: AppTheme.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Campanha Ativa',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Campaign Title
            Text(
              campaign.title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
            ),
            const SizedBox(height: 6),

            // Location with interactive map link
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Localização: ${campaign.location}'),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    campaign.location,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const Text(
                    ' • ',
                    style: TextStyle(color: AppTheme.outlineVariant),
                  ),
                  const Text(
                    'Ver no mapa',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Organizer Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const ClipOval(
                        child: CustomImage(
                          url:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuA0hI8JiFr09NU92GL3tsIIXG69uT910pSgHrtw1-FHIGOozIzZ_AXpayfl3-4i9NQQx5Tp4ckBZrwiUuF5R5rc77zeotpmF-mOPJh-rH5oLPXps1j_Z0ZBjVkFjyMBIz-EmC4DBOG0CU98-QaWECxSyOTekMtCu604yVLnhAp63-xNhO0fuvvAI72PfKs8J6wR7Fty26m_jKMqTbJhL8zRnVCnUi4IBmagDFuqzfE',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          campaign.organizationYears,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surfaceContainer,
                      foregroundColor: AppTheme.primary,
                      elevation: 0,
                      minimumSize: const Size(88, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _showContactDialog,
                    icon: const Icon(Icons.chat_bubble_outline, size: 15),
                    label: const Text(
                      'Contato',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detailed Progress Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Arrecadado',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'R\$ 14.500',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'de R\$ 20.000',
                                style: TextStyle(
                                  color: AppTheme.onSurfaceVariant,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '72%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.tertiaryFixed,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 12,
                                  color: AppTheme.onTertiaryFixed,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Faltam 12 dias',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.onTertiaryFixed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.72,
                      minHeight: 12,
                      backgroundColor: AppTheme.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Avatars stack
                          const SizedBox(
                            width: 64,
                            height: 24,
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: CustomImage(
                                    url:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDh11Mc8Xd_yEdv9gQMLQ5MblAtzgtLPoEE-eqWPF_vkPzrEGW_nWc3K7wHqY9IStW-8TyDsTsw91IJcmBDujW5KwmMBtqm-WbiNscIkootWeu0Nn9dc5Js3w1YdX3ES_8xMGBD_C_Ac5Ut6rV-j3SEcVIHhIO5gwoAy3KgQppMNfON0hXi0x658YnD3YnMCj83vncAue6dGsexklhg0xLrlcLeyc-Ig_hPoxGfuE4',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  child: ClipOval(
                                    child: CustomImage(
                                      url:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBnSGUN0unjeF6uy449U6_ba3-EToO8yaxdIozG_9iWVEe694g7b5kuT0BxFl4dkFuoH0suI1Ozyvrmxt6zrITJVlG2GmbG3iT8rFLFO_KlcyXkQGh9W6dxQa1C6UhplTDmbBQH8sV072fC0SuNndNx7MA6oGq0r1I9eCd7jLKrnQgo3SdCPZ6goLsOaRLdb1cZhLZjKWAxt-5LO7VTXgh0MYHgOQ0JBOkVzwjj9WI',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 32,
                                  child: ClipOval(
                                    child: CustomImage(
                                      url:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTw8uY9U-v1nOIymbTWMio6yHBhAy1mK-QQfQn_3Zn2leF7X8bzGCBQxpoHmKWG_U6EM7rQ4f3C_bVdHj6gLj889n9TWm5oeXcieHF7ntL93YJK-fB5FOkxhIcrNgxQNranNX8ZNI_DYpCbg94xVVZzaOy882OGm7M8bFm2CDyGg27f8MH1KtXcV4zC_139Q2vwNG188ssXbP7MwsOj34AOSY_rJSOYIWJbOzUsUQ',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+${campaign.supportersCount + 6} vizinhos apoiaram',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'Transparência 100%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.shield,
                            size: 14,
                            color: AppTheme.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description: "Sobre a Iniciativa"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Sobre a Iniciativa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    campaign.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            campaign.highlightText,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section: "Necessidades Urgentes"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.priority_high,
                            color: AppTheme.error,
                            size: 22,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Necessidades Urgentes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Meta Crítica',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Item 1: Arroz e Feijão
                  _buildNeedItemCard(
                    context,
                    icon: Icons.grain,
                    iconColor: AppTheme.onSecondaryContainer,
                    iconBg: AppTheme.secondaryContainer,
                    title: 'Arroz e Feijão',
                    subtitle: 'Alimentos base fundamentais',
                    percentText: '68% arrecadado',
                    progressValue: 0.68,
                    metaText: 'Meta: 80 kg necessários',
                    remainingText: 'Faltam 25 kg',
                  ),
                  const SizedBox(height: 10),

                  // Item 2: Óleo e Leite em Pó
                  _buildNeedItemCard(
                    context,
                    icon: Icons.restaurant,
                    iconColor: AppTheme.tertiary,
                    iconBg: AppTheme.tertiaryFixed,
                    title: 'Óleo e Leite em Pó',
                    subtitle: 'Proteína e nutrição infantil',
                    percentText: '60% arrecadado',
                    progressValue: 0.60,
                    metaText: 'Meta: 100 unidades',
                    remainingText: 'Faltam 40 un',
                  ),
                  const SizedBox(height: 10),

                  // Item 3: Voluntários Sábado
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.surfaceContainerHigh,
                              child: Icon(
                                Icons.volunteer_activism,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Montagem das Cestas',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Neste sábado, 08h às 13h',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '5 vagas abertas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.onPrimaryFixed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Prominent Action Buttons
            Column(
              children: [
                // Button 1: Doar Itens Físicos
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryContainer,
                    foregroundColor: AppTheme.onPrimary,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DonateItemsScreen(campaign: campaign),
                      ),
                    );
                  },
                  icon: const Icon(Icons.inventory_2, size: 22),
                  label: const Text(
                    'Doar Itens Físicos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // Button 2: Doar com Pix
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryContainer,
                    foregroundColor: AppTheme.onSecondaryContainer,
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    PixModal.show(
                      context,
                      pixKey: campaign.pixKey ?? 'pix@comunidade-em-acao.org',
                      campaignTitle: campaign.title,
                    );
                  },
                  icon: const Icon(Icons.qr_code_2, size: 22),
                  label: const Text(
                    'Doar qualquer valor com Pix',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // Button 3: Quero ser Voluntário
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceContainer,
                    foregroundColor: AppTheme.primary,
                    side: BorderSide.none,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _showVolunteerConfirmation,
                  icon: const Icon(Icons.favorite, size: 20),
                  label: const Text(
                    'Quero ser Voluntário(a)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNeedItemCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String percentText,
    required double progressValue,
    required String metaText,
    required String remainingText,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: iconBg,
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
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
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: AppTheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metaText,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    remainingText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
