// lib/profile.dart
import 'package:ecoalmaty/authorization.dart';
import 'package:ecoalmaty/registration.dart';
import 'package:ecoalmaty/supabase_config.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) togglePage;

  ProfilePage({required this.togglePage});

  @override
  _StateProfilePage createState() => _StateProfilePage();
}

class _StateProfilePage extends State<ProfilePage> {
  String selector = 'authorization';
  final DatabaseService _databaseService = DatabaseService();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _databaseService.signOut();
              widget.togglePage(0);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Фото профиля
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/avatar.jpg'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Чилловый парень',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),

            // Поля ввода
            ProfileTextField(
                label: 'Ваш ник', icon: Icons.person, value: 'Чилловый парень'),
            ProfileTextField(
                label: 'Почта',
                icon: Icons.email,
                value: 'Cherniyremenb@gmail.com',
                enabled: false),
            ProfileTextField(
                label: 'Пароль', icon: Icons.lock, isPassword: true),
            ProfileTextField(
                label: 'Новый пароль',
                icon: Icons.lock_outline,
                isPassword: true),
            ProfileTextField(
                label: 'Подтвердите пароль',
                icon: Icons.lock_outline,
                isPassword: true),

            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                side: BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Сохранить',
                  style: TextStyle(color: Colors.green, fontSize: 16)),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Виджет текстового поля
class ProfileTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final bool isPassword;
  final bool enabled;

  const ProfileTextField({
    required this.label,
    required this.icon,
    this.value,
    this.isPassword = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        obscureText: isPassword,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: Colors.black54,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(color: Colors.white),
        controller: value != null ? TextEditingController(text: value) : null,
      ),
    );
  }
}
