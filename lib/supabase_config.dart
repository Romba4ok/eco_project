import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://hoyajrqksmfnocgacoxf.supabase.co';
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhveWFqcnFrc21mbm9jZ2Fjb3hmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NTA1MTAsImV4cCI6MjA1MjQyNjUxMH0.8JxmAnPEMwMhXGCMbSBtPRW-_OfujlT7XDFF-gGstbQ'; // Замените на ваш ключ API

  static final SupabaseClient client = SupabaseClient(supabaseUrl, supabaseKey);
}

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}