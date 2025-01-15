import 'package:ecoalmaty/pageSelection.dart';
import 'package:ecoalmaty/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseKey,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFF131010),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Цвет стрелки "назад" и иконок
          ),
        ),
      ),
      home: PageSelection(),
      debugShowCheckedModeBanner: false,
    );
  }
}
