import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/carvora_provider.dart';
import 'theme/carvora_theme.dart';
import 'screens/main_shell_screen.dart';
import 'screens/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for seamless dark aesthetic
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: CarvoraColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CarvoraApp());
}

class CarvoraApp extends StatelessWidget {
  const CarvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CarvoraProvider())],
      child: MaterialApp(
        title: 'CARVORA — Bespoke Automotive Enhancements',
        debugShowCheckedModeBanner: false,
        theme: CarvoraTheme.darkTheme,
        home: const _AppGate(),
      ),
    );
  }
}

class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<CarvoraProvider>(
      builder: (context, provider, child) => provider.isUserAuthenticated
          ? const MainShellScreen()
          : const AuthScreen(),
    );
  }
}
