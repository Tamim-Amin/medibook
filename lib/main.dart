import 'package:flutter/material.dart';

import 'screens/dev/design_preview_screen.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MediBookApp());
}

class MediBookApp extends StatefulWidget {
  const MediBookApp({super.key});

  @override
  State<MediBookApp> createState() => _MediBookAppState();
}

class _MediBookAppState extends State<MediBookApp> {
  // TODO(Day 7): replace this local state with ThemeProvider + SharedPreferences.
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      initialRoute: AppRoutes.designPreview,
      routes: <String, WidgetBuilder>{
        // TODO(Day 3): remove designPreview and register splash, onboarding,
        // welcome, login, register and the main shell here.
        AppRoutes.designPreview: (BuildContext context) =>
            DesignPreviewScreen(onToggleTheme: _toggleTheme),
      },
    );
  }
}