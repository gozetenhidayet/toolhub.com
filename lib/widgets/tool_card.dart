import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tool_item.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.tool,
    required this.color,
    required this.isFavorite,
    required this.onOpen,
    required this.onFavorite,
    super.key,
  });

  final ToolItem tool;
  final Color color;
  final bool isFavorite;
  final VoidCallback onOpen;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${tool.name}. ${tool.description}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onOpen();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 10, 16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tool.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              height: 1.35,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onFavorite();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(isFavorite),
                      color: isFavorite
                          ? const Color(0xFFE8417B)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
