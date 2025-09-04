import "package:flutter/material.dart";

// Custom theme extension for app-specific styling constants
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.cardPadding,
    required this.cardSpacing,
    required this.sectionSpacing,
    required this.borderRadius,
    required this.largeBorderRadius,
    required this.buttonPadding,
    required this.inputPadding,
    required this.listItemPadding,
    required this.listItemSpacing,
  });

  final double cardPadding;
  final double cardSpacing;
  final double sectionSpacing;
  final double borderRadius;
  final double largeBorderRadius;
  final double buttonPadding;
  final double inputPadding;
  final double listItemPadding;
  final double listItemSpacing;

  @override
  AppThemeExtension copyWith({
    double? cardPadding,
    double? cardSpacing,
    double? sectionSpacing,
    double? borderRadius,
    double? largeBorderRadius,
    double? buttonPadding,
    double? inputPadding,
    double? listItemPadding,
    double? listItemSpacing,
  }) {
    return AppThemeExtension(
      cardPadding: cardPadding ?? this.cardPadding,
      cardSpacing: cardSpacing ?? this.cardSpacing,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      borderRadius: borderRadius ?? this.borderRadius,
      largeBorderRadius: largeBorderRadius ?? this.largeBorderRadius,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      inputPadding: inputPadding ?? this.inputPadding,
      listItemPadding: listItemPadding ?? this.listItemPadding,
      listItemSpacing: listItemSpacing ?? this.listItemSpacing,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      cardPadding: cardPadding,
      cardSpacing: cardSpacing,
      sectionSpacing: sectionSpacing,
      borderRadius: borderRadius,
      largeBorderRadius: largeBorderRadius,
      buttonPadding: buttonPadding,
      inputPadding: inputPadding,
      listItemPadding: listItemPadding,
      listItemSpacing: listItemSpacing,
    );
  }
}

