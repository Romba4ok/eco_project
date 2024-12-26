import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/add_post.dart';
import 'package:ecoalmaty/edit_post.dart';
import 'package:ecoalmaty/shop_admin.dart';
import 'package:ecoalmaty/users_admin.dart';
import 'package:flutter/material.dart';

class PageSelectionAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatePageSelectionAdmin();
  }
}

class _StatePageSelectionAdmin extends State<PageSelectionAdmin> {
  int _selectedIndex = 0;

  final List<Widget Function(VoidCallback)> _pages = [
        (togglePage) => AddPostPage(togglePage: togglePage),
        (togglePage) => EditPostPage(togglePage: togglePage),
        (_) => UsersPage(),
        (_) => ShopPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleAddEditPage() {
    setState(() {
      // Переключаемся между AddPostPage и EditPostPage
      if (_selectedIndex == 0) {
        _selectedIndex = 1;
      } else if (_selectedIndex == 1) {
        _selectedIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    return Scaffold(
      body: Row(
        children: [
          // Узкая боковая панель
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF131010),
              border: Border(
                right: BorderSide(
                  color: Color(0xFF2A2A2A),
                  width: 2.0,
                ),
              ),
            ),
            width: AppSizes.width * 0.2,
            child: Column(
              children: [
                SizedBox(height: AppSizes.height * 0.07),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: AppSizes.height * 0.02,
                  ),
                  child: Image.asset('assets/images/union.png'),
                ),
                SizedBox(height: 200),
                Center(
                  child: Column(
                    children: [
                      _buildDrawerItem(Icons.edit, 0),
                      _buildDrawerItem(Icons.home, 2),
                      _buildDrawerItem(Icons.shopping_bag, 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Основной контент
          Expanded(
            child: _pages[_selectedIndex](toggleAddEditPage),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index || (_selectedIndex == 0 || _selectedIndex == 1) && index == 0;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.height * 0.01),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Color(0xFF68E30B) : Color(0xFF2A2A2A),
        ),
        padding: EdgeInsets.all(AppSizes.width * 0.035),
        child: Icon(
          icon,
          color: isSelected ? Color(0xFF525252) : Color(0xFFA3E567),
          size: AppSizes.width * 0.07,
        ),
      ),
    );
  }
}
