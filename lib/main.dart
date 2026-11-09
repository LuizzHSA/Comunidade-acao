import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/main_nav_screen.dart';
import 'screens_windows/windows_shell.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'theme/fluent_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ComunidadeEmAcaoApp(),
    ),
  );
}

class ComunidadeEmAcaoApp extends StatelessWidget {
  final bool? initialWindowsMode;

  const ComunidadeEmAcaoApp({super.key, this.initialWindowsMode});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final isDesktopPlatform =
            !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.macOS ||
                defaultTargetPlatform == TargetPlatform.linux);

        return MaterialApp(
          title: 'Comunidade em Ação',
          debugShowCheckedModeBanner: false,
          theme: state.preferWindowsLayout
              ? FluentTheme.theme
              : AppTheme.lightTheme,
          home: LayoutBuilder(
            builder: (context, constraints) {
              final useWindows =
                  initialWindowsMode ??
                  (state.preferWindowsLayout ||
                      (isDesktopPlatform && constraints.maxWidth >= 700) ||
                      constraints.maxWidth >= 900);

              if (useWindows) {
                return WindowsShell(
                  onSwitchToMobile: () => state.setPreferWindowsLayout(false),
                );
              }

              // Mobile screens
              return state.isAuthenticated
                  ? const MainNavScreen()
                  : const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
