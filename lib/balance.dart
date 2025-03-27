import 'package:Eco/appSizes.dart';
import 'package:Eco/currency_info.dart';
import 'package:Eco/pageSelection.dart';
import 'package:Eco/shop.dart';
import 'package:Eco/supabase_config.dart';
import 'package:Eco/titles.dart';
import 'package:Eco/top.dart';
import 'package:Eco/training_shop1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BalancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BalancePageState();
  }
}

class _BalancePageState extends State<BalancePage> {
  String name = DatabaseService.userName ?? 'Загрузка';
  int position = DatabaseService.userPosition ?? 0;
  final SupabaseClient supabase = Supabase.instance.client;
  final DatabaseService _databaseService = DatabaseService();
  bool isLoading = true;
  String rank = DatabaseService.userRank ?? '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Теперь userData поддерживает разные типы данных
  Map<String, dynamic>? userData;

  Future<void> _loadUserData() async {
    User? user = supabase.auth.currentUser;
    if (user != null) {
      String userId = user.id;
      Map<String, String>? fetchedUser =
          await _databaseService.fetchUser(userId);
      print(fetchedUser?['select_rank']);

      // Получаем badge отдельно
      Map<String, dynamic>? badge =
          _databaseService.getUserBadge(fetchedUser?['select_rank']);

      if (mounted) {
        setState(() {
          userData = fetchedUser?.map<String, dynamic>((key, value) =>
              MapEntry(key, value)); // Преобразуем в Map<String, dynamic>

          name = fetchedUser?['name'] ?? 'Загрузка';
          rank = fetchedUser?['rank_user'] ?? '0';
          position = int.tryParse(fetchedUser?['position'] ?? '0') ?? 0;
          isLoading = false;
          print(badge);

          // Добавляем badge в userData
          if (badge != null) {
            userData?['badge'] = badge['name'];
            userData?['badgeGradient'] = badge['color']; // Это LinearGradient
            userData?['badgeTextGradient'] =
                badge['colorText']; // Это LinearGradient
          }
        });
      }
    }
  }

