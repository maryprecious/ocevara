import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/features/onboarding/screens/splash-screen.dart';
import 'package:ocevara/core/widgets/emergency_alert_overlay.dart';
import 'package:ocevara/features/sync/background_sync_service.dart';
import 'package:ocevara/core/services/geofence_service.dart';
import 'package:ocevara/core/providers/theme_provider.dart';
import 'package:ocevara/core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Background Sync
  await BackgroundSyncService.initialize();
  
  // Setup ProviderContainer to initialize services before runApp
  final container = ProviderContainer();
  
  // Start the new Geofencing Service
  container.read(geofenceServiceProvider).startMonitoring();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const OcevaraApp(),
    ),
  );
}

class OcevaraApp extends ConsumerWidget {
  const OcevaraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Ocevara',
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            Positioned.fill(child: const EmergencyAlertOverlay()),
          ],
        );
      },
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNavy,
          brightness: Brightness.light,
          primary: AppColors.primaryNavy,
          secondary: AppColors.primaryTeal,
          surface: AppColors.lightScaffold,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightScaffold,
        cardColor: AppColors.lightCard,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNavy,
          brightness: Brightness.dark,
          primary: AppColors.primaryNavy,
          secondary: AppColors.primaryTeal,
          surface: AppColors.darkScaffold,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.darkScaffold,
        cardColor: AppColors.darkCard,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F2D3D), // Slightly darker for dark mode app bar
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
