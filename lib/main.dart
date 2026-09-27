import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/providers/store_provider.dart';
import 'package:rohanmandalas/screens/main_shell.dart';
import 'package:rohanmandalas/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StoreProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rohan's Mandala | Handcrafted Mandala Art",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const MainShell(),
    );
  }
}
