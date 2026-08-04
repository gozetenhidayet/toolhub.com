import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/ad_config.dart';
import '../data/tool_catalog.dart';
import '../models/tool_item.dart';
import '../services/consent_service.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import '../widgets/adaptive_banner.dart';
import '../widgets/category_icon.dart';
import '../widgets/tool_card.dart';
import 'category_screen.dart';
import 'tool_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    required this.consentService,
    super.key,
  });

  final ConsentService consentService;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final PreferencesService _preferences = PreferencesService();
  final TextEditingController _searchController = TextEditingController();

  int _index = 0;
  String _query = '';
  Set<String> _favorites = <String>{};
  List<String> _recent = <String>[];
  bool _loading = true;
  bool _privacyOptionsRequired = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final favorites = await _preferences.loadFavorites();
    final recent = await _preferences.loadRecent();
    final privacyRequired =
        await widget.consentService.isPrivacyOptionsRequired();

    if (!mounted) return;
    setState(() {
      _favorites = favorites;
      _recent = recent;
      _privacyOptionsRequired = privacyRequired;
      _loading = false;
    });
  }

  Future<void> _toggleFavorite(String id) async {
    setState(() {
      if (!_favorites.add(id)) {
        _favorites.remove(id);
      }
    });
    await _preferences.saveFavorites(_favorites);
  }

  Future<void> _refreshRecent() async {
    final recent = await _preferences.loadRecent();
    if (mounted) {
      setState(() => _recent = recent);
    }
  }

  Route<void> _toolRoute(ToolItem tool) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, animation, __) => ToolScreen(
        tool: tool,
        preferences: _preferences,
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
              begin: const Offset(0.035, 0.018),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  void _openTool(ToolItem tool) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(_toolRoute(tool)).then((_) => _refreshRecent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomeTab(
        query: _query,
        favorites: _favorites,
        onQueryChanged: (value) => setState(() => _query = value),
        searchController: _searchController,
        onOpenTool: _openTool,
        onToggleFavorite: _toggleFavorite,
        preferences: _preferences,
      ),
      _CategoriesTab(
        favorites: _favorites,
        preferences: _preferences,
        onFavoriteChanged: _toggleFavorite,
      ),
      _FavoritesTab(
        favorites: _favorites,
        onOpenTool: _openTool,
        onToggleFavorite: _toggleFavorite,
      ),
      _RecentTab(
        recent: _recent,
        onOpenTool: _openTool,
        onClear: () async {
          await _preferences.clearRecent();
          if (mounted) {
            setState(() => _recent = <String>[]);
          }
        },
      ),
      _SettingsTab(
        privacyOptionsRequired: _privacyOptionsRequired,
        onPrivacyOptions: widget.consentService.showPrivacyOptions,
      ),
    ];

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.025, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(_index),
                child: pages[_index],
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_index == 0 || _index == 1)
            AdaptiveBanner(consentService: widget.consentService),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) {
              HapticFeedback.selectionClick();
              setState(() => _index = value);
              if (value == 3) {
                _refreshRecent();
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Categories',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.query,
    required this.favorites,
    required this.onQueryChanged,
    required this.searchController,
    required this.onOpenTool,
    required this.onToggleFavorite,
    required this.preferences,
  });

  final String query;
  final Set<String> favorites;
  final ValueChanged<String> onQueryChanged;
  final TextEditingController searchController;
  final ValueChanged<ToolItem> onOpenTool;
  final ValueChanged<String> onToggleFavorite;
  final PreferencesService preferences;

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final results = normalized.isEmpty
        ? allTools.take(8).toList(growable: false)
        : allTools
            .where(
              (tool) =>
                  tool.name.toLowerCase().contains(normalized) ||
                  tool.description.toLowerCase().contains(normalized),
            )
            .toList(growable: false);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            sliver: SliverToBoxAdapter(
              child: _Hero(searchController: searchController, onQueryChanged: onQueryChanged),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                normalized.isEmpty ? 'Popular tools' : 'Search results',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.navy,
                    ),
              ),
            ),
          ),
          if (results.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No tools found.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
              sliver: SliverList.separated(
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final tool = results[index];
                  final section = sectionFor(tool.category);
                  return ToolCard(
                    tool: tool,
                    color: Color(section.colorValue),
                    isFavorite: favorites.contains(tool.id),
                    onOpen: () => onOpenTool(tool),
                    onFavorite: () => onToggleFavorite(tool.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.searchController,
    required this.onQueryChanged,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D46C7), Color(0xFF12B9B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24246BEE),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'toolnova.tools',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Powerful Tools.\nProfessional Results.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                  letterSpacing: -1,
                ),
          ),
          const SizedBox(height: 12),
          const Text(
            'PDF, OCR, calculators, converters and generators — '
            'fast, private and 100% free.',
            style: TextStyle(
              color: Color(0xFFE8F4FF),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: searchController,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Search PDF, OCR, calculators...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({
    required this.favorites,
    required this.preferences,
    required this.onFavoriteChanged,
  });

  final Set<String> favorites;
  final PreferencesService preferences;
  final ValueChanged<String> onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
        children: [
          Text(
            'All categories',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.navy,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            '${allTools.length} professional tools in one place.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          for (final section in toolSections)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CategoryScreen(
                          section: section,
                          favorites: favorites,
                          preferences: preferences,
                          onFavoriteChanged: onFavoriteChanged,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Color(section.colorValue)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            iconDataFor(section.icon),
                            color: Color(section.colorValue),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text('${section.tools.length} tools'),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab({
    required this.favorites,
    required this.onOpenTool,
    required this.onToggleFavorite,
  });

  final Set<String> favorites;
  final ValueChanged<ToolItem> onOpenTool;
  final ValueChanged<String> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final tools =
        allTools.where((tool) => favorites.contains(tool.id)).toList();

    return SafeArea(
      child: tools.isEmpty
          ? const _EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              message: 'Tap the heart beside a tool to save it here.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 28),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Favorites',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.navy,
                        ),
                  ),
                ),
                const SizedBox(height: 14),
                for (final tool in tools)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ToolCard(
                      tool: tool,
                      color: Color(sectionFor(tool.category).colorValue),
                      isFavorite: true,
                      onOpen: () => onOpenTool(tool),
                      onFavorite: () => onToggleFavorite(tool.id),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _RecentTab extends StatelessWidget {
  const _RecentTab({
    required this.recent,
    required this.onOpenTool,
    required this.onClear,
  });

  final List<String> recent;
  final ValueChanged<ToolItem> onOpenTool;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final byId = {for (final tool in allTools) tool.id: tool};
    final tools =
        recent.map((id) => byId[id]).whereType<ToolItem>().toList();

    return SafeArea(
      child: tools.isEmpty
          ? const _EmptyState(
              icon: Icons.history_rounded,
              title: 'No history yet',
              message: 'Recently opened tools will appear here.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recent tools',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.navy,
                                ),
                      ),
                    ),
                    TextButton(onPressed: onClear, child: const Text('Clear')),
                  ],
                ),
                const SizedBox(height: 12),
                for (final tool in tools)
                  Card(
                    child: ListTile(
                      onTap: () => onOpenTool(tool),
                      leading: const Icon(Icons.history_rounded),
                      title: Text(
                        tool.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        tool.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.privacyOptionsRequired,
    required this.onPrivacyOptions,
  });

  final bool privacyOptionsRequired;
  final VoidCallback onPrivacyOptions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.navy,
                ),
          ),
          const SizedBox(height: 16),
          if (privacyOptionsRequired)
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy choices'),
                subtitle: const Text('Review or change your ad preferences.'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: onPrivacyOptions,
              ),
            ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text('Privacy Policy'),
              subtitle: const Text(AdConfig.privacyPolicyUrl),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Use'),
              subtitle: const Text(AdConfig.termsUrl),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Ads are kept away from file upload, processing, result and '
                'download controls to reduce accidental taps. Full-screen ads '
                'are disabled in this starter.',
                style: TextStyle(height: 1.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppTheme.blue),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
