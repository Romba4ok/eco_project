import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/authorization.dart';
import 'package:ecoalmaty/home.dart';
import 'package:ecoalmaty/pageSelectionAdmin.dart';
import 'package:ecoalmaty/permission.dart';
import 'package:ecoalmaty/profile.dart';
import 'package:ecoalmaty/registration.dart';
import 'package:ecoalmaty/request.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatePageSelection();
  }
}

class _StatePageSelection extends State<PageSelection> {
  final AppPermission appPermission = AppPermission();
  final SupabaseClient supabase = Supabase.instance.client;
  int _selectedIndex = 0;
  int _profileSubIndex = 0;
  String? userCheck;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    checkUser();
  }

  Future<void> _initializeApp() async {
    await AppPermission.checkAndRequestLocationPermission();
    await RequestCheck.init();
  }

  Future<void> checkUser() async {
    User? user = supabase.auth.currentUser;
    if (user != null) {
      String id = user.id;
      print(id);
      final response = await supabase
          .from('users')
          .select('user')
          .eq('id', user.id)
          .single();
      if (response != null && response['user'] != null) {
        final String userCheck = response['user'];
        print(userCheck);
        if (userCheck == 'user') {
          _profileSubIndex = 2;
        } else if (userCheck == 'admin') {
          Route route =
          MaterialPageRoute(builder: (context) => PageSelectionAdmin());
          Navigator.pushReplacement(
              context, route);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: Роль пользователя не найдена.')),
        );
      }
    }
  }

  final List<Widget Function(Function(int))> _profileSubPages = [
        (togglePage) => Authorization(togglePage: togglePage),
        (togglePage) => Registration(togglePage: togglePage),
        (togglePage) => ProfilePage(togglePage: togglePage),
  ];

  final List<Widget> _pages = [
    HomePage(),
    Container(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSubPageTapped(int index) {
    setState(() {
      _profileSubIndex = index;
      // checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _selectedIndex == 0
              ? _pages[_selectedIndex]
              : _profileSubPages[_profileSubIndex](
              _onSubPageTapped),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(
                  right: AppSizes.width * 0.06, bottom: AppSizes.height * 0.03),
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width * 0.03,
                  vertical: AppSizes.height * 0.01),
              decoration: BoxDecoration(
                color: Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavigationItem(Icons.home, 0),
                  SizedBox(width: 12),
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
