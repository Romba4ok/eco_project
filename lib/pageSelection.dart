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
  bool _isLoadingProfile =
      true; // Переменная для отслеживания загрузки на экране профиля

  @override
  void initState() {
    super.initState();
    _initializeApp();
    // checkUser(); // Убираем checkUser из initState, чтобы он запускался только при переходе на экран профиля
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
          setState(() {
            _profileSubIndex = 2;
            _isLoadingProfile =
                false; // После загрузки данных обновляем состояние
          });
        } else if (userCheck == 'admin') {
          setState(() {
            _isLoadingProfile =
                false; // После загрузки данных обновляем состояние
          });
          Route route =
              MaterialPageRoute(builder: (context) => PageSelectionAdmin());
          Navigator.pushReplacement(context, route);
        }
      } else {
        setState(() {
          _isLoadingProfile =
              false; // Если ошибка, то также обновляем состояние
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: Роль пользователя не найдена.')),
        );
      }
    } else {
      setState(() {
        _isLoadingProfile = false; // Если пользователь не авторизован
      });
    }
  }

  final List<Widget Function(Function(int))> _profileSubPages = [
    (togglePage) => Authorization(togglePage: togglePage),
    (togglePage) => Registration(togglePage: togglePage),
    (togglePage) => ProfilePage(togglePage: togglePage),
  ];

  final List<Widget Function(Function(int))> _pages = [
    (togglePage) => HomePage(togglePage: togglePage),
    (togglePage) => Container(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _isLoadingProfile = true; // Показываем индикатор загрузки
        checkUser();
      }
    });
  }
  void _onSubPageTapped(int index) {
    setState(() {
      _profileSubIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Если показываем профиль, то показываем экран загрузки
          if (_selectedIndex == 1)
            _isLoadingProfile
                ? Center(child: CircularProgressIndicator())
                : _profileSubPages[_profileSubIndex](_onSubPageTapped)
          else
            _pages[_selectedIndex](_onItemTapped),
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