  Future<void> _checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    if (!hasSeenOnboarding) {
      await prefs.setBool('seen_onboarding', true);
      Route route = MaterialPageRoute(builder: (context) => TrainingShop1());
      Navigator.pushReplacement(context, route);
    } else {
      Route route = MaterialPageRoute(builder: (context) => ShopPage());
      Navigator.pushReplacement(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          : Stack(
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        // Чтобы нижний контейнер мог перекрывать верхний
                        children: [
                          Container(
                            width: AppSizes.width,
                            height: AppSizes.height * 0.6,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/balance_background.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: AppSizes.width * 0.5,
                                  height: AppSizes.height * 0.3,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/container_balance.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: AppSizes.width * 0.05,
                                      height: AppSizes.height * 0.03,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/union_white.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.width * 0.03),
                                    Text(
                                      '${DatabaseService.balance}',
                                      style: TextStyle(
                                        fontSize: AppSizes.width * 0.08,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.height * 0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: AppSizes.height * 0.06,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppSizes.width * 0.02,
                                          vertical: AppSizes.height * 0.01),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                              builder: (context) => TopPage());
                                          Navigator.pushReplacement(
                                              context, route);
                                        },
                                        child: Center(
                                          child: Text(
                                            '$position место',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    AppSizes.width * 0.045),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.width * 0.01),
                                    GestureDetector(
                                      onTap: () {
                                        showCustomDialog(context, rank);
                                      },
                                      child: Container(
                                        height: AppSizes.height * 0.06,
                                        width: AppSizes.width * 0.3,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          gradient: userData?["badgeGradient"]
                                                  as Gradient? ??
                                              LinearGradient(
                                                colors: [
                                                  Colors.grey,
                                                  Colors.grey[300]!
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: ShaderMask(
                                            shaderCallback: (bounds) {
                                              return (userData?[
                                                              "badgeTextGradient"]
                                                          as Gradient?)
                                                      ?.createShader(bounds) ??
                                                  LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.grey[300]!
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ).createShader(bounds);
                                            },
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              userData?["badge"] ??
                                                  "Без титула",
                                              style: TextStyle(
                                                fontSize: AppSizes.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .white, // Цвет обязательно нужен для ShaderMask
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: AppSizes.height *
                                0.55, // Поднимаем контейнер вверх
                            left: 0,
                            right: 0,
                            child: Container(
                              width: AppSizes.width,
                              height: AppSizes.height * 0.05,
                              decoration: BoxDecoration(
                                color: Color(0xFF131010),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: AppSizes.width,
                        decoration: BoxDecoration(
                          color: Color(0xFF131010),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: AppSizes.width * 0.43,
                                    height: AppSizes.height * 0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      // border: Border.all(
                                      //   color: Color(0xFFA7EC6A), // Цвет границы
                                      //   width: 2,
                                      // ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/balance_container_background.png'),
                                        // Путь к изображению
                                        fit: BoxFit
                                            .cover, // Растянуть изображение на весь контейнер
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(AppSizes.width * 0.04),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Баланс',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppSizes.width * 0.06,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Показать всю \nсумму',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    AppSizes.width * 0.04),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                              builder: (context) =>
                                                  CurrencyInfo());
                                          Navigator.pushReplacement(
                                              context, route);
                                        },
                                        child: Container(
                                          width: AppSizes.width * 0.43,
                                          height: AppSizes.height * 0.155,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            // border: Border.all(
                                            //   color: Color(0xFFA7EC6A), // Цвет границы
                                            //   width: 2,
                                            // ),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/balance_container_background2.png'),
                                              // Путь к изображению
                                              fit: BoxFit
                                                  .cover, // Растянуть изображение на весь контейнер
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                AppSizes.width * 0.04),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Валюта',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppSizes.width * 0.07,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Подробности',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: AppSizes.width *
                                                          0.04),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppSizes.height * 0.04,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _checkIfFirstTime();
                                        },
                                        child: Container(
                                          width: AppSizes.width * 0.43,
                                          height: AppSizes.height * 0.155,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            // border: Border.all(
                                            //   color: Color(0xFFA7EC6A), // Цвет границы
                                            //   width: 2,
                                            // ),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/balance_container_background3.png'),
                                              // Путь к изображению
                                              fit: BoxFit
                                                  .cover, // Растянуть изображение на весь контейнер
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                AppSizes.width * 0.03),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Магазин',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppSizes.width * 0.06,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'покупка вещей за \nвнутреннюю валюту',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: AppSizes.width *
                                                          0.03),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppSizes.height * 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) => TopPage());
                                  Navigator.pushReplacement(context, route);
                                },
                                child: Container(
                                  width: AppSizes.width,
                                  height: AppSizes.height * 0.19,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    // border: Border.all(
                                    //   color: Color(0xFFA7EC6A), // Цвет границы
                                    //   width: 2,
                                    // ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/balance_container_background4.png'),
                                      // Путь к изображению
                                      fit: BoxFit
                                          .cover, // Растянуть изображение на весь контейнер
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: AppSizes.width * 0.05,
                                      right: AppSizes.width * 0.05,
                                      top: AppSizes.width * 0.05,
                                      bottom: AppSizes.width * 0.085,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Список лучших за \nДекабрь',
                                          style: TextStyle(
                                            color: Color(0xFF004B08),
                                            fontSize: AppSizes.width * 0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Топ 100',
                                            style: TextStyle(
                                              color: Color(0xFF148305),
                                              fontSize: AppSizes.width * 0.035,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'История покупок/переводов',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: AppSizes.height * 0.01,
                              ),
                              Container(
                                width: AppSizes.width,
                                height: AppSizes.height * 0.2,
                                decoration: BoxDecoration(
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.height * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: AppSizes.height * 0.01,
                        left: AppSizes.width * 0.03,
                        right: AppSizes.width * 0.03),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        '$name',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.07),
                      ),
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: AppSizes.width * 0.08,
                        ),
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => PageSelection());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void showCustomDialog(BuildContext context, String rankUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.width * 0.08),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Уникальные награды',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.width * 0.06),
                  ],
                ),
                SizedBox(height: AppSizes.height * 0.02),

                // Список наград
                _buildUserRanks(rankUser, supabase.auth.currentUser!.id),

                SizedBox(height: AppSizes.height * 0.01),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      setState(() {
        _loadUserData();
      });
    });
  }

// Функция, которая строит награды пользователя
  Widget _buildUserRanks(String rankUser, String userId) {
    List<int> userRanks = rankUser
        .split(',')
        .map((e) => int.tryParse(e) ?? -1)
        .where((e) => e >= 0)
        .toList();

    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.width * 0.01),
          child: Row(
            children: [
              // Левая награда
              Expanded(
                flex: 1,
                child: userRanks.contains(index)
                    ? _buildGradientButton(
                  Titles.titles[index]["name"],
                  Titles.titles[index]["color"],
                  Titles.titles[index]["colorText"],
                  index,
                  userId,
                )
                    : _buildEmptyBox(),
              ),
              SizedBox(width: AppSizes.width * 0.07),
              // Правая награда
              Expanded(
                flex: 1,
                child: userRanks.contains(index + 3)
                    ? _buildGradientButton(
                  Titles.titles[index + 3]["name"],
                  Titles.titles[index + 3]["color"],
                  Titles.titles[index + 3]["colorText"],
                  index + 3,
                  userId,
                )
                    : _buildEmptyBox(),
              ),
            ],
          ),
        );
      }),
    );
  }

// Градиентная кнопка для наград
  Widget _buildGradientButton(
      String text, LinearGradient backgroundGradient, LinearGradient textGradient, int rankIndex, String userId) {
    return GestureDetector(
      onTap: () async {
        await _databaseService.updateUserSelectRank(userId, rankIndex);
        Navigator.pop(context);
      },
      child: Container(
        height: AppSizes.height * 0.05,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width * 0.01),
          child: Center(
            child: FittedBox(
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    textGradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                blendMode: BlendMode.srcIn,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.width * 0.04,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Пустая награда (серый квадрат)
  Widget _buildEmptyBox() {
    return Container(
      height: AppSizes.height * 0.05,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 1),
      ),
    );
  }
}
