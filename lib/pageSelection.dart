import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/home.dart';
import 'package:ecoalmaty/permission.dart';
import 'package:ecoalmaty/profile.dart';
import 'package:ecoalmaty/request.dart';
import 'package:flutter/material.dart';

class PageSelection extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StatePageSelection();
  }
}

class _StatePageSelection extends State<PageSelection> {
  final AppPermission appPermission = AppPermission();

  @override
  void initState() {
    super.initState();
    _initializeApp(); // Запуск асинхронного процесса
  }

  Future<void> _initializeApp() async {
    // Проверяем разрешения и загружаем данные
    await AppPermission.checkAndRequestLocationPermission();
    await RequestCheck.init();
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Отображаем выбранную страницу
          _pages[_selectedIndex],
          // Горизонтальная панель снизу справа
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: AppSizes.width * 0.06, bottom: AppSizes.height * 0.03),
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.03, vertical: AppSizes.height * 0.01),
              decoration: BoxDecoration(
                color: Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Кнопка "Домой"
                  _buildNavigationItem(Icons.home, 0),
                  SizedBox(width: 12),
                  // Кнопка "Профиль"
                  _buildNavigationItem(Icons.person, 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(12),
        child: Icon(
          icon,
          color: isSelected ? Color(0xFF68E30B) : Colors.white24,
        ),
      ),
    );
  }
}
