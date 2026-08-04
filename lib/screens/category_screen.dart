import 'package:flutter/material.dart';

import '../models/tool_item.dart';
import '../services/preferences_service.dart';
import '../widgets/tool_card.dart';
import 'tool_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    required this.section,
    required this.favorites,
    required this.preferences,
    required this.onFavoriteChanged,
    super.key,
  });

  final ToolSection section;
  final Set<String> favorites;
  final PreferencesService preferences;
  final ValueChanged<String> onFavoriteChanged;

  Route<void> _toolRoute(ToolItem tool) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, animation, __) => ToolScreen(
        tool: tool,
        preferences: preferences,
      ),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0.02),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(section.colorValue);

    return Scaffold(
      appBar: AppBar(title: Text(section.title)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        itemCount: section.tools.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final tool = section.tools[index];
          return ToolCard(
            tool: tool,
            color: color,
            isFavorite: favorites.contains(tool.id),
            onFavorite: () => onFavoriteChanged(tool.id),
            onOpen: () => Navigator.of(context).push(_toolRoute(tool)),
          );
        },
      ),
    );
  }
}
