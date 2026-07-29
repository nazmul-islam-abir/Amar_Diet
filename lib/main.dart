import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'widgets/gradient_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.hydrate();
  runApp(const AmarDietApp());
}

class AmarDietApp extends StatelessWidget {
  const AmarDietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amar Diet',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) => GradientBackground(child: child!),
      home: const SplashScreen(),
    );
  }
}
