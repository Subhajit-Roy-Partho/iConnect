import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import '../data/repositories.dart';

class AppTheme {
  static ThemeData light() {
    const seed = Color(0xFF0B6E4F);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF5F6F1),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),
    );
  }

  static ThemeData dark() {
    const seed = Color(0xFF57C785);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF101714),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
    );
  }
}

final Map<TerminalThemePreset, TerminalTheme> terminalThemes = {
  TerminalThemePreset.midnight: const TerminalTheme(
    cursor: Color(0xFFB0F2C2),
    selection: Color(0x6656C596),
    foreground: Color(0xFFE8F5EE),
    background: Color(0xFF08120D),
    black: Color(0xFF08120D),
    red: Color(0xFFE57373),
    green: Color(0xFF57C785),
    yellow: Color(0xFFEBCB6B),
    blue: Color(0xFF5EA3F0),
    magenta: Color(0xFFC792EA),
    cyan: Color(0xFF63C7D7),
    white: Color(0xFFD8E7DF),
    brightBlack: Color(0xFF42524A),
    brightRed: Color(0xFFFF8C8C),
    brightGreen: Color(0xFF87E2A9),
    brightYellow: Color(0xFFF9E08E),
    brightBlue: Color(0xFF89BCFF),
    brightMagenta: Color(0xFFE1B5FF),
    brightCyan: Color(0xFF92E8F4),
    brightWhite: Color(0xFFFFFFFF),
    searchHitBackground: Color(0xFFB7E66D),
    searchHitBackgroundCurrent: Color(0xFF57C785),
    searchHitForeground: Color(0xFF08120D),
  ),
  TerminalThemePreset.glacier: const TerminalTheme(
    cursor: Color(0xFF0E7490),
    selection: Color(0x5538BDF8),
    foreground: Color(0xFF082F49),
    background: Color(0xFFF0FDFF),
    black: Color(0xFF0F172A),
    red: Color(0xFFBE123C),
    green: Color(0xFF047857),
    yellow: Color(0xFFCA8A04),
    blue: Color(0xFF0369A1),
    magenta: Color(0xFF7E22CE),
    cyan: Color(0xFF0F766E),
    white: Color(0xFFF8FAFC),
    brightBlack: Color(0xFF475569),
    brightRed: Color(0xFFE11D48),
    brightGreen: Color(0xFF10B981),
    brightYellow: Color(0xFFEAB308),
    brightBlue: Color(0xFF38BDF8),
    brightMagenta: Color(0xFFA855F7),
    brightCyan: Color(0xFF22D3EE),
    brightWhite: Color(0xFFFFFFFF),
    searchHitBackground: Color(0xFFFACC15),
    searchHitBackgroundCurrent: Color(0xFF38BDF8),
    searchHitForeground: Color(0xFF082F49),
  ),
  TerminalThemePreset.daybreak: const TerminalTheme(
    cursor: Color(0xFFF97316),
    selection: Color(0x55FB923C),
    foreground: Color(0xFF431407),
    background: Color(0xFFFFF7ED),
    black: Color(0xFF1C1917),
    red: Color(0xFFB91C1C),
    green: Color(0xFF15803D),
    yellow: Color(0xFFCA8A04),
    blue: Color(0xFF1D4ED8),
    magenta: Color(0xFF9333EA),
    cyan: Color(0xFF0F766E),
    white: Color(0xFFF5F5F4),
    brightBlack: Color(0xFF78716C),
    brightRed: Color(0xFFEF4444),
    brightGreen: Color(0xFF22C55E),
    brightYellow: Color(0xFFF59E0B),
    brightBlue: Color(0xFF3B82F6),
    brightMagenta: Color(0xFFA855F7),
    brightCyan: Color(0xFF14B8A6),
    brightWhite: Color(0xFFFFFFFF),
    searchHitBackground: Color(0xFFF59E0B),
    searchHitBackgroundCurrent: Color(0xFFF97316),
    searchHitForeground: Color(0xFF431407),
  ),
};
