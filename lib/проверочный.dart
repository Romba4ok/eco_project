import 'package:ecoalmaty/supabase_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Инициализация Supabase
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseKey,
    );
    final SupabaseClient supabase = Supabase.instance.client;
    try {
      final res = await supabase.auth.signUp(
        email: 'roman140607@gmail.com',
        password: '12345678',
      );
    } catch (error) {
      print(error);
    }
  }
