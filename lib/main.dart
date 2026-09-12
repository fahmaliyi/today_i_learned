import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:today_i_learned/core/theme/theme.dart';
import 'package:today_i_learned/features/entries/entries_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today I Learned',

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      home: const EntriesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
