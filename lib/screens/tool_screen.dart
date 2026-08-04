import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/tool_item.dart';
import '../services/preferences_service.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({
    required this.tool,
    required this.preferences,
    super.key,
  });

  final ToolItem tool;
  final PreferencesService preferences;

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    widget.preferences.addRecent(widget.tool.id);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() => _progress = progress);
            }
          },
          onPageStarted: (_) {
            if (mounted) {
              setState(() => _hasError = false);
            }
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame && mounted) {
              setState(() => _hasError = true);
            }
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            final allowed = uri != null &&
                (uri.host == 'toolnova.tools' ||
                    uri.host.endsWith('.toolnova.tools'));
            return allowed
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.tool.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tool.name),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: _controller.reload,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        bottom: _progress < 100
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(value: _progress / 100),
              )
            : null,
      ),
      body: _hasError
          ? _ErrorState(onRetry: _controller.reload)
          : SafeArea(
              child: WebViewWidget(controller: _controller),
            ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 58),
            const SizedBox(height: 16),
            Text(
              'This tool could not be loaded.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your internet connection and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
