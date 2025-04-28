import 'package:Eco/appSizes.dart';
import 'package:Eco/authorization.dart';
import 'package:Eco/double_back_to_exit.dart';
import 'package:Eco/home.dart';
import 'package:Eco/pageSelectionAdmin.dart';
import 'package:Eco/permission.dart';
import 'package:Eco/profile.dart';
import 'package:Eco/registration.dart';
import 'package:Eco/request.dart';
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
  }

  Future<void> _initializeApp() async {
    await AppPermission.checkAndRequestLocationPermission();
    await AppPermission.checkAndRequestCameraPermission();
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
      print(response);
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
    return DoubleBackToExitWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Если показываем профиль, то показываем экран загрузки
            if (_selectedIndex == 1)
              _isLoadingProfile
                  ? Container(
                      width: AppSizes.width,
                      height: AppSizes.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/app/loadPage.png'),
                          // Путь к изображению
                          fit: BoxFit
                              .cover, // Растянуть изображение на весь контейнер
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: AppSizes.width * 0.4,
                          height: AppSizes.height * 0.35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/app/loadLogo.png'),
                              // Путь к изображению
                              fit: BoxFit
                                  .cover, // Растянуть изображение на весь контейнер
                            ),
                          ),
                        ),
                      ),
                    )
                  : _profileSubPages[_profileSubIndex](_onSubPageTapped)
            else
              _pages[_selectedIndex](_onItemTapped),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                    right: AppSizes.width * 0.06,
                    bottom: AppSizes.height * 0.03),
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
