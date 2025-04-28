import 'package:Eco/appSizes.dart';
import 'package:Eco/examples_completed.dart';
import 'package:Eco/examples_examples.dart';
import 'package:Eco/examples_special.dart';
import 'package:Eco/pageSelection.dart';
import 'package:Eco/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExamplesPage extends StatefulWidget {
  @override
  _ExamplesPageState createState() => _ExamplesPageState();
}

class _ExamplesPageState extends State<ExamplesPage> {
  bool isLoading = true;
  int totalExp = DatabaseService.experience ?? 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  final DatabaseService _databaseService = DatabaseService();
  final SupabaseClient supabase = Supabase.instance.client;
  String avatar = DatabaseService.userAvatar ?? '';
  String name = DatabaseService.userName ?? '';
  int balance = DatabaseService.balance ?? 0;

  int _selectedIndex = 0;

  Future<void> _loadUserData() async {
    User? user = supabase.auth.currentUser;
    if (user != null) {
      String userId = user.id;
      Map<String, String>? fetchedUser =
          await _databaseService.fetchUser(userId);
      await _databaseService.fetchExamplesUsers();
      if (mounted) {
        setState(() {
          avatar = fetchedUser?['avatar'] ?? '';
          name = fetchedUser?['name'] ?? '';
          balance = int.tryParse(fetchedUser?['balance'] ?? '0') ?? 0;
          totalExp = int.tryParse(fetchedUser?['experience'] ?? '0') ?? 0;
          _databaseService.updateUserRanksByExperience(totalExp);
          isLoading = false;
        });
      }
    }
  }

  final List<String> tabs = ['Задания', 'Особые', 'Выполненные'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget Function(Function(int))> _pages = [
    (togglePage) => ExamplesExamplesPage(togglePage: togglePage),
    (togglePage) => ExamplesSpecialPage(togglePage: togglePage),
    (togglePage) => ExamplesCompletedPage(togglePage: togglePage),
  ];

  @override
  Widget build(BuildContext context) {
    const int expPerLevel = 10000;
    int currentLevel = (totalExp ~/ expPerLevel);
    int nextLevel = currentLevel + 1;
    int expInCurrentLevel = totalExp % expPerLevel;
    double progress = expInCurrentLevel / expPerLevel;
    return Scaffold(
      body: isLoading
          ? Container(
              width: AppSizes.width,
              height: AppSizes.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/app/loadPage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: AppSizes.width * 0.4,
                  height: AppSizes.height * 0.35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/app/loadLogo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: AppSizes.height * 0.07,
                    left: AppSizes.width * 0.03,
                    right: AppSizes.width * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Кнопка назад
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: AppSizes.width * 0.08,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      // Заголовок по центру
                      Expanded(
                        child: Center(
                          child: Text(
                            'Ежедневные задания',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Аватар справа
                      CircleAvatar(
                        radius: AppSizes.width * 0.06,
                        backgroundImage:
                            (avatar.isNotEmpty ? NetworkImage(avatar) : null),
                        backgroundColor:
                            avatar.isEmpty ? Colors.white : Colors.transparent,
                        child: avatar.isEmpty
                            ? Text(
                                name.isNotEmpty ? name[0] : '?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: AppSizes.width * 0.08,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: AppSizes.width * 0.06,
                      height: AppSizes.width * 0.06,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/coin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      ': $balance',
                      // ПРАВИЛЬНО
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.width * 0.055),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.02),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.width * 0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Текущий уровень слева
                      Container(
                        width: AppSizes.width * 0.09,
                        height: AppSizes.height * 0.04,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$currentLevel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(width: AppSizes.width * 0.02),

                      // Прогресс бар
                      Flexible(
                        child: Stack(
                          children: [
                            Container(
                              height: AppSizes.height * 0.04,
                              decoration: BoxDecoration(
                                color: Color(0xFF252222),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress,
                              // значение от 0.0 до 1.0
                              child: Container(
                                height: AppSizes.height * 0.04,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green,
                                      Colors.lightGreenAccent
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: AppSizes.width * 0.02),

                      // Следующий уровень справа
                      Container(
                        width: AppSizes.width * 0.09,
                        height: AppSizes.height * 0.04,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFF252222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$nextLevel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSizes.height * 0.02,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(tabs.length, (index) {
                      final isSelected = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          width: AppSizes.width * 0.28,
                          height: AppSizes.height * 0.05,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF68E30B)
                                : Colors.transparent,
                            border: Border.all(color: Color(0xFF68E30B)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Color(0xFF68E30B),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: _pages[_selectedIndex](_onItemTapped),
                )
              ],
            ),
    );
  }
}
