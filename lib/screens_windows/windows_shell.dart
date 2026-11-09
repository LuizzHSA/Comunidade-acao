import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/fluent_theme.dart';
import 'windows_campaign_details_view.dart';
import 'windows_create_campaign_view.dart';
import 'windows_dashboard_view.dart';
import 'windows_donate_view.dart';
import 'windows_impact_view.dart';
import 'windows_my_donations_view.dart';
import 'windows_settings_view.dart';

class WindowsShell extends StatefulWidget {
  final VoidCallback? onSwitchToMobile;

  const WindowsShell({super.key, this.onSwitchToMobile});

  @override
  State<WindowsShell> createState() => _WindowsShellState();
}

class _WindowsShellState extends State<WindowsShell> {
  int _activeNavIndex = 0;
  Campaign? _selectedCampaignForDetails;
  Campaign? _selectedCampaignForDonate;
  bool _startOnPix = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetails(Campaign campaign) {
    setState(() {
      _selectedCampaignForDetails = campaign;
      _selectedCampaignForDonate = null;
    });
  }

  void _navigateToDonate(Campaign campaign, {bool startOnPix = false}) {
    setState(() {
      _selectedCampaignForDonate = campaign;
      _startOnPix = startOnPix;
    });
  }

  void _backToFeed() {
    setState(() {
      _selectedCampaignForDetails = null;
      _selectedCampaignForDonate = null;
      _activeNavIndex = 0;
    });
  }

  void _backToDetails() {
    setState(() {
      _selectedCampaignForDonate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: FluentTheme.background,
      body: Row(
        children: [
          // Fluent Side Navigation Rail (Sidebar 256px)
          _buildSidebar(context, state),

          // Main Workspace
          Expanded(
            child: Column(
              children: [
                // Windows Title / Command Bar Style Topbar (56px)
                _buildTopBar(context, state),

                // Main Content View
                Expanded(
                  child: Container(
                    color: FluentTheme.background,
                    child: _buildCurrentView(state),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, AppState state) {
    final navItems = [
      {'title': 'Início / Feed', 'icon': Icons.feed_outlined, 'index': 0},
      {'title': 'Explorar Campanhas', 'icon': Icons.explore_outlined, 'index': 1},
      {'title': 'Minhas Doações', 'icon': Icons.favorite_border, 'index': 2},
      {'title': 'Criar Campanha', 'icon': Icons.add_circle_outline, 'index': 3},
      {'title': 'Impacto & Transparência', 'icon': Icons.query_stats, 'index': 4},
      {'title': 'Configurações', 'icon': Icons.settings_outlined, 'index': 5},
    ];

    return Container(
      width: 256,
      decoration: const BoxDecoration(
        color: FluentTheme.sidebarBg,
        border: Border(right: BorderSide(color: FluentTheme.border)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Brand Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: FluentTheme.primary,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: FluentTheme.primary.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comunidade',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: FluentTheme.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'EM AÇÃO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: FluentTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Nav links
          Expanded(
            child: ListView.separated(
              itemCount: navItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final item = navItems[i];
                final index = item['index'] as int;
                final isSelected =
                    _activeNavIndex == index &&
                    _selectedCampaignForDetails == null &&
                    _selectedCampaignForDonate == null;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _activeNavIndex = index;
                      _selectedCampaignForDetails = null;
                      _selectedCampaignForDonate = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEAEAEA)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        FluentTheme.radiusSm,
                      ),
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? FluentTheme.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 18,
                          color: isSelected
                              ? FluentTheme.primary
                              : FluentTheme.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? FluentTheme.textPrimary
                                  : FluentTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // User Profile Box Footer
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: FluentTheme.border)),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                border: Border.all(color: FluentTheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F5ED),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'AP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: FluentTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: FluentTheme.textPrimary,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          state.user.city,
                          style: const TextStyle(
                            fontSize: 11,
                            color: FluentTheme.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      size: 16,
                      color: FluentTheme.textSecondary,
                    ),
                    onPressed: () {
                      state.logout();
                    },
                    tooltip: 'Sair',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppState state) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: FluentTheme.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Search with Ctrl+K chip
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              height: 34,
              decoration: BoxDecoration(
                color: FluentTheme.hoverBg,
                border: Border.all(color: FluentTheme.border),
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.search,
                    size: 17,
                    color: FluentTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Buscar campanhas, causas ou vizinhos...',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: FluentTheme.textTertiary,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => state.setSearchQuery(val),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'Ctrl+K',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: FluentTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Location Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: FluentTheme.hoverBg,
              border: Border.all(color: FluentTheme.border),
              borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 15,
                  color: FluentTheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'São Paulo, SP',
                  style: FluentTheme.captionBold.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Action Button "+ Nova Campanha"
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _activeNavIndex = 3;
                _selectedCampaignForDetails = null;
                _selectedCampaignForDonate = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FluentTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              ),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              'Nova Campanha',
              style: FluentTheme.captionBold.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),

          // Notifications Button
          Stack(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: FluentTheme.border),
                  borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: FluentTheme.textSecondary,
                  ),
                  onPressed: () {
                    state.clearNotificationsBadge();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nenhuma nova notificação pendente.'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                ),
              ),
              if (state.hasUnreadNotifications)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: FluentTheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          // Optional Switch to Mobile layout pill
          if (widget.onSwitchToMobile != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.phone_android,
                size: 18,
                color: FluentTheme.textSecondary,
              ),
              onPressed: widget.onSwitchToMobile,
              tooltip: 'Alternar para Modo Mobile',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentView(AppState state) {
    if (_selectedCampaignForDonate != null) {
      return WindowsDonateView(
        campaign: _selectedCampaignForDonate!,
        onBackToFeed: _backToFeed,
        onBackToDetails: _backToDetails,
        startOnPix: _startOnPix,
      );
    }

    if (_selectedCampaignForDetails != null) {
      return WindowsCampaignDetailsView(
        campaign: _selectedCampaignForDetails!,
        onBackToFeed: _backToFeed,
        onOpenDonate: (camp, {startOnPix = false}) =>
            _navigateToDonate(camp, startOnPix: startOnPix),
      );
    }

    switch (_activeNavIndex) {
      case 0:
      case 1:
        return WindowsDashboardView(
          onOpenCampaignDetails: _navigateToDetails,
          onOpenDonate: _navigateToDonate,
          onOpenCreateCampaign: () {
            setState(() {
              _activeNavIndex = 3;
            });
          },
        );
      case 2:
        return WindowsMyDonationsView(
          onExploreMore: () {
            setState(() {
              _activeNavIndex = 0;
            });
          },
        );
      case 3:
        return WindowsCreateCampaignView(
          onCancel: _backToFeed,
          onSuccess: _backToFeed,
        );
      case 4:
        return const WindowsImpactView();
      case 5:
        return const WindowsSettingsView();
      default:
        return WindowsDashboardView(
          onOpenCampaignDetails: _navigateToDetails,
          onOpenDonate: _navigateToDonate,
          onOpenCreateCampaign: () {
            setState(() {
              _activeNavIndex = 3;
            });
          },
        );
    }
  }
}

