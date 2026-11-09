import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/create_campaign_dialog.dart';
import 'home_screen.dart';
import 'impact_screen.dart';
import 'my_donations_screen.dart';
import 'profile_screen.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final currentIndex = state.currentNavIndex;

    final screens = const [
      HomeScreen(),
      MyDonationsScreen(),
      ImpactScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: screens[currentIndex.clamp(0, screens.length - 1)],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B2A1E).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Início
                _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.home,
                  label: 'Início',
                  isSelected: currentIndex == 0,
                  onTap: () => state.setNavIndex(0),
                ),
                // Doações
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.volunteer_activism,
                  label: 'Doações',
                  isSelected: currentIndex == 1,
                  onTap: () => state.setNavIndex(1),
                ),
                // Center Floating Plus Button
                Transform.translate(
                  offset: const Offset(0, -14),
                  child: GestureDetector(
                    onTap: () => CreateCampaignDialog.show(context),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppTheme.onPrimary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                // Impacto
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.insights,
                  label: 'Impacto',
                  isSelected: currentIndex == 2,
                  onTap: () => state.setNavIndex(2),
                ),
                // Perfil
                _buildNavItem(
                  context,
                  index: 3,
                  icon: Icons.person,
                  label: 'Perfil',
                  isSelected: currentIndex == 3,
                  onTap: () => state.setNavIndex(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
