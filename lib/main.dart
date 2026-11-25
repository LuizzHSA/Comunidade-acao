import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/main_nav_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

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
  const ComunidadeEmAcaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        return MaterialApp(
          title: 'Comunidade em Ação',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: state.isAuthenticated
              ? const MainNavScreen()
              : const LoginScreen(),
        );
      },
    );
  }
}
