import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'services/consent_service.dart';
import 'theme/app_theme.dart';

class ToolnovaApp extends StatelessWidget {
  const ToolnovaApp({
    required this.consentService,
    super.key,
  });

  final ConsentService consentService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolnova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: MainShell(consentService: consentService),
    );
  }
}
