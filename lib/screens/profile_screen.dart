import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_image.dart';
import '../widgets/edit_profile_dialog.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface.withOpacity(0.85),
        elevation: 0,
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            tooltip: 'Editar perfil',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => EditProfileDialog.show(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            if (!state.isCloudConnected) ...[
              _buildDemoBanner(),
              const SizedBox(height: 12),
            ],
            _ProfileHeaderCard(user: user, state: state),
            const SizedBox(height: 20),
            _buildAchievementsCard(state),
            if (state.lastDonation != null) ...[
              const SizedBox(height: 20),
              _buildLastDonationCard(context, state),
            ],
            const SizedBox(height: 20),
            _buildSettingsCard(context, state),
            const SizedBox(height: 20),
            _buildLogoutButton(context, state),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryFixed,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud_off, size: 18, color: AppTheme.onTertiaryFixed),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Modo demonstração local: alterações não são sincronizadas com a nuvem.',
              style: TextStyle(fontSize: 12, color: AppTheme.onTertiaryFixed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard(AppState state) {
    final achievements = state.achievements;
    final unlocked = achievements.where((a) => a.unlocked).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.military_tech,
                color: AppTheme.tertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Conquistas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              Text(
                '$unlocked de ${achievements.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: achievements
                .map(
                  (a) => Tooltip(
                    message: a.description,
                    child: Opacity(
                      opacity: a.unlocked ? 1 : 0.4,
                      child: Container(
                        width: 96,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: a.unlocked
                              ? AppTheme.surfaceContainerLow
                              : AppTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: a.unlocked
                                ? AppTheme.primaryFixedDim
                                : AppTheme.outlineVariant.withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              a.unlocked ? a.emoji : '🔒',
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              a.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: a.unlocked
                                    ? AppTheme.onSurface
                                    : AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLastDonationCard(BuildContext context, AppState state) {
    final donation = state.lastDonation!;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final itemsLabel = donation.totalCount == 1
        ? '1 item'
        : '${donation.totalCount} itens';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Última doação',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            donation.campaignTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$itemsLabel • ${dateFormat.format(donation.date)} • ${donation.status}',
            style: const TextStyle(color: Color(0xFFCBFFC2), fontSize: 12),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              onPressed: () => _showReceiptsSheet(context, state),
              icon: const Icon(Icons.receipt_long, size: 16),
              label: const Text(
                'Ver recibos',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, AppState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: AppTheme.primary,
              ),
              title: const Text('Editar Dados Pessoais'),
              subtitle: const Text('Nome, cidade e apresentação'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => EditProfileDialog.show(context),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.history, color: AppTheme.primary),
              title: const Text('Histórico de Recibos'),
              subtitle: Text(
                '${state.donationHistory.length} recibo(s) disponível(is)',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showReceiptsSheet(context, state),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.security, color: AppTheme.primary),
              title: const Text('Privacidade & Segurança'),
              subtitle: const Text('Visibilidade e notificações'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showPrivacySheet(context),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppTheme.primary),
              title: const Text('Ajuda e Perguntas Frequentes'),
              subtitle: const Text('Dúvidas sobre doações e recibos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showFaqDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppState state) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.error,
        side: const BorderSide(color: AppTheme.errorContainer),
        backgroundColor: AppTheme.surfaceContainerLowest,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppTheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
            ),
            title: const Text('Sair da conta?'),
            content: const Text(
              'Você precisará informar e-mail e senha para entrar novamente.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: TextButton.styleFrom(foregroundColor: AppTheme.error),
                child: const Text('Sair'),
              ),
            ],
          ),
        );
        if (shouldLogout != true) return;
        state.logout();
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      },
      icon: const Icon(Icons.logout, size: 20),
      label: const Text(
        'Sair da Conta',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showReceiptsSheet(BuildContext context, AppState state) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final history = List<DonationRecord>.from(state.donationHistory)
      ..sort((a, b) => b.date.compareTo(a.date));

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.35,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Histórico de Recibos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ),
                      if (history.isNotEmpty)
                        Text(
                          '${history.length} recibo(s)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: history.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Nenhum recibo ainda. Suas doações confirmadas aparecem aqui.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: history.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final record = history[index];
                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.campaignTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${record.totalCount} itens • '
                                    '${dateFormat.format(record.date)} • '
                                    '${record.status}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Recibo: ${record.receiptCode}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          await Clipboard.setData(
                                            ClipboardData(
                                              text:
                                                  '${record.campaignTitle} - '
                                                  '${record.receiptCode}',
                                            ),
                                          );
                                          if (!sheetContext.mounted) return;
                                          ScaffoldMessenger.of(sheetContext)
                                              .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Recibo copiado para a área de transferência.',
                                                  ),
                                                ),
                                              );
                                        },
                                        icon: const Icon(Icons.copy, size: 16),
                                        label: const Text(
                                          'Copiar',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Consumer<AppState>(
          builder: (context, state, _) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Privacidade & Segurança',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Escolha o que outras pessoas da comunidade podem ver.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Perfil público'),
                      subtitle: const Text(
                        'Outros doadores podem ver seu nome e conquistas.',
                      ),
                      value: state.isProfilePublic,
                      activeColor: AppTheme.primary,
                      onChanged: state.setProfilePublic,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mostrar minha cidade'),
                      subtitle: const Text(
                        'Exibe a cidade no seu perfil público.',
                      ),
                      value: state.shareCity,
                      activeColor: AppTheme.primary,
                      onChanged: state.setShareCity,
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Notificações',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Novas campanhas'),
                      subtitle: const Text(
                        'Avisos de causas urgentes na sua região.',
                      ),
                      value: state.notifyNewCampaigns,
                      activeColor: AppTheme.primary,
                      onChanged: state.setNotifyNewCampaigns,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Status das doações'),
                      subtitle: const Text(
                        'Avisos quando a entrega for confirmada.',
                      ),
                      value: state.notifyDonationStatus,
                      activeColor: AppTheme.primary,
                      onChanged: state.setNotifyDonationStatus,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: AppTheme.primary,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Seus dados de pagamento nunca são exibidos no perfil.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFaqDialog(BuildContext context) {
    const faqs = [
      (
        'Como acompanho minha doação?',
        'A entrega e o status aparecem em "Minhas Doações" e nos recibos do perfil.',
      ),
      (
        'Onde encontro o recibo?',
        'Toque em "Histórico de Recibos" no perfil. Você pode copiar o código do recibo.',
      ),
      (
        'Posso mudar meus dados depois?',
        'Sim. Use "Editar Dados Pessoais" para atualizar nome, cidade e apresentação.',
      ),
      (
        'Minhas doações ficam salvas?',
        'Com o Firebase conectado, sim. No modo de demonstração local, os dados valem apenas enquanto o app está aberto.',
      ),
    ];

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
        ),
        title: const Text('Ajuda e FAQ'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: faqs
                  .map(
                    (faq) => ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(bottom: 12),
                      title: Text(
                        faq.$1,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faq.$2,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.user, required this.state});

  final UserProfile user;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final level = state.impactLevel;
    final nextLevel = level.isMax
        ? null
        : ImpactLevel.levels.firstWhere((l) => l.minItems == level.nextLevelAt);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: CustomImage(
                  url: user.avatarUrl,
                  width: 76,
                  height: 76,
                  fallbackWidget: _InitialsAvatar(initials: user.initials),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    if (user.city.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              user.city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar perfil',
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.edit,
                  size: 18,
                  color: AppTheme.onSurfaceVariant,
                ),
                onPressed: () => EditProfileDialog.show(context),
              ),
            ],
          ),
          if (user.bio.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user.bio,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Doações', '${user.donationsCount}'),
              _divider(),
              _buildStatItem('Itens Doados', '${user.totalItemsDonated}'),
              _divider(),
              _buildStatItem('Causas', '${state.campaignsSupported}'),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(level.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nível ${level.level} • ${level.title}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: level.progressFor(user.totalItemsDonated),
                    minHeight: 8,
                    backgroundColor: AppTheme.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation(
                      AppTheme.primaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  nextLevel == null
                      ? 'Você alcançou o nível máximo. Obrigado por transformar vidas!'
                      : 'Faltam ${level.itemsToNextLevel(user.totalItemsDonated)} itens para o nível '
                            '${nextLevel.level} • ${nextLevel.title} ${nextLevel.emoji}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: 1,
      color: AppTheme.outlineVariant.withOpacity(0.4),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppTheme.primaryFixed,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppTheme.onPrimaryFixed,
        ),
      ),
    );
  }
}
