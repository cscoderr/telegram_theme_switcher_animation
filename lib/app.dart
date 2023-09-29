import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_dark_mode_animation/home/home.dart';
import 'package:telegram_dark_mode_animation/home/providers/theme_provider.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme,
      theme: AppTheme.instance.lightTheme(ThemeMode.light),
      darkTheme: AppTheme.instance.darkTheme(ThemeMode.dark),
      home: const HomePage(),
    );
  }
}

class AppTheme {
  AppTheme._();
  static final AppTheme _instance = AppTheme._();
  static AppTheme get instance => _instance;

  ThemeData _mainTheme(ThemeMode themeMode) {
    return ThemeData(
      brightness:
          themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness:
            themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  ThemeData darkTheme(ThemeMode themeMode) {
    return _mainTheme(themeMode).copyWith();
  }

  ThemeData lightTheme(ThemeMode themeMode) {
    return _mainTheme(themeMode).copyWith();
  }
}
