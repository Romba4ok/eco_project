import 'package:Eco/add_example.dart';
import 'package:Eco/add_post.dart';
import 'package:Eco/add_sponsor.dart';
import 'package:Eco/appSizes.dart';
import 'package:Eco/edit_post.dart';
import 'package:Eco/edit_example.dart';
import 'package:Eco/edit_sponsor.dart';
import 'package:Eco/pageSelection.dart';
import 'package:Eco/shop_admin.dart';
import 'package:Eco/supabase_config.dart';
import 'package:Eco/users_admin.dart';
import 'package:flutter/material.dart';

class PageSelectionAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatePageSelectionAdmin();
  }
}

class _StatePageSelectionAdmin extends State<PageSelectionAdmin> {
  int _selectedIndex = 0;
  int _postSubIndex = 0;
  int _exampleSubIndex = 0;
  final DatabaseService _databaseService = DatabaseService();

  final List<Widget Function(Function(int))> _postSubPages = [
    (togglePage) => AddPostPage(togglePage: togglePage),
    (togglePage) => EditPostPage(togglePage: togglePage),
  ];

  final List<Widget Function(Function(int))> _exampleSubPages = [
    (togglePage) => AddExamplePage(togglePage: togglePage),
    (togglePage) => EditExamplePage(togglePage: togglePage),
    (togglePage) => AddSponsorPage(togglePage: togglePage),
    (togglePage) => EditSponsorPage(togglePage: togglePage),
  ];

  final List<Widget Function(Function(int))> _pages = [
    (togglePage) => UsersPage(),
    (togglePage) => ShopPageAdmin(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == 4) {
      // Выход из аккаунта
      await _databaseService.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PageSelection()));
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostSubPageTapped(int index) {
    setState(() {
      _selectedIndex = 1;
      _postSubIndex = index;
    });
  }

  void _onExampleSubPageTapped(int index) {
    setState(() {
      _selectedIndex = 0;
      _exampleSubIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _selectedIndex == 0
                ? _exampleSubPages[_exampleSubIndex](_onExampleSubPageTapped)
                : (_selectedIndex == 1
                    ? _postSubPages[_postSubIndex](_onPostSubPageTapped)
                    : _pages[_selectedIndex - 2](_onItemTapped)),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: AppSizes.width * 0.2,
      decoration: BoxDecoration(
        color: Color(0xFF131010),
        border: Border(right: BorderSide(color: Color(0xFF2A2A2A), width: 2.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max, // 🔹 Указываем, что Column должен занять максимум
        children: [
          SizedBox(height: AppSizes.height * 0.07),
          Image.asset('assets/images/union.png'),
          SizedBox(height: AppSizes.height * 0.07), // Уменьши отступ
          Expanded( // 🔹 Растягиваем всё меню
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 🔹 Центрируем
              children: [
                _buildDrawerItem(Icons.expand, 0, _selectedIndex == 0),
                _buildDrawerItem(Icons.edit, 1, _selectedIndex == 1),
                _buildDrawerItem(Icons.people, 2, _selectedIndex == 2),
                _buildDrawerItem(Icons.shopping_bag, 3, _selectedIndex == 3),
              ],
            ),
          ),
          _buildDrawerItem(Icons.logout, 4, false), // 🔹 Logout всегда внизу
          SizedBox(height: AppSizes.height * 0.07),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.height * 0.015),
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
