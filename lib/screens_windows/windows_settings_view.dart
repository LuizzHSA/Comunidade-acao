import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/fluent_theme.dart';

class WindowsSettingsView extends StatefulWidget {
  const WindowsSettingsView({super.key});

  @override
  State<WindowsSettingsView> createState() => _WindowsSettingsViewState();
}

class _WindowsSettingsViewState extends State<WindowsSettingsView> {
  bool _notifyNewCampaigns = true;
  bool _notifyDonationStatus = true;
  bool _compactMode = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;

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
            child: Row(
              children: [
                const Icon(Icons.settings, color: FluentTheme.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Configurações da Aplicação',
                  style: FluentTheme.heading.copyWith(fontSize: 20),
                ),
              ],
            ),
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
                Text('Perfil & Identificação', style: FluentTheme.subheading),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: FluentTheme.primary.withOpacity(0.12),
                    child: Text(
                      'AP',
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.primary,
                      ),
                    ),
                  ),
                  title: Text(user.name, style: FluentTheme.bodyBold),
                  subtitle: Text(
                    '${user.email} • ${user.city}',
                    style: FluentTheme.caption,
                  ),
                ),
                const Divider(height: 24),
                Text('Notificações no Windows', style: FluentTheme.subheading),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Novas campanhas na minha região'),
                  subtitle: Text(
                    'Receber alerta quando uma causa emergencial for iniciada em São Paulo.',
                    style: FluentTheme.caption,
                  ),
                  value: _notifyNewCampaigns,
                  activeColor: FluentTheme.primary,
                  onChanged: (val) => setState(() => _notifyNewCampaigns = val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Status de entrega das doações'),
                  subtitle: Text(
                    'Notificar quando o ponto de coleta registrar o recebimento dos mantimentos.',
                    style: FluentTheme.caption,
                  ),
                  value: _notifyDonationStatus,
                  activeColor: FluentTheme.primary,
                  onChanged: (val) => setState(() => _notifyDonationStatus = val),
                ),
                const Divider(height: 24),
                Text('Aparência e Sistema', style: FluentTheme.subheading),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Modo de exibição compacto Fluent'),
                  subtitle: Text(
                    'Reduz espaçamentos de cards para acomodar mais itens na tela.',
                    style: FluentTheme.caption,
                  ),
                  value: _compactMode,
                  activeColor: FluentTheme.primary,
                  onChanged: (val) => setState(() => _compactMode = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