// Helper function to get app theme extension
AppThemeExtension appTheme(BuildContext context) {
  return Theme.of(context).extension<AppThemeExtension>() ??
      const AppThemeExtension(
        cardPadding: 16.0,
        cardSpacing: 16.0,
        sectionSpacing: 24.0,
        borderRadius: 12.0,
        largeBorderRadius: 16.0,
        buttonPadding: 16.0,
        inputPadding: 16.0,
        listItemPadding: 16.0,
        listItemSpacing: 8.0,
      );
}

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      // Primary: Deep Ocean Blue
      primary: Color(0xFF1E3A8A), // Deep blue
      surfaceTint: Color(0xFF1E3A8A),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE0E7FF), // Light blue container
      onPrimaryContainer: Color(0xFF1E3A8A),
      // Secondary: Vibrant Pink
      secondary: Color(0xFFE91E63), // Hot pink
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFFE0E6), // Light pink container
      onSecondaryContainer: Color(0xFFE91E63),
      // Tertiary: Electric Blue
      tertiary: Color(0xFF0EA5E9), // Electric blue
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFE0F2FE), // Light electric blue container
      onTertiaryContainer: Color(0xFF0EA5E9),
      // Error: Coral Red
      error: Color(0xFFEF4444),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFFEF4444),
      // Surface: Clean whites with subtle tints
      surface: Color(0xFFFAFAFA), // Off-white
      onSurface: Color(0xFF1F2937), // Dark gray
      onSurfaceVariant: Color(0xFF6B7280), // Medium gray
      outline: Color(0xFFD1D5DB), // Light gray
      outlineVariant: Color(0xFFE5E7EB), // Very light gray
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF1F2937),
      inversePrimary: Color(0xFF93C5FD), // Light blue
      primaryFixed: Color(0xFFE0E7FF),
      onPrimaryFixed: Color(0xFF1E3A8A),
      primaryFixedDim: Color(0xFF93C5FD),
      onPrimaryFixedVariant: Color(0xFF1E40AF),
      secondaryFixed: Color(0xFFFFE0E6),
      onSecondaryFixed: Color(0xFFE91E63),
      secondaryFixedDim: Color(0xFFFFB3C1),
      onSecondaryFixedVariant: Color(0xFFC2185B),
      tertiaryFixed: Color(0xFFE0F2FE),
      onTertiaryFixed: Color(0xFF0EA5E9),
      tertiaryFixedDim: Color(0xFF7DD3FC),
      onTertiaryFixedVariant: Color(0xFF0284C7),
      surfaceDim: Color(0xFFF3F4F6),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF9FAFB),
      surfaceContainer: Color(0xFFF3F4F6),
      surfaceContainerHigh: Color(0xFFE5E7EB),
      surfaceContainerHighest: Color(0xFFD1D5DB),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004d30),
      surfaceTint: Color(0xff266a49),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3f815e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff33473b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff647a6b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1e4855),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff527a88),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff171d19),
      onSurfaceVariant: Color(0xff3c453f),
      outline: Color(0xff59615a),
      outlineVariant: Color(0xff747d76),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff91d5ad),
      primaryFixed: Color(0xff3f815e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff246847),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff647a6b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4b6153),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff527a88),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff39616f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd6dbd5),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ee),
      surfaceContainer: Color(0xffeaefe9),
      surfaceContainerHigh: Color(0xffe4eae3),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002817),
      surfaceTint: Color(0xff266a49),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004d30),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff12261b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff33473b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002630),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1e4855),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1e2620),
      outline: Color(0xff3c453f),
      outlineVariant: Color(0xff3c453f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xffb6fbd1),
      primaryFixed: Color(0xff004d30),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00341f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff33473b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1d3125),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1e4855),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00313e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd6dbd5),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ee),
      surfaceContainer: Color(0xffeaefe9),
      surfaceContainerHigh: Color(0xffe4eae3),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // Primary: Bright Ocean Blue
      primary: Color(0xFF60A5FA), // Bright blue
      surfaceTint: Color(0xFF60A5FA),
      onPrimary: Color(0xFF0F172A), // Very dark blue
      primaryContainer: Color(0xFF1E40AF), // Dark blue container
      onPrimaryContainer: Color(0xFFDBEAFE), // Light blue text
      // Secondary: Neon Pink
      secondary: Color(0xFFFF6B9D), // Bright pink
      onSecondary: Color(0xFF4A0E2E), // Very dark pink
      secondaryContainer: Color(0xFFAD1457), // Dark pink container
      onSecondaryContainer: Color(0xFFFFE0E6), // Light pink text
      // Tertiary: Cyan Blue
      tertiary: Color(0xFF22D3EE), // Bright cyan
      onTertiary: Color(0xFF083344), // Very dark cyan
      tertiaryContainer: Color(0xFF0369A1), // Dark cyan container
      onTertiaryContainer: Color(0xFFE0F2FE), // Light cyan text
      // Error: Bright Red
      error: Color(0xFFF87171),
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFFB91C1C),
      onErrorContainer: Color(0xFFFEE2E2),
      // Surface: Dark grays with blue tints
      surface: Color(0xFF0F172A), // Very dark blue-gray
      onSurface: Color(0xFFF1F5F9), // Light gray
      onSurfaceVariant: Color(0xFF94A3B8), // Medium gray
      outline: Color(0xFF475569), // Dark gray
      outlineVariant: Color(0xFF334155), // Very dark gray
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFF1F5F9),
      inversePrimary: Color(0xFF1E40AF), // Dark blue
      primaryFixed: Color(0xFF1E40AF),
      onPrimaryFixed: Color(0xFFDBEAFE),
      primaryFixedDim: Color(0xFF3B82F6),
      onPrimaryFixedVariant: Color(0xFF1E3A8A),
      secondaryFixed: Color(0xFFAD1457),
      onSecondaryFixed: Color(0xFFFFE0E6),
      secondaryFixedDim: Color(0xFFE91E63),
      onSecondaryFixedVariant: Color(0xFFC2185B),
      tertiaryFixed: Color(0xFF0369A1),
      onTertiaryFixed: Color(0xFFE0F2FE),
      tertiaryFixedDim: Color(0xFF0EA5E9),
      onTertiaryFixedVariant: Color(0xFF0284C7),
      surfaceDim: Color(0xFF0F172A),
      surfaceBright: Color(0xFF1E293B),
      surfaceContainerLowest: Color(0xFF0A0F1A),
      surfaceContainerLow: Color(0xFF1E293B),
      surfaceContainer: Color(0xFF334155),
      surfaceContainerHigh: Color(0xFF475569),
      surfaceContainerHighest: Color(0xFF64748B),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff95d9b1),
      surfaceTint: Color(0xff91d5ad),
      onPrimary: Color(0xff001b0e),
      primaryContainer: Color(0xff5c9e79),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb9d1bf),
      onSecondary: Color(0xff061a10),
      secondaryContainer: Color(0xff7f9687),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa8d1e1),
      onTertiary: Color(0xff001921),
      tertiaryContainer: Color(0xff6f97a5),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1511),
      onSurface: Color(0xfff7fcf5),
      onSurfaceVariant: Color(0xffc4cdc5),
      outline: Color(0xff9ca59d),
      outlineVariant: Color(0xff7c857e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff055334),
      primaryFixed: Color(0xffacf2c8),
      onPrimaryFixed: Color(0xff00150a),
      primaryFixedDim: Color(0xff91d5ad),
      onPrimaryFixedVariant: Color(0xff003f26),
      secondaryFixed: Color(0xffd0e8d7),
      onSecondaryFixed: Color(0xff02150b),
      secondaryFixedDim: Color(0xffb5ccbb),
      onSecondaryFixedVariant: Color(0xff263b2e),
      tertiaryFixed: Color(0xffbfe9f9),
      onTertiaryFixed: Color(0xff00141a),
      tertiaryFixedDim: Color(0xffa4cddc),
      onTertiaryFixedVariant: Color(0xff0d3b48),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff353b36),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff171d19),
      surfaceContainer: Color(0xff1b211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff303632),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffeefff1),
      surfaceTint: Color(0xff91d5ad),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff95d9b1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffeefff1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb9d1bf),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff5fcff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa8d1e1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff4fdf4),
      outline: Color(0xffc4cdc5),
      outlineVariant: Color(0xffc4cdc5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff00311d),
      primaryFixed: Color(0xffb0f6cc),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff95d9b1),
      onPrimaryFixedVariant: Color(0xff001b0e),
      secondaryFixed: Color(0xffd5eddb),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb9d1bf),
      onSecondaryFixedVariant: Color(0xff061a10),
      tertiaryFixed: Color(0xffc4edfe),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa8d1e1),
      onTertiaryFixedVariant: Color(0xff001921),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff353b36),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff171d19),
      surfaceContainer: Color(0xff1b211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff303632),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  // App-specific styling constants
  static const double cardPadding = 16.0;
  static const double cardSpacing = 16.0;
  static const double sectionSpacing = 24.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double buttonPadding = 16.0;
  static const double inputPadding = 16.0;
  static const double listItemPadding = 16.0;
  static const double listItemSpacing = 8.0;

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        extensions: const [
          AppThemeExtension(
            cardPadding: 16.0,
            cardSpacing: 16.0,
            sectionSpacing: 24.0,
            borderRadius: 12.0,
            largeBorderRadius: 16.0,
            buttonPadding: 16.0,
            inputPadding: 16.0,
            listItemPadding: 16.0,
            listItemSpacing: 8.0,
          ),
        ],

        // Enhanced AppBar theme
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),

        // Enhanced Card theme
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: colorScheme.surfaceContainerLow,
        ),

        // Enhanced Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shadowColor: colorScheme.primary.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Enhanced Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),

        // Enhanced TabBar theme
        tabBarTheme: TabBarThemeData(
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 3,
            ),
            insets: const EdgeInsets.symmetric(horizontal: 16),
          ),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),

        // Enhanced Switch theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.onSurfaceVariant;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary.withValues(alpha: 0.3);
            }
            return colorScheme.surfaceContainerHigh;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            return Colors.transparent;
          }),
        ),

        // Enhanced IconButton theme
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
