/// GreenCycle branding: greens + earthy accent, Material 3.
library;

import 'package:flutter/material.dart';

class GColors {
  GColors._();

  static const seed = Color(0xFF2E7D32);
  static const leaf = Color(0xFF43A047);
  static const deepGreen = Color(0xFF1B5E20);
  static const mint = Color(0xFFE8F5E9);
  static const sand = Color(0xFFF9F7F2);
  static const amber = Color(0xFFF9A825);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: GColors.seed,
    primary: GColors.seed,
    secondary: GColors.amber,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: GColors.sand,
    appBarTheme: const AppBarTheme(
      backgroundColor: GColors.seed,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(88, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}

Color categoryColor(String categoryLabel) => switch (categoryLabel) {
      'Plastic' => const Color(0xFF1E88E5),
      'Metal' => const Color(0xFF757575),
      'Paper' => const Color(0xFF8D6E63),
      _ => const Color(0xFF6D4C41),
    };

IconData categoryIcon(String categoryLabel) => switch (categoryLabel) {
      'Plastic' => Icons.local_drink_outlined,
      'Metal' => Icons.settings_outlined,
      'Paper' => Icons.description_outlined,
      _ => Icons.delete_outline,
    };

/// Shared card wrapper used across all four pages.
class GCard extends StatelessWidget {
  const GCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: card,
    );
  }
}
