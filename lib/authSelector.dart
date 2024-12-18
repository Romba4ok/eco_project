// lib/authorization.dart
import 'package:flutter/material.dart';
import 'profile.dart'; // Импортируем ProfilePage и его State

class OtherPage extends StatelessWidget {
  final GlobalKey<_StateProfilePage> _profilePageKey = GlobalKey<_StateProfilePage>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _profilePageKey.currentState?.setState(() {
              _profilePageKey.currentState?.selector = 'registration'; // Меняем состояние на 'registration'
            });
          },
          child: Text('Switch to Registration'),
        ),
      ),
    );
  }
}
