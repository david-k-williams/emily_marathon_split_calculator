import 'package:flutter/material.dart';
import 'package:emily_marathon_split_calculator/data/release_notes.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

class ReleaseNotesDialog extends StatelessWidget {
  const ReleaseNotesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(appTheme(context).largeBorderRadius),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(appTheme(context).cardPadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(appTheme(context).largeBorderRadius),
                  topRight:
                      Radius.circular(appTheme(context).largeBorderRadius),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.new_releases_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                  SizedBox(width: appTheme(context).cardSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Release Notes',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          'What\'s new in Emily\'s Race Calculator',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.8),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(appTheme(context).cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final release in ReleaseNotesData.releaseNotes) ...[
                      _buildReleaseSection(context, release),
                      if (release != ReleaseNotesData.releaseNotes.last)
                        SizedBox(height: appTheme(context).sectionSpacing),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReleaseSection(BuildContext context, ReleaseNote release) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Version header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: appTheme(context).cardPadding,
            vertical: appTheme(context).cardSpacing,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
          ),
          child: Row(
            children: [
              Icon(
                Icons.tag_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 20,
              ),
              SizedBox(width: appTheme(context).cardSpacing),
              Text(
                'Version ${release.version}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              Text(
                release.date,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withValues(alpha: 0.8),
                    ),
              ),
            ],
          ),
        ),

        SizedBox(height: appTheme(context).cardSpacing),

        // Features
        if (release.features.isNotEmpty) ...[
          _buildSectionTitle(context, '✨ New Features', Icons.star_rounded),
          SizedBox(height: appTheme(context).cardSpacing),
          ...release.features
              .map((feature) => _buildListItem(context, feature)),
          SizedBox(height: appTheme(context).sectionSpacing),
        ],

        // Improvements
        if (release.improvements.isNotEmpty) ...[
          _buildSectionTitle(
              context, '🚀 Improvements', Icons.trending_up_rounded),
          SizedBox(height: appTheme(context).cardSpacing),
          ...release.improvements
              .map((improvement) => _buildListItem(context, improvement)),
          SizedBox(height: appTheme(context).sectionSpacing),
        ],

        // Fixes
        if (release.fixes.isNotEmpty) ...[
          _buildSectionTitle(context, '🐛 Bug Fixes', Icons.bug_report_rounded),
          SizedBox(height: appTheme(context).cardSpacing),
          ...release.fixes.map((fix) => _buildListItem(context, fix)),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: appTheme(context).cardSpacing),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: appTheme(context).cardPadding,
        bottom: appTheme(context).cardSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: appTheme(context).cardSpacing),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
