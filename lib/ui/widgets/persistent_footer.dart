import 'package:flutter/material.dart';
import 'package:emily_marathon_split_calculator/data/release_notes.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';
import 'package:emily_marathon_split_calculator/ui/widgets/release_notes_dialog.dart';

class PersistentFooter extends StatelessWidget {
  const PersistentFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: appTheme(context).cardPadding,
        vertical: appTheme(context).cardSpacing,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App name and version
          Row(
            children: [
              Icon(
                Icons.timer_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: appTheme(context).cardSpacing),
              Text(
                'Emily\'s Race Calculator',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),

          // Version with click handler
          GestureDetector(
            onTap: () => _showReleaseNotes(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: appTheme(context).cardSpacing,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'v${ReleaseNotesData.currentVersion}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReleaseNotes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ReleaseNotesDialog(),
    );
  }
}
