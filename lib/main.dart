import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:today_i_learned/core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_i_learned/core/providers/providers.dart';
import 'package:today_i_learned/features/entries/entries_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final seedColor = ref.watch(colorNotifierProvider);
    final useDynamicColor = ref.watch(dynamicColorNotifierProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ThemeData lightTheme;
        ThemeData darkTheme;

        if (useDynamicColor && lightDynamic != null && darkDynamic != null) {
          lightTheme = AppTheme.light(lightDynamic.primary);
          darkTheme = AppTheme.dark(darkDynamic.primary);
        } else {
          lightTheme = AppTheme.light(seedColor);
          darkTheme = AppTheme.dark(seedColor);
        }

        return MaterialApp(
          title: 'Today I Learned',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: const EntriesScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
